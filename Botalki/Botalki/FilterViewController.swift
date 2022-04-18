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
        
        createDateButton()
        createSelectRoomButton()
        screenSelection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageCalendar.pin
            .top(80)
            .left(45)
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
            .height(40)
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
        
        selectRoomButton.layer.cornerRadius = 16
        selectRoomButton.layer.masksToBounds = true
        selectRoomButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        selectRoomButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)

        
        selectRoomButton.setTitle("Подобрать", for: .normal)
//        dateButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
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
