import UIKit
import PinLayout

class PairsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    private let tableView = UITableView()
    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
//    private let weekSwitcher = UIPickerView()
//    private let viewForSwitcher = UIView()
    
    
    private var weekLabel = UILabel()
    
    private var toolBar = UIToolbar()
    private var picker  = UIPickerView()
    
    private var weekTextField = UITextField()
    private var weekButton = UIButton()
    
    
    private let weeks = (1...17).map {"\($0) неделя - \(["знаменатель", "числитель"][$0%2])" }
        
    private var myCells: [PairTableViewCell] = []
    
    private var cellForReloadInd = -1
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    var daysOfWeakButton: [Int:UIButton] = [:]
    
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
        
        
//        weekTextField.inputView = weekPicker
        
        
//        weakButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
//        weakButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        weakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
//        weakButton.setTitle("11 неделя - числитель", for: .normal)
//        weakButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        createDayButtons()
        screenSelection()
        weekSelection()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.tap(_:)))
        weekTextField.addGestureRecognizer(tapGestureReconizer)
        
        
        setupLowerSubview()
        loadData()
    }
    
    
    
    private func weekSelection() {
        weekButton.backgroundColor = UIColor.systemGroupedBackground
        weekButton.layer.cornerRadius = 16
        
        weekLabel.text = weeks[16]
        if self.traitCollection.userInterfaceStyle == .dark {
            weekLabel.textColor = UIColor.white
        } else {
            weekLabel.textColor = UIColor.gray
        }
        weekLabel.font = .systemFont(ofSize: 19, weight: .bold)
        
        weekButton.addSubview(weekLabel)
        weekButton.bringSubviewToFront(weekLabel)
        
        
        weekButton.addTarget(self, action: #selector(pickerGo(_:)), for: .touchUpInside)
    }
    
    @objc func pickerGo(_ sender: UIButton) {
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        if self.traitCollection.userInterfaceStyle == .dark {
            picker.setValue(UIColor.white, forKey: "textColor")
        } else {
            picker.setValue(UIColor.black, forKey: "textColor")
        }
        picker.backgroundColor =  UIColor.systemBackground.withAlphaComponent(0.9)
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 220)
        self.view.addSubview(picker)
                
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 50))
//        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    
    
    private func screenSelection() {
        firstScreenButton.backgroundColor = UIColor(rgb: 0x785A43)
        firstScreenButton.layer.cornerRadius = 10
        firstScreenButton.layer.masksToBounds = true
        firstScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        firstScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        firstScreenButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        secondScreenButton.addTarget(self, action: #selector(goToFilterScreen), for: .touchUpInside)
    }
    
    private func setupLowerSubview() {
//        lowerView.layer.shadowColor = UIColor.black.cgColor
//        lowerView.layer.shadowRadius = 0.5
//        lowerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
//        lowerView.layer.shadowOpacity = 0.8
        lowerView.layer.cornerRadius = 20
        lowerView.backgroundColor = UIColor.systemGroupedBackground
        lowerView.alpha = 0.8
    }
    
    @objc
    func goToFilterScreen() {
        let secondViewController:FilterViewController = FilterViewController()
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    private func createDayButtons() {
        let dayOfWeak = ["Пн\n18", "Вт\n19", "Ср\n20", "Чт\n21", "Пт\n22", "Сб\n23"]
        let sizeOfButton = 55
        var x = Int(margins)
        let sizeOfSeparator = (Int(UIScreen.main.bounds.width) - sizeOfButton*6 - x*2)/5
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(rgb: 0x785A43)
        
        for indexOfDay in 0...5 {
            let dayOfWeakButton = UIButton(type: .system)
            dayOfWeakButton.backgroundColor = UIColor.systemGroupedBackground
            dayOfWeakButton.layer.cornerRadius = 16
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
            
            if indexOfDay == 2 {
                dayOfWeakButton.backgroundColor = UIColor(rgb: 0xEA7500)
                dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            }
            
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
            dayLabel.numberOfLines = 2
            dayLabel.textAlignment = .center
            dayLabel.numberOfLines = 2
            dayLabel.text = dayOfWeak[indexOfDay]
            
            dayOfWeakButton.addSubview(dayLabel)
            dayOfWeakButton.bringSubviewToFront(dayLabel)
            dayOfWeakButton.layoutSubviews()

            
            dayLabel.pin
                .vCenter()
                .height(CGFloat(sizeOfButton))
                .width(CGFloat(sizeOfButton))
            
            
            view.addSubview(dayOfWeakButton)
            daysOfWeakButton[indexOfDay] = dayOfWeakButton
            
            x += Int(sizeOfButton) + sizeOfSeparator
        }
    }
    
    @objc
    func changeButtonColor(_ buttonSubView: UIButton) {
        myCells = []
        cellForReloadInd = -1
        tableView.reloadData()
        
        if buttonSubView.backgroundColor == .systemGroupedBackground {
            for indexOfDay in 0...5 {
                daysOfWeakButton[indexOfDay]?.backgroundColor = .systemGroupedBackground
                daysOfWeakButton[indexOfDay]?.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            }
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
            buttonSubView.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))
        
        weekLabel.pin
            .top(10)
            .bottom(10)
            .left(20)
            .right(10)

        weekButton.pin
            .top(65)
            .height(40)
            .right(margins + 20)
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
    private func loadData(compl: (() -> Void)? = nil) {
        myCells = []
        cellForReloadInd = -1
        tableView.reloadData()
        compl?()
    }
    
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
    
    @objc
    private func didPullToRefresh() {
        loadData { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    
    @objc
    private func didTapAddButton() {
//        print("tapped week B")
        
    }

    
    @objc private func open() {
        let viewController = CityViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        weekLabel.text = String(weeks[picker.selectedRow(inComponent: 0)])
    }
    
}

extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        cell?.config(with: indexPath.row)
        myCells.append(cell ?? .init())
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("touched \(indexPath.row)")
        if indexPath.row != cellForReloadInd {
            if cellForReloadInd != -1 {
                myCells[cellForReloadInd].config(with: cellForReloadInd)
            }
            
            cellForReloadInd = indexPath.row
            tableView.beginUpdates()
            myCells[indexPath.row].config2(with: indexPath.row)
            tableView.endUpdates()
        }
        else {
            cellForReloadInd = -1
            tableView.beginUpdates()
            myCells[indexPath.row].config(with: indexPath.row)
            tableView.endUpdates()
        }
    }
    
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cellForReloadInd {
            return CGFloat(myCells[indexPath.row].fullCellSz)
        }
        else {
            return 95
        }
    }
}
