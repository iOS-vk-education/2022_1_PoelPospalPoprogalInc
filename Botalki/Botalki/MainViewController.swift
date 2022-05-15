import UIKit
import PinLayout


class PairsViewController: UIViewController {
    
    let secondViewController: FilterViewController = FilterViewController()

    private let tableView = UITableView()
    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
//    private let weekSwitcher = UIPickerView()
//    private let viewForSwitcher = UIView()
    private let weeks = (1...17).map {"\($0) неделя - \(["знаменатель", " числитель"][$0%2])" }
//    private var weekLabel = UILabel()
    
    private var toolBar = UIToolbar()
    private var weekPicker  = UIPickerView()
    private var weekButton = UIButton()

//    private let weekPicker = UIPickerView()

    private var cellForReloadInd = -1
    private var cellForReloadIndexes = [Int]()
    private var curNumOrDenom = 0
    private var curDay = 2
    private var tapGestureReconizer = UITapGestureRecognizer()
    private var curWeek = 0
    private var choosenWeek = 0
//    private var semStartDate = Date()
    var daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
    
//    var FreeCabinets = [[[[String]]]]()
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    var daysOfWeakButton: [UIButton:Int] = [:]
    var labelsOfWeakButton: [UILabel] = []
    
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width
    
    private let lowerView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    
        view.addSubview(tableView)

//        view.addSubview(weekPicker)

        view.addSubview(lowerView)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        view.addSubview(houseImg)
        view.addSubview(magnifierImg)
        view.addSubview(weekButton)

        
//        weakButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
//        weekPicker.layer.cornerRadius = 10
//        weekPicker.layer.masksToBounds = true
//        weakButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        weakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
//        weakButton.setTitle("11 неделя - числитель", for: .normal)
//        weakButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        var date = Date()
        let calendar = Calendar.current
//        print(calendar.component(.day, from: date))
        curDay = calendar.component(.weekday, from: date) - 2
//        curNumOrDenom = weekPicker.hashValue
        
        //Обработка воскресенья
        if curDay == -1 {
            curDay = 0
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
            changeNumOrDenom()
            // + в кнопке включить некст неделю
        }
        
//        var startDay = calendar.component(.day, from: date)
        var i = 0
        for delta in -curDay...(5 - curDay) {
            daysOfWeak[i] += String(calendar.component(.day, from: calendar.date(byAdding: .day, value: delta, to: date) ?? date))
            i += 1
        }
        
        createDayButtons()
        screenSelection()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
//        for day in 0...5 {
//            tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell\(day)")
//        }
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        

        
        tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tapToClosePicker))
//        view.addGestureRecognizer(tapGestureReconizer)
        
        setupLowerSubview()
        tableView.refreshControl?.beginRefreshing()
        setupWeekButton()
        

//        let cabinetsRef = storageRef.child("cabinets.txt")
        allocateCellsArr()
        
//        self.cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
//        self.semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
//        
//        if self.cabinetsStringFromFile == "" || self.semesterStartFromFile == "" {
//            loadAndParseCabinetsFileFromFirebase {
//                self.initCellsAndloadTableData()
//            }
//            loadAndSetCurWeekFromFirebase {
//                self.setCurWeekDate()
//                self.reloadTableData()
//            }
//        } else {
//            self.initCellsAndloadTableData()
//            self.setCurWeekDate()
//            self.reloadTableData()
//        }
    }
    
    
//    private func loadAndParseCabinetsFileFromFirebase(completion: @escaping (() -> Void)) {
//        NetworkManager.shared.downloadFileFromFirebaseStorage(toFile: "cabinets.txt") { error in
//            if error == nil {
//                self.cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
//
//                if self.cabinetsStringFromFile == "" {
//                    print("Downloading file error...")
//                    AlertManager.shared.showAlert(presentTo: self, title: "Downloading file cabinets.txt error...", message: "")
//                } else {
//                    self.parseCabinetsFile()
//                }
//                completion()
//
//            } else {
//                AlertManager.shared.showAlert(presentTo: self, title: "Error", message: error?.localizedDescription)
//                self.tableView.refreshControl?.endRefreshing()
//            }
//        }
//    }
    
