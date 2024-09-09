import Foundation

final class PairsPresenter {
    private let model = PairsModel()
    weak var mainViewController: PairsViewController?
    weak var secondViewController: FilterViewController?
    
    var myCells: [PairTableViewCell?] {
        return model.myCells
    }
    
    var curWeek: Int { model.curWeek }
    var semStartDate: Date { model.semStartDate }
    var semEndDate: Date { model.semEndDate }
    var FreeCabinets: [[[[String]]]] { model.FreeCabinets }
    var curDay: Int { model.curDay }
    var daysOfWeak: [String] { model.daysOfWeak }
    var curWeekInMain: Int { model.curWeekInMain }
    var cellForReloadIndexes: [Int] { model.cellForReloadIndexes }
    var curWeekInFilter: Int { model.curWeekInFilter }
    var curWeekDayInFilter: Int { model.curWeekDayInFilter }
    
    
    func didLoadView(completion: @escaping ((Result<Any, Error>) -> Void)) {
        model.cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
        model.semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
        
        if model.cabinetsStringFromFile == "" || model.semesterStartFromFile == "" {
            loadAllData { result in
                switch result {
                case .success(_):
                    self.model.calculateCurWeek()
                    self.initCells()
                    completion(.success((Any).self))
                    break
                    
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        } else {
            model.parseCabinetsFile()
            self.model.calculateCurWeek()
            self.initCells()
            completion(.success((Any).self))
        }
    }
    
    func loadAllData(completion: @escaping ((Result<Any, Error>) -> Void)) {
        model.loadAndParseCabinetsFileFromFirebase { result in
            switch result {
            case .success(_):
                self.model.loadAndSetCurWeekFromFirebase { result in
                    switch result {
                    case .success(_):
                        self.model.parseCabinetsFile()
                        completion(.success((Any).self))
                        break
                        
                    case .failure(let error):
                        completion(.failure(error))
                        break
                    }
                }
                break
                
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    

    func initCells() {
        var indexPath: IndexPath = IndexPath(row: 0, section: 0)
        for i in 0...6 {
            indexPath.row = i
            indexPath.section = 0
            model.myCells[i] = mainViewController!.tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
            model.myCells[i]?.wasConfiguredFlag = 0
        }
    }
    
    func unconfigCells() {
        model.myCells.forEach {$0?.wasConfiguredFlag = 0}
    }
    
    func loadSecondController() {
        secondViewController!.presenter = self
    }
    
    func setup() {
        model.setup()
    }
    
    func didChangeWeek() {
        model.curWeekInMain = curWeek - 1
        model.curNumOrDenom = (curWeek-1) % 2
    }
    
    func didChooseDay(dayChoosed: Int?) {
        model.curDay = dayChoosed ?? 0
        mainViewController!.reloadTableData()
    }
    
    func didReloadTableData() {
        model.cellForReloadIndexes = []
        unconfigCells()
    }
    
    func didChooseAnotherWeek(with ind: Int, _ reloadFlag: Int? = nil) {
        let calendar = Calendar.current
        let buttonsStartDate = calendar.date(byAdding: .day, value: ind * 7 + 1, to: semStartDate)!
        
        model.daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
        var i = 0
        for delta in 0...5 {
            model.daysOfWeak[i] += String(calendar.component(.day, from: calendar.date(byAdding: .day, value: delta, to: buttonsStartDate) ?? buttonsStartDate))
            i += 1
        }
        
        if reloadFlag == nil {
            model.curDay = 0
        }
    }
    
    func didSuccessfullyLoadData() {
        model.setCurDay()
        mainViewController!.didChooseAnotherWeek(with: curWeek - 1, 1)
        mainViewController!.loadTableData()
        mainViewController!.setWeekOnWeekButton()
    }
    
    func configCellForRow(with indexPath: IndexPath) {
        let cell = myCells[indexPath.row]
        
        if cell?.wasConfiguredFlag == 0 {
            cell?.loadCabinets(Cabinets: FreeCabinets[model.curNumOrDenom][curDay][indexPath.row])
            cell?.config(with: indexPath.row)
        }
    }
    
    func didTapOnCell(with indexPath: IndexPath) {
        if !cellForReloadIndexes.contains(indexPath.row) {
            model.cellForReloadIndexes.append(indexPath.row)
            mainViewController!.tableView.beginUpdates()
            myCells[indexPath.row]?.config2(with: indexPath.row)
            mainViewController!.tableView.endUpdates()
        } else {
            model.cellForReloadIndexes = cellForReloadIndexes.filter{$0 != indexPath.row}
            mainViewController!.tableView.beginUpdates()
            myCells[indexPath.row]?.config(with: indexPath.row)
            mainViewController!.tableView.endUpdates()
        }
    }
    
    func didSelectWeekByPicker(at row: Int) {
        model.curNumOrDenom = row % 2
        model.curWeekInMain = row
        mainViewController!.didChooseAnotherWeek(with: row)
    }
    
    func setCorrectCurrentDate() -> Date {
        if Calendar.current.component(.weekday, from: Date()) - 2 == -1 {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }
        
        return Date()
    }
    
    func didCheckDate(dateToCheck: Date) {
        let calendar = Calendar.current
        model.semEndDate = calendar.date(byAdding: .day, value: 7*17, to: semStartDate)!
        
        let deltaSecs = dateToCheck - self.semStartDate
        model.curWeekInFilter = Int(deltaSecs/604800 + 1)
        model.curWeekDayInFilter = calendar.component(.weekday, from: dateToCheck) - 2
    }
    
    func didSortAudiences(with curDate: Date) -> [FilterCellData] {
        var cellDataArr: [FilterCellData] = []
        
        model.curWeekInFilter = Int((curDate - semStartDate)/604800 + 1)
        model.curWeekDayInFilter = Calendar.current.component(.weekday, from: curDate) - 2
        
        let cabsForDay = FreeCabinets[(curWeekInFilter - 1) % 2][curWeekDayInFilter]
        var cabFreePairsDict: [String: [Int]] = [:]
        
        for (i, pare) in cabsForDay.enumerated() {
            for cab in pare {
                if (cabFreePairsDict[cab] != nil) {
                    cabFreePairsDict[cab]?.append(i)
                } else {
                    cabFreePairsDict[cab] = []
                }
            }
        }
        
        for cab in cabFreePairsDict.keys {
            let pairsArr = cabFreePairsDict[cab]!
            var startInd = 0
            var stopInd = 0
            for (i, pare) in pairsArr.enumerated() {
                if i == 0 {
                    startInd = pare
                    continue
                }
                if pare != pairsArr[i-1] + 1 {
                    stopInd = pairsArr[i-1]
                    cellDataArr.append(FilterCellData(pairStartInd: startInd, pairEndInd: stopInd, buildingInd: cab.contains("л") ? 1 : 0, cabinet: cab))
                    startInd = pare
                }
            }
            cellDataArr.append(FilterCellData(pairStartInd: startInd, pairEndInd: startInd, buildingInd: cab.contains("л") ? 1 : 0, cabinet: cab))
        }
        
        return cellDataArr
    }
}
