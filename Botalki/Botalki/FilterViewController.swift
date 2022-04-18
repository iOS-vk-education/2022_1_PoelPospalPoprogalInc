import UIKit
import PinLayout
//import SwiftUI

class FilterViewController: UIViewController {

    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        
        screenSelection()
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
