//
//  SplashPresenterswift.swift
//  Botalki
//
//  Created by poliorang on 08.05.2022.
//

import UIKit

protocol SplashPresenterDescription {
    func presenter()
    func dismiss(completion: (() -> Void)?)
}

final class SplashPresenter : SplashPresenterDescription {
    
    private lazy var foregroundSplashWindow: UIWindow = {
        let splashWindow = UIWindow()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashViewController = storyboard.instantiateViewController(identifier: "SplashViewController") as? SplashViewController
        
        splashWindow.windowLevel = .normal + 1
        splashWindow.rootViewController = splashViewController
        
        return splashWindow
    }()
    
    func presenter() {
        foregroundSplashWindow.isHidden = false
        
        let splashViewController = foregroundSplashWindow.rootViewController as? SplashViewController
        
        UIView.animate(withDuration: 0.3) {
            splashViewController?.logoImageView.transform = CGAffineTransform(scaleX: 88 / 72, y: 88 / 72)
        }
    }
    
    func dismiss(completion: (() -> Void)?) {
        
    }
    
    
}
