import UIKit
import PinLayout
import SwiftUI

struct FilterCellData {
    let pairStartInd: Int
    let pairEndInd: Int
    let buildingInd: Int
    let cabinet: String
}

class FilterViewController: UIViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var FreeCabinets = [[[[String]]]]()
    var semStartDate = Date()
    
    private let borderColor = UIColor(rgb: 0xC2A894)
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    private let imageCalendar = UIImageView(image: UIImage(named: "calendarWhite.png"))
    
    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
    
    private let dateField = UITextField()
    private let selectRoomButton = UIButton()
    
    private let pairSelectView = UIView()
    private let pairSwitcher = UISwitch()
    
    private let datePicker = UIDatePicker()
    
    let gradePickerValues = ["1", "2", "3", "4", "5", "6", "7"]
    private let firstPairPicker = UIPickerView()
    private let secondPairPicker = UIPickerView()
    private var pickersDict: [UIPickerView: Int] = [:]
    
    private let buildingSelectView = UIView()
    private let buildingSwitcher = UISwitch()
    private let buildingSegController = UISegmentedControl(items: ["ГЗ", "УЛК"])
    
    private let audienceSelectView = UIView()
    private let audienceSwitcher = UISwitch()
    private let audienceTextField = UITextField()
    
    private var curWeek = 0
    private var weekDay = 0
    
    
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width
    
    private let lowerView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true

        pickersDict = [firstPairPicker: 0, secondPairPicker: 1]
        firstPairPicker.dataSource = self
        firstPairPicker.delegate = self
        secondPairPicker.dataSource = self
        secondPairPicker.delegate = self
        buildingSegController.addTarget(self, action: #selector(didChangeBuilding(_ :)), for: .valueChanged)
        audienceSwitcher.addTarget(self, action: #selector(didSwitchAudienceTrigger), for: .valueChanged)
        
        view.addSubview(lowerView)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        
        view.addSubview(houseImg)
        view.addSubview(magnifierImg)
        
        view.addSubview(dateField)
        view.addSubview(selectRoomButton)
    
        
        view.addSubview(pairSelectView)
        view.addSubview(buildingSelectView)
        view.addSubview(audienceSelectView)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
        
        
        // календарь
        dateField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didChooseDate), for: .editingDidEnd)
        
