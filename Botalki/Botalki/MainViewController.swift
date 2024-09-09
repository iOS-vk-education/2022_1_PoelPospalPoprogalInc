import UIKit
import PinLayout


class PairsViewController: UIViewController {
    private let presenter = PairsPresenter()
    private let alertManager = AlertManager.shared
    private let secondViewController: FilterViewController = FilterViewController()
    
    let tableView = UITableView()
    var weekPicker  = UIPickerView()
    private var weekButton = UIButton()
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()

    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
    private let lowerView = UIView()
    
    private let weeks = (1...17).map {"\($0) неделя - \(["знаменатель", " числитель"][$0%2])" }
    private var tapGestureReconizer = UITapGestureRecognizer()
    private var dayButton_dayIndexDict: [UIButton:Int] = [:]
    private var dayIndex_dayButtonDict: [Int:UIButton] = [:]
    private var labelsOfWeakButton: [UILabel] = []
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    var buttomMargin = CGFloat()
    var topMargin = CGFloat()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        presenter.didLoadView { result in
            switch result {
            case .success(_):
                self.presenter.didSuccessfullyLoadData()
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
        
        let nextDayGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextDaySwipe))
        nextDayGestureRecognizer.direction = .left
        tableView.addGestureRecognizer(nextDayGestureRecognizer)
        
