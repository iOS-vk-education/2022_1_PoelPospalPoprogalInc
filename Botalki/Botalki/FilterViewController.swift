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
    var presenter: PairsPresenter?
    private let alertManager = AlertManager.shared
    
    private let borderColor = UIColor(rgb: 0xC2A894)
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    private let selectRoomButton = UIButton()
    
    private let imageCalendar = UIImageView(image: UIImage(named: "calendarWhite.png"))
    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
    
    private let pairSelectView = UIView()
    private let buildingSelectView = UIView()
    private let audienceSelectView = UIView()
    
    private let pairSwitcher = UISwitch()
    private let audienceSwitcher = UISwitch()
    private let buildingSwitcher = UISwitch()
    
    private let datePicker = UIDatePicker()

    private let firstPairPicker = UIPickerView()
    private let secondPairPicker = UIPickerView()
    
    private let buildingSegController = UISegmentedControl(items: ["ГЗ", "УЛК"])
    
    private let dash = UILabel()
    
    private let audienceTextField = UITextField()

    private var firstPairTimeLabel = UILabel()
    private var secondPairTimeLabel = UILabel()
    private let indicator = LoadindIndicatorView()

    
    let gradePickerValues = ["1", "2", "3", "4", "5", "6", "7"]
    private let studyTimesStart = ["8 : 30", "10 : 15", "12 : 00", "13 : 50", "15 : 40", "17 : 25", "19 : 10"]
    private let studyTimesEnd = ["10 : 05", "11 : 50", "13 : 35", "15 : 25", "17 : 15", "19 : 00", "20 : 45"]
    private let margins = CGFloat(22)
    private var pickerWidth = CGFloat()
    private var pickerHeight = CGFloat(45)
    private var screenWidth = UIScreen.main.bounds.width
    private var screenHeight = UIScreen.main.bounds.height
    private var noNotchIPhoneMargin = CGFloat()
    private let lowerView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        pickerWidth = CGFloat(Float(Int((screenWidth < 500 ? screenWidth : 400) - 80) / 2) - 1.5*Float(margins))
        noNotchIPhoneMargin = screenHeight < 750 ? 30 : 0
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true

        firstPairPicker.dataSource = self
        firstPairPicker.delegate = self
        
        let tapOnFirstPairPickerGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnFirstPairPicker))
        tapOnFirstPairPickerGesture.delegate = self
        tapOnFirstPairPickerGesture.numberOfTapsRequired = 2
        firstPairPicker.addGestureRecognizer(tapOnFirstPairPickerGesture)
        
        let tapOnSecondPairPickerGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnSecondPairPicker))
        tapOnSecondPairPickerGesture.delegate = self
        tapOnSecondPairPickerGesture.numberOfTapsRequired = 2
        secondPairPicker.addGestureRecognizer(tapOnSecondPairPickerGesture)
        
        secondPairPicker.dataSource = self
        secondPairPicker.delegate = self

        buildingSegController.addTarget(self, action: #selector(didChangeBuilding(_ :)), for: .valueChanged)
        audienceSwitcher.addTarget(self, action: #selector(didSwitchAudienceTrigger), for: .valueChanged)
        
        
        view.addSubview(lowerView)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        
        view.addSubview(houseImg)
        view.addSubview(magnifierImg)

        view.addSubview(selectRoomButton)
    
        
        view.addSubview(pairSelectView)
        view.addSubview(buildingSelectView)
        view.addSubview(audienceSelectView)
        view.addSubview(dash)
        
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tapGestureReconizer)
        
        // календарь
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didChooseDate), for: .editingDidEnd)
        
        createSelectRoomButton()
        createPairArea()
        createBuildingArea()
        createAudienceArea()
        
        screenSelection()
        
        setupLowerSubview()
        setupDatePicker()
        view.addSubview(datePicker)
    }
    
    var relayoutFlag = 1
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(imageCalendar)
        view.bringSubviewToFront(imageCalendar)
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))
        
        let buttomMargin = UIApplication.shared.windows.first?.safeAreaInsets.bottom
        
        firstScreenButton.pin
            .bottom(buttomMargin! + margins)
            .height(45)
            .left(margins)
            .width(ButtonsWidth)
        
        secondScreenButton.pin
            .bottom(buttomMargin! + margins)
            .height(45)
            .right(margins)
            .width(ButtonsWidth)
        
        lowerView.pin
            .top(view.frame.height - (buttomMargin! + 2*margins + 45))
            .bottom(0)
            .left(0)
            .right(0)
        
        imageCalendar.pin
            .vCenter(-screenHeight * 3 / 7 + 20 - (noNotchIPhoneMargin - 30))
            .hCenter(screenWidth < 500 ? -(screenWidth - 160)/2 : -170)
            .height(45)
            .width(45)
        
        datePicker.pin
            .vCenter(-screenHeight * 3 / 7 + 20 - (noNotchIPhoneMargin - 30))
            .hCenter(screenWidth < 500 ? (screenWidth - 160)/2-45 : 120)
            .height(42)
            .width(130)
        
        selectRoomButton.pin
            .vCenter(1.5 * screenHeight / 7 + noNotchIPhoneMargin * 1.5)
            .hCenter()
            .width(screenWidth < 500 ? screenWidth - 80 : 400)
            .height(50)
        
        pairSelectView.pin
            .vCenter(-screenHeight * 2 / 7 + noNotchIPhoneMargin - (noNotchIPhoneMargin - 30))
            .hCenter()
            .width(screenWidth < 500 ? screenWidth - 80 : 400)
            .height(120)
        
        buildingSelectView.pin
            .vCenter(-screenHeight / 7 + noNotchIPhoneMargin * 1.5 - (noNotchIPhoneMargin - 30))
            .hCenter()
            .width(screenWidth < 500 ? screenWidth - 80 : 400)
            .height(70)
        
        audienceSelectView.pin
            .vCenter(noNotchIPhoneMargin * 2 - (noNotchIPhoneMargin - 30))
            .hCenter()
            .width(screenWidth < 500 ? screenWidth - 80 : 400)
            .height(120)
        
        houseImg.pin
            .bottom(buttomMargin! + margins + 5)
            .left(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        magnifierImg.pin
            .bottom(buttomMargin! + margins + 5)
            .right(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        firstPairPicker.pin
            .top(73 - (pickerHeight/2 - 22))
            .height(pickerHeight)
            .left(margins)
            .width(pickerWidth)
        
        secondPairPicker.pin
            .top(73 - (pickerHeight/2 - 22))
            .height(pickerHeight)
            .right(margins)
            .width(pickerWidth)
        
        if relayoutFlag != 0 {
            firstPairTimeLabel.pin
                .height(14)
                .width(pickerWidth-20)
                .above(of: firstPairPicker, aligned: .center)
            
            secondPairTimeLabel.pin
                .height(14)
                .width(pickerWidth-20)
                .above(of: secondPairPicker, aligned: .center)
        }

        indicator.pinToRootButton(rootButton: selectRoomButton, frame: selectRoomButton.frame)
        
        dash.pin
            .after(of: firstPairPicker, aligned: .bottom)
            .before(of: secondPairPicker, aligned: .top)
        
        traitCollectionDidChange(nil)
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
        presenter?.didCheckDate(dateToCheck: datePicker.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if presenter?.curWeekDayInFilter == -1 {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            datePicker.date = presenter!.setCorrectCurrentDate()
            alertManager.showAlert(presentTo: self, title: "Выбран неверный день", message: "В воскресенье ВУЗ закрыт.\nВыбери другой день")
            return false
        }
        
        if presenter!.curWeekInFilter < 1 || presenter!.curWeekInFilter > 17 {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            datePicker.date = presenter!.setCorrectCurrentDate()
            alertManager.showAlert(presentTo: self, title: "Выбрана неверная дата", message: "Семестр начался \(formatter.string(from: presenter!.semStartDate)) и закончится \(formatter.string(from: presenter!.semEndDate)).\nВыбери дату из этих рамок")
            return false
        }
        return true
    }
    
    private func setupDatePicker() {
        datePicker.date = presenter!.setCorrectCurrentDate()
        datePicker.locale = .current
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        } else {

        }
    }
    
    
    private func setupLowerSubview() {
        lowerView.layer.cornerRadius = 20
        lowerView.backgroundColor = UIColor.systemGroupedBackground
        lowerView.alpha = 0.8
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
        
        dash.font = .systemFont(ofSize: 24, weight: .bold)
        dash.numberOfLines = 1
        dash.textAlignment = .center
        dash.text = "-"
        
        pairSelectView.addSubview(pairLabel)
        pairSelectView.bringSubviewToFront(pairLabel)
        
        pairLabel.pin
            .top(15)
            .left(15)
            .height(30)
            .width(70)
        
        pairSelectView.layoutSubviews()
        
        pairSelectView.addSubview(pairSwitcher)
        pairSwitcher.onTintColor = UIColor(rgb: 0xEA7500)
        pairSwitcher.pin
            .top(15)
            .left(screenWidth < 500 ? (screenWidth - 80) - 80 : 400 - 80)
        
        pairSelectView.addSubview(firstPairPicker)
        pairSelectView.addSubview(secondPairPicker)
        
        pairSelectView.addSubview(firstPairTimeLabel)
        pairSelectView.addSubview(secondPairTimeLabel)
        
        firstPairTimeLabel.text = studyTimesStart[0]
        firstPairTimeLabel.layer.borderWidth = 1
        firstPairTimeLabel.layer.cornerRadius = 6
        firstPairTimeLabel.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
        firstPairTimeLabel.font = .systemFont(ofSize: 10, weight: .medium)
        firstPairTimeLabel.textAlignment = .center
        
        secondPairTimeLabel.text = studyTimesEnd[0]
        secondPairTimeLabel.layer.borderWidth = 1
        secondPairTimeLabel.layer.cornerRadius = 6
        secondPairTimeLabel.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
        secondPairTimeLabel.font = .systemFont(ofSize: 10, weight: .medium)
        secondPairTimeLabel.textAlignment = .center
    }
    
    private func createBuildingArea() {
        buildingSelectView.backgroundColor = UIColor.systemGroupedBackground
        buildingSelectView.layer.borderWidth = 2
        buildingSelectView.layer.borderColor = borderColor.cgColor
        
        buildingSelectView.layer.cornerRadius = 12
        buildingSelectView.layer.masksToBounds = true
        
        let buildingLabel = UILabel()
        
        buildingLabel.font = .systemFont(ofSize: 24, weight: .bold)
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
            .top(20)
            .left(screenWidth < 500 ? (screenWidth - 80)/2-30 : 400/2-30)
        
        buildingSelectView.addSubview(buildingSegController)
        buildingSelectView.addSubview(buildingSwitcher)
        buildingSwitcher.onTintColor = UIColor(rgb: 0xEA7500)
        buildingSwitcher.pin
            .top(20)
            .left(screenWidth < 500 ? (screenWidth - 80) - 80 : 400 - 80)
        
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
        audienceSwitcher.onTintColor = UIColor(rgb: 0xEA7500)
        audienceSwitcher.pin
            .top(20)
            .left(screenWidth < 500 ? (screenWidth - 80) - 80 : 400 - 80)
        
        audienceTextField.attributedPlaceholder = NSAttributedString(
            string: "501",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x808080)]
        )
        audienceTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        audienceTextField.pin
            .top(68)
            .left(25)
            .height(30)
            .width(screenWidth < 500 ? (screenWidth - 80) - 50 : 400 - 50)
        
        audienceTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        audienceTextField.textColor = .black
        audienceTextField.borderStyle = UITextField.BorderStyle.roundedRect
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
    
    private func helpPickerAnimation(picker: UIPickerView, recognizer: UIGestureRecognizer) {
        picker.removeGestureRecognizer(recognizer)
        let selectedRow = picker.selectedRow(inComponent: 0)
        var start = 0
        var stop = 0

        if selectedRow < 2 {
            start = 0
        } else {
            start = selectedRow - 2
        }

        if selectedRow > 4 {
            stop = 6
        } else {
            stop = selectedRow + 2
        }

        pickerHeight *= 2
        relayoutFlag = 0
        viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            picker.selectRow(start, inComponent: 0, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + (selectedRow != 0 ? 0.3 : 0)) { [self] in
                picker.selectRow(stop, inComponent: 0, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    picker.selectRow(selectedRow, inComponent: 0, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                        pickerHeight /= 2
                        viewDidLayoutSubviews()
                        relayoutFlag = 1
                        picker.addGestureRecognizer(recognizer)
                    }
                }
            }
        }
    }
    
    @objc
    private func didChooseDate() {
        DispatchQueue.global().async {
            usleep(1)
            DispatchQueue.main.async {
                _ = self.checkDate()
            }
        }
    }
    
    @objc
    private func didChangeBuilding(_ sender: UISegmentedControl) {
        buildingSwitcher.setOn(true, animated: true)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @objc
    private func didSwitchAudienceTrigger() {
        if !audienceSwitcher.isOn {
            audienceTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        }
    }
    
    @objc
    private func closeKeyboard() {
        if editingFlag == 0 {
            return
        }
        
        if audienceTextField.text != "" {
            audienceTextField.text! += "*"
        }
        
        view.endEditing(true)
        if audienceTextField.text != "" {
            audienceSwitcher.setOn(true, animated: true)
        } else {
            audienceSwitcher.setOn(false, animated: true)
        }
        editingFlag = 0
    }
    
    var editingFlag = 0
    @objc
    func didStartEnterAudience() {
        audienceTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        if audienceTextField.text!.contains("*") {
            audienceTextField.text = audienceTextField.text!.strip(by: "*")
        }
        editingFlag = 1
    }
    
    @objc
    func goToFirstScreen() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func didTapOnFirstPairPicker(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            helpPickerAnimation(picker: firstPairPicker, recognizer: tapRecognizer)
        }
    }
    
    @objc
    private func didTapOnSecondPairPicker(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            helpPickerAnimation(picker: secondPairPicker, recognizer: tapRecognizer)
        }
    }
    
    func secondAnim(stop: Int) {
        firstPairPicker.selectRow(stop, inComponent: 0, animated: true)
    }
    
    @objc
    private func sortAudiences() {
        if !checkDate() {
            return
        }
        
        if audienceSwitcher.isOn && audienceTextField.text == "" {
            audienceTextField.invalidAnimation()
            audienceTextField.backgroundColor = UIColor(rgb: 0xC51D34)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }

        indicator.start()

        var cellDataArr = presenter!.didSortAudiences(with: datePicker.date)

        if pairSwitcher.isOn {
            let beg = firstPairPicker.selectedRow(inComponent: 0)
            let end = secondPairPicker.selectedRow(inComponent: 0)

            cellDataArr = cellDataArr.filter{$0.pairStartInd <= beg && $0.pairEndInd >= end}
        }

        if buildingSwitcher.isOn {
            cellDataArr = cellDataArr.filter{$0.buildingInd == buildingSegController.selectedSegmentIndex}
        }

        if audienceSwitcher.isOn {
            cellDataArr = cellDataArr.filter { $0.cabinet.contains(audienceTextField.text!.strip(by: "*")) && $0.cabinet[0] == audienceTextField.text![0]}
        }

        if cellDataArr.count != 0 {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            let sortedViewController = SortedViewController(cellData: cellDataArr, date: datePicker.date)
            let navigationController = UINavigationController(rootViewController: sortedViewController)
            present(navigationController, animated: true, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.indicator.stopInstantly()
            }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            alertManager.showAlert(presentTo: self, title: "Не найдено ни одной подходящей аудитории...", message: "")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectRoomButton.invalidAnimation()
                self.indicator.stopFailure()
            }
        }
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pairSwitcher.setOn(true, animated: true)
        if pickerView == firstPairPicker {
            firstPairTimeLabel.text = studyTimesStart[row]
            if firstPairPicker.selectedRow(inComponent: 0) > secondPairPicker.selectedRow(inComponent: 0) {
                secondPairPicker.selectRow(firstPairPicker.selectedRow(inComponent: 0), inComponent: 0, animated: true)
                secondPairTimeLabel.text = studyTimesEnd[row]
            }
        } else {
            secondPairTimeLabel.text = studyTimesEnd[row]
            if firstPairPicker.selectedRow(inComponent: 0) > secondPairPicker.selectedRow(inComponent: 0) {
                firstPairPicker.selectRow(secondPairPicker.selectedRow(inComponent: 0), inComponent: 0, animated: true)
                firstPairTimeLabel.text = studyTimesStart[row]
            }
        }
    }
}

extension FilterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIView {
    func invalidAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        layer.add(animation, forKey: "position")
    }

    func repaintBorder(borderWidth: CGFloat = 1, color: UIColor = .red.withAlphaComponent(0.6)) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
}
