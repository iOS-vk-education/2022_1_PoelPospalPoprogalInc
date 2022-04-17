//import UIKit
//import Kingfisher
//
//class CityTableViewCell: UITableViewCell {
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var img: UIImageView!
//    private let imgBg = UIImageView()
//
//
//
////    let mySeparator = UIView()
////    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////            super.init(style: style, reuseIdentifier: reuseIdentifier)
////
////            mySeparator.layer.borderColor = UIColor.green.cgColor
////            mySeparator.layer.borderWidth = 2.0
////            mySeparator.translatesAutoresizingMaskIntoConstraints = false
////            contentView.addSubview(mySeparator)
////
////            let views = [
////                "contentView" : contentView,
////                "separator" : mySeparator
////                ]
////
////            var allConstraints: [NSLayoutConstraint] = []
////            allConstraints += NSLayoutConstraint.constraints(withVisualFormat:
////                "H:|-[separator]|", options: [], metrics: nil, views: views)
////            NSLayoutConstraint.activate(allConstraints)
////
////        }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//    private let images: [String] = ["personalhotspot", "person", "asterisk"]
//
////    init(frame: CGRect) {
////        super.init(frame: frame)
////
////        addSubview(imgBg)
////        imgBg.image = UIImage(systemName: "pencil")
////    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func config(with city: City) {
//
////        let theImage = UIImage(named: "/Users/sergey_nikolaev/immg.png") // create a UIImage
////        imageView?.image = theImage // UIImageView takes a UIImage
////        theImage.pin
//
////        addSubview(imgBg)
////        imgBg.kf.setImage(with: URL(string: "https://i.playground.ru/p/1h0LXc77AbN5FT1bDDCCFA.jpeg"), placeholder: nil, options: nil, completionHandler: nil)
////        imgBg.frame = bounds
////        imgBg.bringSubviewToFront(titleLabel)
//
//        let fullTime = String("\(NSDate())".split(separator: " ")[1])
//        let time = "\(((Int(fullTime.split(separator: ":")[0]) ?? -1) + city.timeDelta)%24):\(fullTime[fullTime.index(fullTime.startIndex, offsetBy: 3)...])"
//        titleLabel.text = city.title
//        temperatureLabel.text = city.temperature
//        timeLabel.text = time
//        img.image = UIImage(systemName: images[Int.random(in: 0...2)])
////        self.pin.all(5)
////        addSubview(imgBg)
////        imgBg.kf.setImage(with: URL(string: "https://i.playground.ru/p/1h0LXc77AbN5FT1bDDCCFA.jpeg"), placeholder: nil, options: nil, completionHandler: nil)
////        imgBg.frame = bounds
////        imgBg.bringSubviewToFront(titleLabel)
//
////        backgroundColor = .systemBackground
////        contentView.layer.shadowColor = UIColor.black.cgColor
////        contentView.layer.shadowRadius = 0.5
////        contentView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
////        contentView.layer.shadowOpacity = 0.8
////        contentView.layer.cornerRadius = 8
////        contentView.backgroundColor = .systemBackground
//
//        selectionStyle = .none
//    }
//}


import Foundation
import UIKit
import PinLayout
//import Kingfisher


final class PairTableViewCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let houseLabel = UILabel()

    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDor = UIImageView(image: UIImage(named: "dor.png"))
    private let imageViewDor2 = UIImageView(image: UIImage(named: "dor.png"))
//    private let timeLabel = UILabel()
    
//    private let images: [String] = ["personalhotspot", "person", "asterisk"]
    
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.alpha = 0
        self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                UIView.animate(withDuration: 1) {
                    self.alpha = 1
                    self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                }
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        containerView.addSubview(imageViewClock)
        containerView.bringSubviewToFront(imageViewClock)
        
        containerView.addSubview(imageViewDor)
        containerView.bringSubviewToFront(imageViewDor)
        
        containerView.addSubview(imageViewDor2)
        containerView.bringSubviewToFront(imageViewDor2)
//
//        let imageDor = UIImage(named: "dor.png")
//        let imageViewDor = UIImageView(image: imageDor!)
//        imageViewDor.frame = CGRect(x: 70, y: 20, width: 20, height: 20)
//        containerView.addSubview(imageViewDor)
//        containerView.bringSubviewToFront(imageViewDor)
        
        selectionStyle = .none
        
        timeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        timeLabel.textColor = .black
        timeLabel.numberOfLines = 2
        timeLabel.textAlignment = .right
        
        houseLabel.font = .systemFont(ofSize: 17, weight: .bold)
        houseLabel.textColor = .black
        houseLabel.numberOfLines = 2
        houseLabel.textAlignment = .left
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 0.5
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
        
        
        [timeLabel, houseLabel].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin
            .horizontally(15)
            .vertically(6)
        
        
        timeLabel.pin
            .vCenter()
//            .bottom(8)
            .left(60)
            .height(60)
            .width(60)
            .sizeToFit(.height)
        
        houseLabel.pin
            .vCenter()
//            .bottom(8)
            .right(30)
            .height(60)
            .width(60)
            .sizeToFit(.height)
        
        imageViewClock.pin
            .vCenter()
            .left(20)
            .height(27)
            .width(27)
//            .sizeToFit(.height)
        
        imageViewDor.pin
            .top(11)
            .left(120)
            .height(25)
            .width(25)
        
        imageViewDor2.pin
            .top(46)
            .left(120)
            .height(25)
            .width(25)
    }
    
    func config(with indexCell: Int) {
        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35",
                          "13:50\n15:25", "15:40\n17:15", "17:25\n19:00",
                          "19:10\n20:45"]
        
        let timee: String
        if indexCell > 6 {
            timee = "Мухосранск"
        }
        else {
            timee = studyTimes[indexCell]
        }
        
        houseLabel.text = "ГЗ\nУЛК"
        timeLabel.text = timee

    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
