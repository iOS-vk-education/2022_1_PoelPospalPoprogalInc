//
//  PairsPresenter.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation

final class PairsPresenter {
    private let model = PairsModel()
    weak var mainViewController: PairsViewController?
    weak var secondViewController: FilterViewController?
    
    var myCells: [PairTableViewCell?] {
        return model.myCells
    }
    
    var curWeek: Int {
        return model.curWeek
    }
    
    var semStartDate: Date {
        return model.semStartDate
    }
    
    var FreeCabinets: [[[[String]]]] {
        return model.FreeCabinets
    }
    
    var curDay: Int {
        return model.curDay
    }
    
    var daysOfWeak: [String] {
        return model.daysOfWeak
    }
    
    var choosenWeek: Int {
        return model.choosenWeek
    }
    
    var cellForReloadIndexes: [Int] {
        return model.cellForReloadIndexes
    }
    
    
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
    

    private func initCells() {
        
        var indexPath: IndexPath = IndexPath(row: 0, section: 0)
        for i in 0...6 {
            indexPath.row = i
            indexPath.section = 0
            model.myCells[i] = mainViewController!.tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        }
    }
    
    func unconfigCells() {
        model.myCells.forEach {$0?.wasConfiguredFlag = 0}
    }
    
    func loadSecondController() {
        secondViewController!.FreeCabinets = FreeCabinets
        secondViewController!.semStartDate = semStartDate
    }
    
    func setup() {
        model.setup()
    }
    
    func didChangeWeek() {
        model.choosenWeek = curWeek - 1
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
        
        if cell?.wasConfiguredFlag == 0 { //когда день поменяется, надо будет сюда войти!
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
        model.choosenWeek = mainViewController!.weekPicker.selectedRow(inComponent: 0)
        mainViewController!.didChooseAnotherWeek(with: row)
    }
}
