//
//  MyAlerts.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation
import UIKit

protocol BasicAlertDescription {
    func showAlert(presentTo: UIViewController, title: String?, message: String?)
}

final class AlertManager: BasicAlertDescription {
    static let shared: BasicAlertDescription = AlertManager()
    
    private init() {}
    
    func showAlert(presentTo controller: UIViewController, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