//        let tapScreen = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
//        func dismissKeyboard(sender: UITapGestureRecognizer) {
//            view.endEditing(true)
//        }
        
        createSelectRoomButton()
        createPairArea()
        createBuildingArea()
        createAudienceArea()
        
        screenSelection()
        
        setupLowerSubview()
        showDatePicker()
        view.addSubview(datePicker)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            imageCalendar.setImageColor(color: UIColor.white)
        } else {
            imageCalendar.setImageColor(color: UIColor.black)
        }
    }
    
    private func checkDate() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let calendar = Calendar.current
        let semEnd = calendar.date(byAdding: .day, value: 7*17, to: self.semStartDate)!
        
        let deltaSecs = self.datePicker.date - self.semStartDate
        curWeek = Int(deltaSecs/604800 + 1)
        weekDay = calendar.component(.weekday, from: self.datePicker.date) - 2
        
        if self.weekDay == -1 {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            let alertController = UIAlertController(title: "Выбран неверный день", message: "В воскресенье ВУЗ закрыт.\nВыбери другой день", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
            datePicker.date = self.setCorrectCurrentDate()
            present(alertController, animated: true, completion: nil)
            return false
        }
        
        if self.curWeek < 1 || self.curWeek > 17 {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            let alertController = UIAlertController(title: "Выбрана неверная дата", message: "Семестр начался \(formatter.string(from: self.semStartDate)) и закончится \(formatter.string(from: semEnd)).\nВыбери дату из этих рамок", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
            datePicker.date = self.setCorrectCurrentDate()
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @objc
    private func didChooseDate() {
        DispatchQueue.global().async {
            usleep(1)
            DispatchQueue.main.async {
                self.checkDate()
            }
        }
    }
    
    private func setCorrectCurrentDate() -> Date {
        if Calendar.current.component(.weekday, from: Date()) - 2 == -1 {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }
        
        return Date()
    }
    
    @objc
    private func didChangeBuilding(_ sender: UISegmentedControl) {
        buildingSwitcher.setOn(true, animated: true)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @objc
    private func didSwitchAudienceTrigger() {
        if !audienceSwitcher.isOn {
            audienceTextField.layer.borderWidth = 0
        }
    }
    
    func showDatePicker() {
        datePicker.date = setCorrectCurrentDate()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
//        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        
        datePicker.backgroundColor = UIColor.secondarySystemBackground
        datePicker.layer.borderWidth = 2
        datePicker.layer.borderColor = borderColor.cgColor
        
        datePicker.layer.cornerRadius = 16
        datePicker.layer.masksToBounds = true
    }
    
    
    private func setupLowerSubview() {
        lowerView.layer.cornerRadius = 20
        lowerView.backgroundColor = UIColor.systemGroupedBackground
        lowerView.alpha = 0.8
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))
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
        
        lowerView.pin
            .top(view.frame.height - 115)
            .bottom(0)
            .left(0)
            .right(0)
        
//        print(self.view.backgroundColor)
//        let bgColor = self.view.backgroundColor
//        let aColor = UIColor(named: "systemBackgroundColor")
//        print(aColor)
//
//        let color = UIColor(dynamicProvider:
//            case .dark:
//                return UIColor.yellow
//            case .light:
//                return UIColor.blue
//            case .unspecified:
//                return UIColor.clear
//        var myControlBackground: UIColor {
//            return UIColor { (traits) -> UIColor in
//                return traits.userInterfaceStyle == .dark ?
//                    UIColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 1) :
//                    UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)
//            }
//        }
        
        
//        if bgColor == "<UIDynamicSystemColor: 0x600001f05ec0; name = systemBackgroundColor>" {
        imageCalendar.pin
            .top(82)
            .left(54)
            .height(45)
            .width(45)
        view.addSubview(imageCalendar)
        view.bringSubviewToFront(imageCalendar)
        
        datePicker.pin
            .top(82)
            .left(self.view.frame.width / 2 + 30)
            .height(42)
            .width(self.view.frame.width / 3 - 5)
        
//        dateField.pin
//            .top(82)
//            .left(self.view.frame.width / 2 + 10)
//            .height(42)
//            .width(self.view.frame.width / 3 + 20)
        
        selectRoomButton.pin
            .top((self.view.frame.height / 3) * 2)
            .left(45)
            .right(40)
            .height(50)
        
        pairSelectView.pin
            .top(160)
            .left(45)
            .right(40)
            .height(120)
        
        buildingSelectView.pin
            .top(self.view.frame.height / 3)
            .left(45)
            .right(40)
            .height(70)
        
        audienceSelectView.pin
            .top(self.view.frame.height / 2 - 50)
            .left(45)
            .right(40)
            .height(120)
        
        
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
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    private func createSelectRoomButton() {
        selectRoomButton.backgroundColor = UIColor(rgb: 0xC2A894)
        
        selectRoomButton.layer.cornerRadius = 12
        selectRoomButton.layer.masksToBounds = true
        selectRoomButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        selectRoomButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)

        
        selectRoomButton.setTitle("Подобрать", for: .normal)
        selectRoomButton.addTarget(self, action: #selector(sortAudiences), for: .touchUpInside)
    }
    
    private func createPairArea() {
        pairSelectView.backgroundColor = UIColor.systemGroupedBackground
        pairSelectView.layer.borderWidth = 2
        pairSelectView.layer.borderColor = borderColor.cgColor
        
        pairSelectView.layer.cornerRadius = 12
        pairSelectView.layer.masksToBounds = true
        pairSelectView.layoutSubviews()
        
        
        let pairLabel = UILabel()
        
        pairLabel.font = .systemFont(ofSize: 24, weight: .bold)
        pairLabel.numberOfLines = 1
        pairLabel.textAlignment = .right
        pairLabel.text = "Пара"
        
        pairSelectView.addSubview(pairLabel)
        pairSelectView.bringSubviewToFront(pairLabel)
        
        pairLabel.pin
            .top(20)
            .left(15)
            .height(30)
            .width(70)
        
        pairSelectView.layoutSubviews()
        
        pairSelectView.addSubview(pairSwitcher)
//        pairSelectView.addSubview(pairSwitcher)
        pairSwitcher.pin
            .top(20)
            .left(pairSelectView.frame.width + 270)
            .height(100)
            .width(100)
        
        firstPairPicker.pin
            .top(54)
            .left(audienceSelectView.frame.width + 25)
            .height(70)
            .width(150)
        
        pairSelectView.addSubview(firstPairPicker)
//        pairSelectView.addSubview(firstPairPicker)
        
        secondPairPicker.pin
            .top(54)
            .left(pairSelectView.frame.width + 180)
            .height(70)
            .width(150)
        
//        secondPairTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)

        pairSelectView.addSubview(secondPairPicker)
//        pairSelectView.addSubview(secondPairPicker)
    }
    
    private func createBuildingArea() {
        buildingSelectView.backgroundColor = UIColor.systemGroupedBackground
        buildingSelectView.layer.borderWidth = 2
        buildingSelectView.layer.borderColor = borderColor.cgColor
        
        buildingSelectView.layer.cornerRadius = 12
        buildingSelectView.layer.masksToBounds = true
        
        let buildingLabel = UILabel()
        
        buildingLabel.font = .systemFont(ofSize: 24, weight: .bold)
//        buildingLabel.textColor = .black
        buildingLabel.numberOfLines = 1
        buildingLabel.textAlignment = .right
        buildingLabel.text = "Корпус"
        
        buildingSelectView.addSubview(buildingLabel)
        

        buildingSelectView.layoutSubviews()

        buildingLabel.pin
            .top(20)
            .left(15)
            .height(30)
            .width(95)
        
        buildingSegController.selectedSegmentIndex = 0
        buildingSegController.layer.cornerRadius = 5.0

        buildingSegController.pin
            .top(18)
            .left(buildingSelectView.frame.width + 145)
            .height(34)
            .width(90)
        // Add target action method
//        buildingSegController.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)

        // Add this custom Segmented Control to our view
        buildingSelectView.addSubview(buildingSegController)
        buildingSelectView.addSubview(buildingSwitcher)
        buildingSwitcher.pin
            .top(18)
            .left(buildingSelectView.frame.width + 270)
            .height(34)
            .width(90)
        buildingSelectView.bringSubviewToFront(buildingSegController)
    
    }
    
    private func createAudienceArea() {
        audienceSelectView.backgroundColor = UIColor.systemGroupedBackground
        audienceSelectView.layer.borderWidth = 2
        audienceSelectView.layer.borderColor = borderColor.cgColor
        
        audienceSelectView.layer.cornerRadius = 10
        audienceSelectView.layer.masksToBounds = true
        
        let audienceLabel = UILabel()
        
        audienceLabel.font = .systemFont(ofSize: 24, weight: .bold)
//        audienceLabel.textColor = .black
        audienceLabel.numberOfLines = 1
        audienceLabel.textAlignment = .right
        audienceLabel.text = "Аудитория"
        
        audienceSelectView.addSubview(audienceLabel)
        audienceSelectView.bringSubviewToFront(audienceLabel)
        audienceSelectView.layoutSubviews()

        audienceLabel.pin
            .top(20)
            .left(15)
            .height(30)
            .width(140)
        
        audienceSelectView.addSubview(audienceSwitcher)
        audienceSelectView.addSubview(audienceSwitcher)
        audienceSwitcher.pin
            .top(20)
            .left(pairSelectView.frame.width + 270)
            .height(100)
            .width(100)
        
        audienceTextField.attributedPlaceholder = NSAttributedString(
            string: "501",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x808080)]
        )
        audienceTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        audienceTextField.pin
            .top(68)
            .left(audienceSelectView.frame.width + 25)
            .height(30)
            .width(295)
        
        audienceTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
//        audienceTextField.backgroundColor = UIColor.systemGroupedBackground
//        audienceTextField.alpha = 0.5
        audienceTextField.textColor = .black
        audienceTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        audienceTextField.layer.borderColor = borderColor.cgColor
        audienceTextField.autocorrectionType = UITextAutocorrectionType.no
        audienceTextField.keyboardType = UIKeyboardType.numberPad
        audienceTextField.returnKeyType = UIReturnKeyType.done
        audienceTextField.clearButtonMode = UITextField.ViewMode.never
        audienceTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        audienceTextField.layer.cornerRadius = 5
        audienceTextField.layer.borderColor = UIColor.red.cgColor
        audienceTextField.addTarget(self, action: #selector(didStartEnterAudience), for: .editingDidBegin)
        
        audienceTextField.textAlignment = .center
        audienceSelectView.addSubview(audienceTextField)
        audienceSelectView.addSubview(audienceTextField)
    }
    
    @objc
    func didStartEnterAudience() {
        audienceTextField.layer.borderWidth = 0
    }
    
    private func screenSelection() {
        firstScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        firstScreenButton.layer.cornerRadius = 10
        firstScreenButton.layer.masksToBounds = true
        firstScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        firstScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        firstScreenButton.addTarget(self, action: #selector(goToFirstScreen), for: .touchUpInside)
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0x785A43)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    }
    
    @objc
    func goToFirstScreen() {
//        let firstViewController: PairsViewController = PairsViewController()
//        self.navigationController?.pushViewController(firstViewController, animated: false)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        self.navigationController?.popViewController(animated: false)
    }
  
    private func layoutScreenButtonsSubviews(buttonSubView: UIButton, iconNameOfButton: String) {
        let imageViewButton = UIImageView(image: UIImage(named: iconNameOfButton))
        
        buttonSubView.addSubview(imageViewButton)
        buttonSubView.bringSubviewToFront(imageViewButton)
        
        buttonSubView.layoutSubviews()
        
        imageViewButton.pin
            .vCenter()
            .left(buttonSubView.frame.width / 2 - 17)
            .height(35)
            .width(35)
    }
    
    @objc
    private func sortAudiences() {
        var cellDataArr: [FilterCellData] = []
        if !checkDate() {
            return
        }
        
        curWeek = Int((datePicker.date - semStartDate)/604800 + 1)
        weekDay = Calendar.current.component(.weekday, from: datePicker.date) - 2
        
        let cabsForDay = FreeCabinets[(curWeek - 1) % 2][weekDay]
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
        
        var errorFlag = 0
        if errorFlag == 1 && audienceTextField.text != "" || !audienceSwitcher.isOn {
            audienceTextField.layer.borderWidth = 0
        }
        if audienceSwitcher.isOn && audienceTextField.text == "" {
            audienceTextField.layer.borderWidth = 2
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            errorFlag = 1
            return
        }
        
        for cab in cabFreePairsDict.keys {
            
            let pairsArr = cabFreePairsDict[cab]!
            var startInd = 0
            var stopInd = 0
//            var prevP = -1
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
        
        if pairSwitcher.isOn {
            let beg = firstPairPicker.selectedRow(inComponent: 0)
            let end = secondPairPicker.selectedRow(inComponent: 0)
            
            cellDataArr = cellDataArr.filter{$0.pairStartInd <= beg && $0.pairEndInd >= end}
        }
        
        if buildingSwitcher.isOn {
            cellDataArr = cellDataArr.filter{$0.buildingInd == buildingSegController.selectedSegmentIndex}
        }
        
        if audienceSwitcher.isOn {
            cellDataArr = cellDataArr.filter{$0.cabinet == audienceTextField.text || $0.cabinet == audienceTextField.text! + "л"}
        }
        
        if cellDataArr.count != 0 {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            let viewController = SortedViewController(cellData: cellDataArr, date: datePicker.date)
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            let alertController = UIAlertController(title: "Не найдено ни одной подходящей аудитории...", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pairSwitcher.setOn(true, animated: true)
        if pickersDict[pickerView] == 0 {
            if firstPairPicker.selectedRow(inComponent: 0) > secondPairPicker.selectedRow(inComponent: 0) {
                secondPairPicker.selectRow(firstPairPicker.selectedRow(inComponent: 0), inComponent: 0, animated: true)
            }
        } else {
            if firstPairPicker.selectedRow(inComponent: 0) > secondPairPicker.selectedRow(inComponent: 0) {
                firstPairPicker.selectRow(secondPairPicker.selectedRow(inComponent: 0), inComponent: 0, animated: true)
            }
        }
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