//    private func loadAndSetCurWeekFromFirebase(completion: @escaping (() -> Void)) {
//        NetworkManager.shared.downloadFileFromFirebaseStorage(toFile: "uuids.txt") { error in
//            if error == nil {
//                self.semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
//
//                if self.semesterStartFromFile == "" {
//                    print("Downloading file error...")
//                    AlertManager.shared.showAlert(presentTo: self, title: "Downloading file uuids.txt error...", message: "")
//                } else {
//                    self.setCurWeekDate()
//                }
////                self.reloadTableData()
//                completion()
//
//            } else {
//                AlertManager.shared.showAlert(presentTo: self, title: "Error", message: error?.localizedDescription)
//                self.tableView.refreshControl?.endRefreshing()
//            }
//        }
//    }
    
    private func initCellsAndloadTableData() {
        var indexPath: IndexPath = IndexPath(row: 0, section: 0)
        for i in 0...6 {
            indexPath.row = i
            indexPath.section = 0
            self.model.myCells[i] = self.tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        }
        
        parseCabinetsFile()
        tableView.refreshControl?.endRefreshing()
        tableView.delegate = self
        tableView.dataSource = self
        reloadTableData()
    }
    
//    private func parseCabinetsFile() {
//        self.cabinetsStringFromFile.split(separator: "\n").forEach { line in
//            var pairsForNumenatorOrDen = [[[String]]]()
//            line.components(separatedBy: "###").forEach { day in
//                var pairsForDay = [[String]]()
//                day.components(separatedBy: "##").forEach { pair in
//                    var cabinetsForPair = [String]()
//                    pair.components(separatedBy: "#").forEach { cabinet in
//                        cabinetsForPair.append(cabinet.trimmingCharacters(in: CharacterSet(charactersIn: "кк ")))
//                    }
//                    pairsForDay.append(cabinetsForPair)
//                }
//                pairsForNumenatorOrDen.append(pairsForDay)
//            }
//            self.FreeCabinets.append(pairsForNumenatorOrDen)
//        }
//    }
    
//    private func setCurWeekDate() {
//        semesterStartFromFile = semesterStartFromFile.components(separatedBy: "\n")[0]
//        let dateFormatter = ISO8601DateFormatter()
//        semStartDate = dateFormatter.date(from: semesterStartFromFile)!
//        secondViewController.semStartDate = semStartDate
//        semStartDate = Calendar.current.date(byAdding: .day, value: -1, to: semStartDate)!
//        let deltaSecs = Date() - semStartDate
//        curWeek = Int(deltaSecs/604800 + 1)
//        choosenWeek = curWeek - 1
////        weekPicker.selectRow(curWeek-1, inComponent: 0, animated: true)
////        weekLabel.text = weeks[curWeek-1]
//        weekButton.setTitle(weeks[curWeek-1], for: .normal)
//        curNumOrDenom = (curWeek-1) % 2
////        print(curWeek)
//    }
    
    @objc
    func tapToClosePicker() {
        UIView.animate(withDuration: 0.20) { [self] () -> Void in
            weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 220)
        }
        view.removeGestureRecognizer(tapGestureReconizer)
//        weekLabel.text = weeks[weekPicker.selectedRow(inComponent: 0)]
    }
    
    private func setupWeekButton() {
        weekButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weekButton.layer.cornerRadius = 12
        weekButton.setTitle(weeks[0], for: .normal)
        weekButton.setTitleColor(UIColor.black, for: .normal)
        weekButton.titleLabel?.font = .systemFont(ofSize: 19)
        
//        weekLabel.textColor = UIColor.black
//        weekLabel.text = weeks[0]
    
//        weekLabel.font = .systemFont(ofSize: 19)
//
//        weekButton.addSubview(weekLabel)
//        weekButton.bringSubviewToFront(weekLabel)
        
        weekButton.addTarget(self, action: #selector(pickerGo), for: .touchUpInside)
    }
    
    @objc func pickerGo() {
        view.addGestureRecognizer(tapGestureReconizer)
        weekPicker = UIPickerView.init()
        weekPicker.delegate = self
        weekPicker.dataSource = self
        
        weekPicker.backgroundColor =  UIColor.systemBackground.withAlphaComponent(0.9)
        weekPicker.autoresizingMask = .flexibleWidth
        weekPicker.contentMode = .center
        weekPicker.alpha = 1
        weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 220)
        self.view.addSubview(weekPicker)
        weekPicker.selectRow(choosenWeek, inComponent: 0, animated: true)
        
        UIView.animate(withDuration: 0.20) { [self] () -> Void in
            weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 220)
        }
    }
    
