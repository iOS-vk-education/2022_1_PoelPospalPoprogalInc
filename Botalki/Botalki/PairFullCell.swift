import Foundation
import UIKit
import PinLayout

final class CityViewController: UIViewController {
    private let tempLabel = UILabel()
//    private let city: City
//
//    init(city: City) {
//        self.city = city
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        title = "hey"
        tempLabel.text = "hey"
        tempLabel.font = .systemFont(ofSize: 64, weight: .bold)
        view.backgroundColor = .systemBackground
        view.addSubview(tempLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tempLabel.pin.center().sizeToFit()
    }
}
