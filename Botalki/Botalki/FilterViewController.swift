import UIKit
import PinLayout
//import SwiftUI

class FilterViewController: UIViewController {

    private let borderColor = UIColor(rgb: 0xC2A894)
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    private let imageCalendar = UIImageView(image: UIImage(named: "calendar.png"))
    
    private let dateButton = UIButton()
    private let selectRoomButton = UIButton()
    
    private let pairSelectView = UIView()
    private let pairSwitcher = UISwitch()
    private let firstPairTextField = UITextField()
    private let secondPairTextField = UITextField()
    
    private let buildingSelectView = UIView()
    
    
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
        
        view.addSubview(imageCalendar)
        view.bringSubviewToFront(imageCalendar)
        
        view.addSubview(pairSelectView)
        view.addSubview(buildingSelectView)
        view.addSubview(audienceSelectView)
        
        createDateButton()
        createSelectRoomButton()
        createPairArea()
        createBuildingArea()
        createAudienceArea()
        
        screenSelection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageCalendar.pin
            .top(80)
            .left(48)
            .height(45)
            .width(45)
        
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
    
    private func createDateButton() {
        dateButton.backgroundColor = UIColor.systemBackground
        dateButton.layer.borderWidth = 2
        dateButton.layer.borderColor = borderColor.cgColor
        
        dateButton.layer.cornerRadius = 16
        dateButton.layer.masksToBounds = true
        dateButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        
//        if UIColor.systemBackground[0] == 0x6000016446c0 {
//            dateButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
//        }
//        else {
//
//        }
        print(UIColor.systemBackground)
        dateButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)

        
        dateButton.setTitle("20.04.2022", for: .normal)
//        dateButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
    }
    
    private func createSelectRoomButton() {
        selectRoomButton.backgroundColor = UIColor(rgb: 0xC2A894)
        
        selectRoomButton.layer.cornerRadius = 12
        selectRoomButton.layer.masksToBounds = true
        selectRoomButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        selectRoomButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)

        
        selectRoomButton.setTitle("Подобрать", for: .normal)
//        dateButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
    }
    
    private func createPairArea() {
        pairSelectView.backgroundColor = UIColor.systemBackground
        pairSelectView.layer.borderWidth = 2
        pairSelectView.layer.borderColor = borderColor.cgColor
        
        pairSelectView.layer.cornerRadius = 12
        pairSelectView.layer.masksToBounds = true
        pairSelectView.layoutSubviews()
        
        
        let pairLabel = UILabel()
        
        pairLabel.font = .systemFont(ofSize: 24, weight: .bold)
        pairLabel.textColor = .black
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
        
//        pairSwitcher.frame(forAlignmentRect: CGRect(x: 270, y: 20, width: 120, height: 100))
        pairSelectView.addSubview(pairSwitcher)
        pairSelectView.addSubview(pairSwitcher)
        // когда-то я сделаю это через пин, обещаю
        pairSwitcher.pin
            .top(20)
            .left(pairSelectView.frame.width + 270)
            .height(100)
            .width(100)
        
        firstPairTextField.placeholder = "1я"
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
//        audienceTextField.keyboardType = UIKeyboardType.default
//        audienceTextField.returnKeyType = UIReturnKeyType.done
        firstPairTextField.clearButtonMode = UITextField.ViewMode.never
        firstPairTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        firstPairTextField.textAlignment = .center
        pairSelectView.addSubview(firstPairTextField)
        pairSelectView.addSubview(firstPairTextField)
        
        secondPairTextField.placeholder = "6я"
        secondPairTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        secondPairTextField.pin
            .top(68)
            .left(audienceSelectView.frame.width + 180)
            .height(30)
            .width(140)
        
        secondPairTextField.backgroundColor = UIColor(rgb: 0xC4C4C4)
        secondPairTextField.textColor = .black
        secondPairTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        audienceTextField.layer.borderColor = borderColor.cgColor
        secondPairTextField.autocorrectionType = UITextAutocorrectionType.no
//        audienceTextField.keyboardType = UIKeyboardType.default
//        audienceTextField.returnKeyType = UIReturnKeyType.done
        secondPairTextField.clearButtonMode = UITextField.ViewMode.never
        secondPairTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        secondPairTextField.textAlignment = .center
        pairSelectView.addSubview(secondPairTextField)
        pairSelectView.addSubview(secondPairTextField)
        
    }
    
    
    private func createBuildingArea() {
        buildingSelectView.backgroundColor = UIColor.systemBackground
        buildingSelectView.layer.borderWidth = 2
        buildingSelectView.layer.borderColor = borderColor.cgColor
        
        buildingSelectView.layer.cornerRadius = 12
        buildingSelectView.layer.masksToBounds = true
        
        let buildingLabel = UILabel()
        
        buildingLabel.font = .systemFont(ofSize: 24, weight: .bold)
        buildingLabel.textColor = .black
        buildingLabel.numberOfLines = 1
        buildingLabel.textAlignment = .right
        buildingLabel.text = "Корпус"
        
        buildingSelectView.addSubview(buildingLabel)
        buildingSelectView.bringSubviewToFront(buildingLabel)

        buildingSelectView.layoutSubviews()

        buildingLabel.pin
            .top(20)
            .left(15)
            .height(30)
            .width(95)
        
        let buildingSegmentController = UISegmentedControl(frame: CGRect(x: 270, y: 20, width: 120, height: 100))
        buildingSelectView.addSubview(buildingSegmentController)
        buildingSelectView.addSubview(buildingSegmentController)
    }
    
    private func createAudienceArea() {
        audienceSelectView.backgroundColor = UIColor.systemBackground
        audienceSelectView.layer.borderWidth = 2
        audienceSelectView.layer.borderColor = borderColor.cgColor
        
        audienceSelectView.layer.cornerRadius = 10
        audienceSelectView.layer.masksToBounds = true
        
        let audienceLabel = UILabel()
        
        audienceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        audienceLabel.textColor = .black
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
        
        audienceTextField.placeholder = "501ю"
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
//        audienceTextField.keyboardType = UIKeyboardType.default
//        audienceTextField.returnKeyType = UIReturnKeyType.done
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
}