        let prevDayGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(prevDaySwipe))
        prevDayGestureRecognizer.direction = .right
        tableView.addGestureRecognizer(prevDayGestureRecognizer)

        presenter.mainViewController = self
        presenter.secondViewController = secondViewController
        presenter.setup()
        
        createDayButtons()
        setupScreenSelection()
        
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
        
        buttomMargin = (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
        topMargin = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

        weekButton.pin
            .top(topMargin + margins)
            .height(40)
            .left(margins)
            .width(250)
        
        tableView.pin
            .top(topMargin + 140)
            .bottom(0)
            .left(0)
            .right(0)
        
        lowerView.pin
            .top(view.frame.height - (buttomMargin + 2*margins + 45))
            .bottom(0)
            .left(0)
            .right(0)

        firstScreenButton.pin
            .bottom(buttomMargin + margins)
            .height(45)
            .left(margins)
            .width(ButtonsWidth)
        
        secondScreenButton.pin
            .bottom(buttomMargin + margins)
            .height(45)
            .right(margins)
            .width(ButtonsWidth)
        
        houseImg.pin
            .bottom(buttomMargin + margins + 5)
            .left(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        magnifierImg.pin
            .bottom(buttomMargin + margins + 5)
            .right(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        traitCollectionDidChange(nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            weekPicker.setValue(UIColor.white, forKey: "textColor")
            weekButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            weekPicker.setValue(UIColor.black, forKey: "textColor")
            weekButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    func loadTableData() {
        tableView.refreshControl?.endRefreshing()
        tableView.delegate = self
        tableView.dataSource = self
        reloadTableData()
    }
    
    func setWeekOnWeekButton() {
        presenter.didChangeWeek()
        weekButton.setTitle(weeks[presenter.curWeek - 1], for: .normal)
    }
    
    private func setupWeekButton() {
        weekButton.backgroundColor = UIColor.systemGroupedBackground
        weekButton.layer.cornerRadius = 15
        weekButton.layer.masksToBounds = true
        weekButton.layer.borderWidth = 2
        weekButton.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
        weekButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        weekButton.addTarget(self, action: #selector(didTapOnWeekButton), for: .touchUpInside)
    }
    
    private func setupScreenSelection() {
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
    
    private func createDayButtons() {
        let sizeOfButton = screenWidth < 380 ? 50 : 55
        var x = Int(margins)
        let sizeOfSeparator = (Int(UIScreen.main.bounds.width) - sizeOfButton*6 - x*2)/5
        
        for indexOfDay in 0...5 {
            let nextWeekGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextWeekSwipe))
            nextWeekGestureRecognizer.direction = .left
            
            let prevWeekGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(prevWeekSwipe))
            prevWeekGestureRecognizer.direction = .right
            
            let dayOfWeakButton = DayOfWeakButton(type: .system)
            dayOfWeakButton.backgroundColor = UIColor.systemGroupedBackground
            dayOfWeakButton.layer.cornerRadius = 18
            dayOfWeakButton.layer.masksToBounds = true
            dayOfWeakButton.addTarget(self, action: #selector(didChooseDay(_ :)), for: .touchUpInside)
            dayOfWeakButton.addGestureRecognizer(nextWeekGestureRecognizer)
            dayOfWeakButton.addGestureRecognizer(prevWeekGestureRecognizer)
            
            dayOfWeakButton.pin
                .top(screenHeight > 750 && screenHeight < 1000 ? topMargin + 77 + 2 * margins : topMargin + 97)
                .left(CGFloat(x))
                .width(CGFloat(sizeOfButton))
                .height(CGFloat(sizeOfButton))
            
            
            dayOfWeakButton.layer.borderWidth = 2
            dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            
            if indexOfDay == presenter.curDay {
                dayOfWeakButton.backgroundColor = UIColor(rgb: 0xEA7500)
                dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            }
            
            dayOfWeakButton.addTarget(self, action: #selector(didChooseDay(_ :)), for: .touchUpInside)
            
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
            dayLabel.numberOfLines = 2
            dayLabel.textAlignment = .center
            dayLabel.numberOfLines = 2
            dayLabel.text = presenter.daysOfWeak[indexOfDay]
            
            dayOfWeakButton.addSubview(dayLabel)
            dayOfWeakButton.bringSubviewToFront(dayLabel)
            dayOfWeakButton.layoutSubviews()

            
            dayLabel.pin
                .vCenter()
                .height(CGFloat(sizeOfButton))
                .width(CGFloat(sizeOfButton))
            
            
            view.addSubview(dayOfWeakButton)
            dayButton_dayIndexDict[dayOfWeakButton] = indexOfDay
            dayIndex_dayButtonDict[indexOfDay] = dayOfWeakButton
            labelsOfWeakButton.append(dayLabel)
            
            x += Int(sizeOfButton) + sizeOfSeparator
        }
    }
    
    func didChooseAnotherWeek(with ind: Int, _ reloadFlag: Int? = nil) {
        presenter.didChooseAnotherWeek(with: ind, reloadFlag)
        
        for (i, label) in labelsOfWeakButton.enumerated() {
            label.text = presenter.daysOfWeak[i]
        }
        
        let dayToSelect = dayIndex_dayButtonDict[presenter.curDay]
        
        didChooseDay(dayToSelect!)
    }
    
    func reloadTableData(compl: (() -> Void)? = nil) {
        presenter.didReloadTableData()
        tableView.reloadData()
        compl?()
    }
    
    var pickerFlag = 0
    @objc func didTapOnWeekButton() {
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
        weekPicker.selectRow(presenter.curWeekInMain, inComponent: 0, animated: true)
        
        UIView.animate(withDuration: 0.20) { [self] () -> Void in
            weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 220)
        }
    }
    
    @objc
    func tapToClosePicker() {
        UIView.animate(withDuration: 0.20) { [self] () -> Void in
            weekPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 220)
        }
        pickerFlag = 0
        view.removeGestureRecognizer(tapGestureReconizer)
    }
    
    @objc
    func didChooseDay(_ buttonSubView: UIButton) {
        presenter.didChooseDay(dayChoosed: dayButton_dayIndexDict[buttonSubView])
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if buttonSubView.backgroundColor == .systemGroupedBackground {
            for button in dayButton_dayIndexDict.keys {
                button.backgroundColor = .systemGroupedBackground
                button.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            }
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
            buttonSubView.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
        }
    }
    
    @objc
    private func didPullToRefresh() {
        presenter.loadAllData { result in
            switch result {
            case .success(_):
                self.presenter.didSuccessfullyLoadData()
                self.weekPicker.selectRow(self.presenter.curWeekInMain, inComponent: 0, animated: true)
                break

            case .failure(let error):
                self.alertManager.showAlert(presentTo: self, title: "Error", message: error.localizedDescription)
                self.tableView.refreshControl?.endRefreshing()
                break
            }
        }
    }
    
    @objc
    private func nextDaySwipe(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            if presenter.curDay < 5 {
                didChooseDay(dayIndex_dayButtonDict[presenter.curDay + 1]!)
            } else {
                nextWeekSwipe()
            }
        }
    }
    
    @objc
    private func prevDaySwipe(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            if presenter.curDay > 0 {
                didChooseDay(dayIndex_dayButtonDict[presenter.curDay - 1]!)
            } else {
                if presenter.curWeekInMain != 0 {
                    prevWeekSwipe()
                    didChooseDay(dayIndex_dayButtonDict[5]!)
                } else {
                    prevWeekSwipe()
                }
            }
        }
    }
    
    @objc
    private func nextWeekSwipe(tapRecognizer: UITapGestureRecognizer? = nil) {
        if tapRecognizer == nil || tapRecognizer?.state == .ended {
            if presenter.curWeekInMain < 16 {
                pickerView(weekPicker, didSelectRow: presenter.curWeekInMain + 1, inComponent: 0)
                weekPicker.selectRow(presenter.curWeekInMain, inComponent: 0, animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    @objc
    private func prevWeekSwipe(tapRecognizer: UITapGestureRecognizer? = nil) {
        if tapRecognizer == nil || tapRecognizer?.state == .ended {
            if presenter.curWeekInMain > 0 {
                pickerView(weekPicker, didSelectRow: presenter.curWeekInMain - 1, inComponent: 0)
                weekPicker.selectRow(presenter.curWeekInMain, inComponent: 0, animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    @objc
    func goToFilterScreen() {
        presenter.loadSecondController()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
}

class DayOfWeakButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -4, dy: -4).contains(point)
    }
}


extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 7 {
            return tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        }
        
        presenter.configCellForRow(with: indexPath)
        
        return presenter.myCells[indexPath.row] ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter.didTapOnCell(with: indexPath)
    }
    
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if presenter.cellForReloadIndexes.contains(indexPath.row) {
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
        presenter.didSelectWeekByPicker(at: row)
        weekButton.setTitle(weeks[presenter.curWeekInMain], for: .normal)
        self.reloadTableData()
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