//    @objc func onDoneButtonTapped() {
//        toolBar.removeFromSuperview()
//        weekPicker.removeFromSuperview()
//            weekButton.setTitle(<#T##title: String?##String?#>, for: <#T##UIControl.State#>)
//        weekLabel.text = String(weeks[weekPicker.selectedRow(inComponent: 0)])
//    }
    
    
    private func screenSelection() {
        firstScreenButton.backgroundColor = UIColor(rgb: 0x785A43)
        firstScreenButton.layer.cornerRadius = 10
        firstScreenButton.layer.masksToBounds = true
        firstScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        firstScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        secondScreenButton.addTarget(self, action: #selector(goToFilterScreen), for: .touchUpInside)
    }
    
    private func setupLowerSubview() {
        lowerView.layer.cornerRadius = 20
        lowerView.backgroundColor = UIColor.systemGroupedBackground
        lowerView.alpha = 0.8
    }
    
    @objc
    func goToFilterScreen() {
        secondViewController.FreeCabinets = FreeCabinets
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
  
    private func changeNumOrDenom() {
        if curNumOrDenom == 0 {
            curNumOrDenom = 1
        } else {
            curNumOrDenom = 0
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            weekPicker.setValue(UIColor.white, forKey: "textColor")
        } else {
            weekPicker.setValue(UIColor.black, forKey: "textColor")
        }
    }
    
    
    private func createDayButtons() {
        let sizeOfButton = 55
        var x = Int(margins)
        let sizeOfSeparator = (Int(UIScreen.main.bounds.width) - sizeOfButton*6 - x*2)/5
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(rgb: 0x785A43)
        
        for indexOfDay in 0...5 {
            let dayOfWeakButton = UIButton(type: .system)
            dayOfWeakButton.backgroundColor = UIColor.systemGroupedBackground
//            dayOfWeakButton.layer.cornerRadius = 16
            dayOfWeakButton.layer.cornerRadius = 18
            dayOfWeakButton.layer.masksToBounds = true
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            
            dayOfWeakButton.pin
                .top(130)
                .left(CGFloat(x))
                .width(CGFloat(sizeOfButton))
                .height(CGFloat(sizeOfButton))
            
            
            dayOfWeakButton.layer.borderWidth = 2
            dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            
            if indexOfDay == curDay {
                dayOfWeakButton.backgroundColor = UIColor(rgb: 0xEA7500)
                dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            }
            
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
            dayLabel.numberOfLines = 2
            dayLabel.textAlignment = .center
            dayLabel.numberOfLines = 2
            dayLabel.text = daysOfWeak[indexOfDay]
            
            dayOfWeakButton.addSubview(dayLabel)
            dayOfWeakButton.bringSubviewToFront(dayLabel)
            dayOfWeakButton.layoutSubviews()

            
            dayLabel.pin
                .vCenter()
                .height(CGFloat(sizeOfButton))
                .width(CGFloat(sizeOfButton))
            
            
            view.addSubview(dayOfWeakButton)
            daysOfWeakButton[dayOfWeakButton] = indexOfDay
            labelsOfWeakButton.append(dayLabel)
            
            x += Int(sizeOfButton) + sizeOfSeparator
        }
    }
    
    @objc
    func changeButtonColor(_ buttonSubView: UIButton) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        curDay = daysOfWeakButton[buttonSubView] ?? 0
        reloadTableData()
        
        if buttonSubView.backgroundColor == .systemGroupedBackground {
            for button in daysOfWeakButton.keys {
                button.backgroundColor = .systemGroupedBackground
                button.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            }
//            for indexOfDay in 0...5 {
//                daysOfWeakButton[indexOfDay]?.backgroundColor = .systemGroupedBackground
//                daysOfWeakButton[indexOfDay]?.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
//            }
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
            buttonSubView.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            
        }
    }
    
    private func updateDayButtons(with ind: Int) {
        let calendar = Calendar.current
        let buttonsStartDate = calendar.date(byAdding: .day, value: ind * 7 + 1, to: semStartDate)!
        
        curDay = 0
        daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
        var i = 0
        for delta in -curDay...(5 - curDay) {
            daysOfWeak[i] += String(calendar.component(.day, from: calendar.date(byAdding: .day, value: delta, to: buttonsStartDate) ?? buttonsStartDate))
            i += 1
        }
        
        for (i, label) in labelsOfWeakButton.enumerated() {
            label.text = daysOfWeak[i]
        }
        
        var monButton = UIButton()
        
        for button in daysOfWeakButton.keys {
            if daysOfWeakButton[button] == 0 {
                monButton = button
            }
        }
        
//        let dayButtons = [UIButton](daysOfWeakButton.keys)
        changeButtonColor(monButton)
        
//        loadData()
    }
    
    private func unconfigCells() {
        model.myCells.forEach {$0?.wasConfiguredFlag = 0}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))
        
