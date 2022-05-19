import UIKit
import PinLayout


class PairsViewController: UIViewController {
    private let presenter = PairsPresenter()
    private let alertManager = AlertManager.shared
    private let secondViewController: FilterViewController = FilterViewController()
    
    let tableView = UITableView()
    private var weekPicker  = UIPickerView()
    private var weekButton = UIButton()
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()

    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
    private let lowerView = UIView()
    
    private let weeks = (1...17).map {"\($0) неделя - \(["знаменатель", " числитель"][$0%2])" }
    private var cellForReloadInd = -1
    private var cellForReloadIndexes = [Int]()
    private var curNumOrDenom = 0
    private var curDay = 2
    private var tapGestureReconizer = UITapGestureRecognizer()
    private var choosenWeek = 0
    private var daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
    private var daysOfWeakButton: [UIButton:Int] = [:]
    private var labelsOfWeakButton: [UILabel] = []
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width
    private var selectedDate = Date()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        presenter.didLoadView { result in
            switch result {
            case .success(_):
                self.loadTableData()
                self.setCurWeekDate()
                break
                
            case .failure(let error):
                self.alertManager.showAlert(presentTo: self, title: "Error", message: error.localizedDescription)
                self.tableView.refreshControl?.endRefreshing()
                break
            }
        }
    }
    
    private func setup() {
        self.view.backgroundColor = UIColor.systemBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
    
        view.addSubview(tableView)
        view.addSubview(lowerView)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        view.addSubview(houseImg)
        view.addSubview(magnifierImg)
        view.addSubview(weekButton)

        presenter.mainViewController = self
        presenter.secondViewController = secondViewController
        
        setCurDay()
        formDaysOfWeakStrings()
        createDayButtons()
        screenSelection()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tapToClosePicker))
        
        setupLowerSubview()
        tableView.refreshControl?.beginRefreshing()
        setupWeekButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))

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
    
    private func setCurDay() {
        selectedDate = Date()
        let calendar = Calendar.current
        curDay = calendar.component(.weekday, from: selectedDate) - 2
        
        //Обработка воскресенья
        if curDay == -1 {
            curDay = 0
            selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
            changeNumOrDenom()
        }
    }
    
    private func formDaysOfWeakStrings() {
        var i = 0
        for delta in -curDay...(5 - curDay) {
            daysOfWeak[i] += String(Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: delta, to: selectedDate) ?? selectedDate))
            i += 1
        }
    }
    
    private func loadTableData() {
        tableView.refreshControl?.endRefreshing()
        tableView.delegate = self
        tableView.dataSource = self
        reloadTableData()
    }
    
    private func setCurWeekDate() {
        let curWeek = presenter.curWeek
        secondViewController.semStartDate = presenter.semStartDate
        choosenWeek = curWeek - 1
        weekButton.setTitle(weeks[curWeek - 1], for: .normal)
        curNumOrDenom = (curWeek-1) % 2
    }
    
    @objc
    func tapToClosePicker() {
        UIView.animate(withDuration: 0.20) { [self] () -> Void in
            weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 220)
        }
        pickerFlag = 0
        view.removeGestureRecognizer(tapGestureReconizer)
    }
    
    private func setupWeekButton() {
        weekButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weekButton.layer.cornerRadius = 12
        weekButton.setTitle(weeks[0], for: .normal)
        weekButton.setTitleColor(UIColor.black, for: .normal)
        weekButton.titleLabel?.font = .systemFont(ofSize: 19)
        weekButton.addTarget(self, action: #selector(didTapWeekButton), for: .touchUpInside)
    }
    
    var pickerFlag = 0
    @objc func didTapWeekButton() {
        if pickerFlag == 1 {
            return
        }
        
        view.addGestureRecognizer(tapGestureReconizer)
        
        pickerFlag = 1
        
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
        presenter.didLoadSecondController()
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
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
            buttonSubView.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            
        }
    }
    
    private func updateDayButtons(with ind: Int, _ reloadFlag: Int? = nil) {
        let calendar = Calendar.current
        let buttonsStartDate = calendar.date(byAdding: .day, value: ind * 7 + 1, to: presenter.semStartDate)!
        
        daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
        var i = 0
        for delta in 0...5 {
            daysOfWeak[i] += String(calendar.component(.day, from: calendar.date(byAdding: .day, value: delta, to: buttonsStartDate) ?? buttonsStartDate))
            i += 1
        }
        
        for (i, label) in labelsOfWeakButton.enumerated() {
            label.text = daysOfWeak[i]
        }
        
        if reloadFlag == nil {
            curDay = 0
        }
        
        var monButton = UIButton()
        
        for button in daysOfWeakButton.keys {
            if daysOfWeakButton[button] == curDay {
                monButton = button
            }
        }
        changeButtonColor(monButton)
    }
    
    private func reloadTableData(compl: (() -> Void)? = nil) {
        cellForReloadIndexes = []
        cellForReloadInd = -1
        presenter.unconfigCells()
        tableView.reloadData()
        compl?()
    }
    
    
    @objc
    private func didPullToRefresh() {
        presenter.loadAllData { result in
            switch result {
                case .success(_):
                    self.setCurDay()
                    self.updateDayButtons(with: self.presenter.curWeek - 1, 1)
                    self.loadTableData()
                    self.setCurWeekDate()
                    break
                    
                case .failure(let error):
                    self.alertManager.showAlert(presentTo: self, title: "Error", message: error.localizedDescription)
                    self.tableView.refreshControl?.endRefreshing()
                    break
            }
        }
    }
    
}

extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 7 {
            return tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        }
        
        let cell = presenter.myCells[indexPath.row]
        
        if cell?.wasConfiguredFlag == 0 { //когда день поменяется, надо будет сюда войти!
            cell?.loadCabinets(Cabinets: presenter.FreeCabinets[curNumOrDenom][curDay][indexPath.row])
            cell?.config(with: indexPath.row)
        }
        
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("touched \(indexPath.row)")
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if !cellForReloadIndexes.contains(indexPath.row) {
                cellForReloadIndexes.append(indexPath.row)
                tableView.beginUpdates()
                presenter.myCells[indexPath.row]?.config2(with: indexPath.row)
                tableView.endUpdates()
            } else {
                cellForReloadIndexes = cellForReloadIndexes.filter{$0 != indexPath.row}
                cellForReloadInd = -1
                tableView.beginUpdates()
                presenter.myCells[indexPath.row]?.config(with: indexPath.row)
                tableView.endUpdates()
            }
        }
    
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellForReloadIndexes.contains(indexPath.row) {
            return CGFloat(presenter.myCells[indexPath.row]?.fullCellSz ?? 95)
        } else {
            return 95
        }
    }
}


extension PairsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
