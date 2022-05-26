//
//  SplashViewController.swift
//  Botalki
//
//  Created by poliorang on 23.05.2022.
//

import UIKit

final class SplashViewController: UIViewController {
    private var firstViewController: PairsViewController = PairsViewController()
    
    let logoDoorView = UIImageView(image: UIImage(named: "doorWhiteWithoutFloor"))
    let logoDoorFloorView = UIImageView(image: UIImage(named: "doorWhiteFloor"))
    let textImageView = UIImageView(image: UIImage(named: "botalkiText"))
    let maskView = UIImageView(image: UIImage(named: "mask"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setup() {
        self.view.backgroundColor = UIColor(rgb: 0x785A43)
        navigationController?.setNavigationBarHidden(true, animated: true)
    
        view.addSubview(textImageView)
        view.addSubview(maskView)
        view.addSubview(logoDoorFloorView)
        view.addSubview(logoDoorView)
        
        logoDoorView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setup()
        
        textImageView.pin
            .vCenter(30)
            .hCenter(0)
            .height(35)
            .width(150)
        
        maskView.pin
            .vCenter(-28)
            .hCenter(0)
            .height(150)
            .width(150)
        
        logoDoorFloorView.pin
            .vCenter(-20)
            .hCenter(CGFloat(view.frame.width))
            .height(150)
            .width(150)
        
        logoDoorView.pin
            .vCenter(-20)
            .hCenter(0)
            .height(150)
            .width(150)
        
        animate()
        dismiss()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.4) {
            self.logoDoorView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.1) {
            self.logoDoorFloorView.transform = CGAffineTransform(translationX: self.view.frame.width * -1, y: 0)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6) {
            self.textImageView.transform = CGAffineTransform(translationX: 0, y: 40)
        }
    }
    
    
    func dismiss() {
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            navigationController?.pushViewController(self.firstViewController, animated: false)
        }
    }
}