//        weekLabel.pin
//            .center().sizeToFit()

        weekButton.pin
            .top(65)
            .height(40)
            .left(margins)
            .width(ButtonsWidth * 3 / 2)
        
        tableView.pin
            .top(200)
            .bottom(0)
            .left(0)
            .right(0)
        
        lowerView.pin
            .top(view.frame.height - 115)
            .bottom(0)
            .left(0)
            .right(0)
        
//        weekPicker.pin
//            .top(55)
//            .height(CGFloat(35) + 40)
//            .right(margins)
//            .width(CGFloat(view.frame.width / (4 / 3)))

        firstScreenButton.pin
            .top(CGFloat(view.frame.height - 95))
            .height(45)
            .left(margins)
            .width(ButtonsWidth)
        
        secondScreenButton.pin
            .top(CGFloat(view.frame.height - 95))
            .height(45)
            .right(margins)
            .width(ButtonsWidth)
        
        houseImg.pin
            .top(CGFloat(view.frame.height - 90))
            .left(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        magnifierImg.pin
            .top(CGFloat(view.frame.height - 90))
            .right(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
    }
    
    
    
    
    //тут completion нужен чтобы знать когда остановить анимацию
    private func reloadTableData(compl: (() -> Void)? = nil) {
//        allocateCellsArr()
        cellForReloadIndexes = []
        cellForReloadInd = -1
        unconfigCells()
        tableView.reloadData()
        compl?()
    }
    
    
    @objc
    private func didPullToRefresh() {
        loadAndParseCabinetsFileFromFirebase {
            self.initCellsAndloadTableData()
        }
        loadAndSetCurWeekFromFirebase {
            self.setCurWeekDate()
            self.reloadTableData()
        }
        updateDayButtons(with: curWeek - 1)
        
//        reloadTableData { [weak self] in
//            self?.tableView.refreshControl?.endRefreshing()
//        }
    }
    
    private func allocateCellsArr() {
        for _ in 0...6 {
            model.myCells.append(nil)
        }
    }
    
}

extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        
        if indexPath.row == 7 {
            return tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        }
        
        let cell = model.myCells[indexPath.row]
        
//        let cell = PairTableViewCell?(style: UITableView.Cel, reuseIdentifier: "PairTableViewCell")
//        if cell?.wasConfiguredFlag == 0 {
            
        if cell?.wasConfiguredFlag == 0 { //когда день поменяется, надо будет сюда войти!
            cell?.loadCabinets(Cabinets: FreeCabinets[curNumOrDenom][curDay][indexPath.row])
            cell?.config(with: indexPath.row)
        }
//            myCells[indexPath.row] = cell ?? .init()
//        }
//        }
        
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("touched \(indexPath.row)")
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
    //        if indexPath.row != cellForReloadInd {
            if !cellForReloadIndexes.contains(indexPath.row) {
    //            if cellForReloadInd != -1 {
    //                myCells[cellForReloadInd]?.config(with: cellForReloadInd)
    //            }
                
    //            cellForReloadInd = indexPath.row
                cellForReloadIndexes.append(indexPath.row)
                tableView.beginUpdates()
                model.myCells[indexPath.row]?.config2(with: indexPath.row)
                tableView.endUpdates()
            }
            else {
                cellForReloadIndexes = cellForReloadIndexes.filter{$0 != indexPath.row}
                cellForReloadInd = -1
                tableView.beginUpdates()
                model.myCells[indexPath.row]?.config(with: indexPath.row)
                tableView.endUpdates()
            }
        }
    
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellForReloadIndexes.contains(indexPath.row) {
//        if indexPath.row == cellForReloadInd {
            return CGFloat(model.myCells[indexPath.row]?.fullCellSz ?? 95)
        }
        else {
            return 95
        }
    }
}


extension PairsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // следующие 3 функции для пикера
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return weeks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weeks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        curNumOrDenom = row % 2
        choosenWeek = weekPicker.selectedRow(inComponent: 0)
        updateDayButtons(with: row)
        weekButton.setTitle(weeks[choosenWeek], for: .normal)
        self.reloadTableData()
    }
}


extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
