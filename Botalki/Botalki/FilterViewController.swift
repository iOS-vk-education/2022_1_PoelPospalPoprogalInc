import UIKit
import PinLayout
//import SwiftUI

class FilterViewController: UIViewController {

    private let borderColor = UIColor(rgb: 0xC2A894)
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    private let imageCalendarBlack = UIImageView(image: UIImage(named: "calendarBlack.png"))
    private let imageCalendarWhite = UIImageView(image: UIImage(named: "calendarWhite.png"))
    
    private let dateButton = UIButton()
    private let selectRoomButton = UIButton()
    
    private let pairSelectView = UIView()
    private let pairSwitcher = UISwitch()
    private let firstPairTextField = UITextField()
    private let secondPairTextField = UITextField()
    
    private let firstPairPickerView = UIPickerView()
    private let secondPairPickerView = UIPickerView()
    
    private let buildingSelectView = UIView()
    private let buildingSegController = UISegmentedControl(items: ["ГЗ", "УЛК"])
    
    private let audienceSelectView = UIView()
    private let audienceSwitcher = UISwitch()
    private let audienceTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        
        view.addSubview(dateButton)
        view.addSubview(selectRoomButton)
        
        
        view.addSubview(pairSelectView)
        view.addSubview(buildingSelectView)
        view.addSubview(audienceSelectView)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
        
//        let tapScreen = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
//        func dismissKeyboard(sender: UITapGestureRecognizer) {
//            view.endEditing(true)
//        }
        
        createDateButton()
        createSelectRoomButton()
        createPairArea()
        createBuildingArea()
        createAudienceArea()
        
        screenSelection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        imageCalendarWhite.pin
            .top(82)
            .left(54)
            .height(45)
            .width(45)
        view.addSubview(imageCalendarWhite)
        view.bringSubviewToFront(imageCalendarWhite)
//        } else {
//            imageCalendarBlack.pin
//                .top(82)
//                .left(54)
//                .height(45)
//                .width(45)
//            view.addSubview(imageCalendarBlack)
//            view.bringSubviewToFront(imageCalendarBlack)
//        }
        
        dateButton.pin
            .top(82)
            .left(self.view.frame.width / 2 + 10)
            .height(42)
            .width(self.view.frame.width / 3 + 20)
        
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
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func createDateButton() {
        dateButton.backgroundColor = UIColor.systemGroupedBackground
        dateButton.layer.borderWidth = 2
        dateButton.layer.borderColor = borderColor.cgColor
        
        dateButton.layer.cornerRadius = 16
        dateButton.layer.masksToBounds = true
        dateButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        
        let dateLabel = UILabel()
        
        dateLabel.font = .systemFont(ofSize: 22, weight: .bold)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .right
        dateLabel.text = "20.04.2022"
        
        dateButton.addSubview(dateLabel)
        dateButton.bringSubviewToFront(dateLabel)
        dateButton.layoutSubviews()
        
        dateLabel.pin
            .top(7)
            .left(12)
            .height(30)
            .width(130)
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
        pairSelectView.addSubview(pairSwitcher)
        pairSwitcher.pin
            .top(20)
            .left(pairSelectView.frame.width + 270)
            .height(100)
            .width(100)
        
        firstPairTextField.placeholder = "1"
        firstPairTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        firstPairTextField.pin
            .top(68)
            .left(audienceSelectView.frame.width + 25)
            .height(30)
            .width(140)
        
        firstPairTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        firstPairTextField.textColor = .black
        firstPairTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        audienceTextField.layer.borderColor = borderColor.cgColor
        firstPairTextField.autocorrectionType = UITextAutocorrectionType.no
        firstPairTextField.keyboardType = UIKeyboardType.numberPad
        firstPairTextField.returnKeyType = UIReturnKeyType.done
        firstPairTextField.clearButtonMode = UITextField.ViewMode.never
        firstPairTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//
        firstPairTextField.textAlignment = .center
        pairSelectView.addSubview(firstPairTextField)
        pairSelectView.addSubview(firstPairTextField)
        
        secondPairTextField.placeholder = "7"
        secondPairTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        secondPairTextField.pin
            .top(68)
            .left(pairSelectView.frame.width + 180)
            .height(30)
            .width(140)
        
        secondPairTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        secondPairTextField.textColor = .black
        secondPairTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        audienceTextField.layer.borderColor = borderColor.cgColor
        secondPairTextField.autocorrectionType = UITextAutocorrectionType.no
        secondPairTextField.keyboardType = UIKeyboardType.numberPad
        secondPairTextField.returnKeyType = UIReturnKeyType.done
        secondPairTextField.clearButtonMode = UITextField.ViewMode.never
        secondPairTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        secondPairTextField.textAlignment = .center
        pairSelectView.addSubview(secondPairTextField)
        pairSelectView.addSubview(secondPairTextField)
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
            .left(buildingSelectView.frame.width + 230)
            .height(34)
            .width(90)
        // Add target action method
//        buildingSegController.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)

        // Add this custom Segmented Control to our view
        buildingSelectView.addSubview(buildingSegController)
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
        
        audienceTextField.placeholder = "501"
        audienceTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        audienceTextField.pin
            .top(68)
            .left(audienceSelectView.frame.width + 25)
            .height(30)
            .width(295)
        
        audienceTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        audienceTextField.textColor = .black
        audienceTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        audienceTextField.layer.borderColor = borderColor.cgColor
        audienceTextField.autocorrectionType = UITextAutocorrectionType.no
        audienceTextField.keyboardType = UIKeyboardType.numberPad
        audienceTextField.returnKeyType = UIReturnKeyType.done
        audienceTextField.clearButtonMode = UITextField.ViewMode.never
        audienceTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        audienceTextField.textAlignment = .center
        audienceSelectView.addSubview(audienceTextField)
        audienceSelectView.addSubview(audienceTextField)
    }
    
    private func screenSelection() {
        firstScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        firstScreenButton.layer.cornerRadius = 10
        firstScreenButton.layer.masksToBounds = true
        firstScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        firstScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        firstScreenButton.addTarget(self, action: #selector(goToFirstScreen), for: .touchUpInside)
        firstScreenButton.frame = .init(x: 20, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0x785A43)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
        secondScreenButton.frame = .init(x: view.frame.width / 2 + 15, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
        layoutScreenButtonsSubviews(buttonSubView: firstScreenButton, iconNameOfButton: "house")
        layoutScreenButtonsSubviews(buttonSubView: secondScreenButton, iconNameOfButton: "magnifier")
    }
    
    @objc
    func goToFirstScreen() {
        let firstViewController: PairsViewController = PairsViewController()
        self.navigationController?.pushViewController(firstViewController, animated: false)
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
        let viewController = SortedViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}
