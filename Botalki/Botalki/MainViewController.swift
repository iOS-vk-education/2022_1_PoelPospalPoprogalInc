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
    private var daysOfWeakButton: [UIButton:Int] = [:]
    private var labelsOfWeakButton: [UILabel] = []
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width

    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            weekPicker.setValue(UIColor.white, forKey: "textColor")
        } else {
            weekPicker.setValue(UIColor.black, forKey: "textColor")
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
        weekButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weekButton.layer.cornerRadius = 12
        weekButton.setTitle(weeks[0], for: .normal)
        weekButton.setTitleColor(UIColor.black, for: .normal)
        weekButton.titleLabel?.font = .systemFont(ofSize: 19)
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
            dayOfWeakButton.addTarget(self, action: #selector(didChooseDay(_ :)), for: .touchUpInside)
            
            dayOfWeakButton.pin
                .top(130)
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
            daysOfWeakButton[dayOfWeakButton] = indexOfDay
            labelsOfWeakButton.append(dayLabel)
            
            x += Int(sizeOfButton) + sizeOfSeparator
        }
    }
    
    func didChooseAnotherWeek(with ind: Int, _ reloadFlag: Int? = nil) {
        presenter.didChooseAnotherWeek(with: ind, reloadFlag)
        
        for (i, label) in labelsOfWeakButton.enumerated() {
            label.text = presenter.daysOfWeak[i]
        }
        
        var dayToSelect = UIButton()
        
        for button in daysOfWeakButton.keys {
            if daysOfWeakButton[button] == presenter.curDay {
                dayToSelect = button
            }
        }
        
        didChooseDay(dayToSelect)
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
        weekPicker.selectRow(presenter.choosenWeek, inComponent: 0, animated: true)
        
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
        presenter.didChooseDay(dayChoosed: daysOfWeakButton[buttonSubView])
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if buttonSubView.backgroundColor == .systemGroupedBackground {
            for button in daysOfWeakButton.keys {
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
                    break
                    
                case .failure(let error):
                    self.alertManager.showAlert(presentTo: self, title: "Error", message: error.localizedDescription)
                    self.tableView.refreshControl?.endRefreshing()
                    break
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
        weekButton.setTitle(weeks[presenter.choosenWeek], for: .normal)
        self.reloadTableData()
    }
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
