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
    private let timeText = UILabel()
    private let GZText = UILabel()
    private let ULKText = UILabel()
    private let GZListText = UILabel()
    private let ULKListText = UILabel()
    
    private var dor2FullPos: UIEdgeInsets = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
    private var ULKListFullPos: UIEdgeInsets = UIEdgeInsets(top: 47, left: 0, bottom: 0, right: 0)
//    private var ULKTextFullPos: UIEdgeInsets = UIEdgeInsets(top: 47, left: 0, bottom: 0, right: 0)

    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDor = UIImageView(image: UIImage(named: "dor.png"))
    private var imageViewDor2 = UIImageView(image: UIImage(named: "dor.png"))
//    private var imageViewDor2Full = UIImageView(image: UIImage(named: "dor.png"))
    
    private let GZcabinets = ["240", "333ю", "426", "232", "327.1", "430", "384", "323", "427ю", "502ю", "522", "514", "504", "425ю", "390", "432", "420", "419ю", "386", "429ю", "505", "304", "424", "526", "228"]
    
    private let ULKcabinets = ["218л", "829л", "1108л", "224л", "529л", "732л", "615л", "711л", "189.4", "708л", "520л", "836л", "437л", "533л", "908л", "141л", "818л", "225л", "523л", "114л", "259л", "1022л", "531л", "1019л", "822л", "522л", "619л", "530л", "1035л", "145л", "518л", "189.5", "243л", "212л", "532л", "544л", "253л", "222л", "915л", "534л", "1013л", "744л", "1139л", "834л", "536л", "820л", "1017л", "503", "727л", "210", "739л", "1120л", "255л", "725л", "831л"]
    private var GZcabinetsShortStrings: [String] = []
    private var ULKcabinetsShortStrings: [String] = []
    
    private var GZcabinetsFullStrings: [String] = []
    private var ULKcabinetsFullStrings: [String] = []
    
    private var numberOfCabinets: Int = 0
    var fullCellSz: Int = 95
    
//    private let timeLabel = UILabel()
    
//    private let images: [String] = ["personalhotspot", "person", "asterisk"]
    
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.alpha = 0
        self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.5) {
                    self.alpha = 1
                    self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                }
        
        
        self.numberOfCabinets = Int((UIScreen.main.bounds.width - 220)/50) - 1
        for k in 0...6 {
            self.GZcabinetsShortStrings.append("")
            self.ULKcabinetsShortStrings.append("")
            for i in 0..<self.numberOfCabinets {
                self.GZcabinetsShortStrings[k] += (GZcabinets[Int.random(in: i..<GZcabinets.count)] + ", ")
                self.ULKcabinetsShortStrings[k] += (ULKcabinets[Int.random(in: i..<ULKcabinets.count)] + ", ")
            }
            self.GZcabinetsShortStrings[k] += "..."
            self.ULKcabinetsShortStrings[k] += "..."
        }
        
        let GZLines = Int.random(in: 1...6)
        let ULKLines = Int.random(in: 1...6)
        for k in 0...6 {
            self.GZcabinetsFullStrings.append("")
            self.ULKcabinetsFullStrings.append("")
            for j in 0..<GZLines {
                for i in 0..<self.numberOfCabinets {
                    self.GZcabinetsFullStrings[k] += (GZcabinets[Int.random(in: i..<GZcabinets.count)] + ((j == GZLines-1 && i == numberOfCabinets-1) ? "" : ", "))
                }
                if j != GZLines - 1 {
                    self.GZcabinetsFullStrings[k] += "\n"
                }
            }
            for j in 0..<ULKLines {
                for i in 0..<self.numberOfCabinets {
                    self.ULKcabinetsFullStrings[k] += (ULKcabinets[Int.random(in: i..<ULKcabinets.count)] + ((j == ULKLines-1 && i == numberOfCabinets-1) ? "" : ", "))
                }
                if j != ULKLines - 1 {
                    self.ULKcabinetsFullStrings[k] += "\n"
                }
            }
        }
        
        self.fullCellSz = 50 + (GZLines + ULKLines) * 21
        
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
        
        timeText.font = .systemFont(ofSize: 17, weight: .semibold)
        timeText.textColor = .black
        timeText.numberOfLines = 2
        timeText.textAlignment = .right
        
        GZText.font = .systemFont(ofSize: 17, weight: .bold)
        GZText.textColor = .black
        GZText.numberOfLines = 1
        GZText.textAlignment = .left
        
        ULKText.font = .systemFont(ofSize: 17, weight: .bold)
        ULKText.textColor = .black
        ULKText.numberOfLines = 1
        ULKText.textAlignment = .left
        
        GZListText.font = .systemFont(ofSize: 17, weight: .medium)
        GZListText.textColor = .black
        GZListText.numberOfLines = 1
        GZListText.textAlignment = .left
        
        ULKListText.font = .systemFont(ofSize: 17, weight: .medium)
        ULKListText.textColor = .black
        ULKListText.numberOfLines = 1
        ULKListText.textAlignment = .left
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 0.5
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
        
        
        [timeText, GZText, ULKText, GZListText, ULKListText].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin
            .horizontally(15)
            .vertically(6)
        
        
        timeText.pin
//            .vCenter()
//            .bottom(8)
            .top(11)
            .left(52)
            .height(60)
            .width(60)
            .sizeToFit(.height)
        
        GZText.pin
//            .vCenter(-15)
            .top(15)
            .right(25)
            .height(30)
            .width(35)
            .sizeToFit(.width)
        
        ULKText.pin
            .top(dor2FullPos.top)
            .right(25)
            .height(30)
            .width(35)
            .sizeToFit(.width)
        
        GZListText.pin
            .top(15)
            .left(155)
            .height(60)
            .width(200)
            .sizeToFit(.width)
        
        ULKListText.pin
            .top(ULKListFullPos.top)
            .left(155)
            .height(60)
            .width(200)
            .sizeToFit(.width)
        
        imageViewClock.pin
//            .vCenter()
            .top(28)
            .left(15)
            .height(25)
            .width(25)
//            .sizeToFit(.height)
        
        imageViewDor.pin
            .top(11)
            .left(110)
            .height(25)
            .width(25)
        
//        if let coords = ULKListText.superview?.convert(ULKListText.frame, to: nil) {
//        print(ULKListText.frame)
//        }
        imageViewDor2.pin
            .top(dor2FullPos.top)
            .left(110)
            .height(25)
            .width(25)
    }
    
    func config(with indexCell: Int) {
        
        dor2FullPos.top = 45
        ULKListFullPos.top = 47
        
        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35", "13:50\n15:25", "15:40\n17:15", "17:25\n19:00", "19:10\n20:45"]
        
        let timee: String
//        let gzString: String = ""
//        let ulkString: String = ""
        
        if indexCell > 6 {
            timee = "Мухосранск"
        }
        else {
            timee = studyTimes[indexCell]
        }
        
        GZText.text = "ГЗ"
        ULKText.text = "УЛК"
        timeText.text = timee
        
        GZListText.text = GZcabinetsShortStrings[indexCell]
        ULKListText.text = ULKcabinetsShortStrings[indexCell]
//        print(ULKListText.frame.height)

    }
    
    func config2(with indexCell: Int) {
//        imageViewDor2.removeFromSuperview()
//        GZText.pin
//            .top(30)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        ULKText.pin
//            .top(120)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        GZListText.pin
//            .top(30)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        ULKListText.pin
//            .top(120)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        imageViewDor.pin
//            .top(11)
//            .left(110)
//            .height(25)
//            .width(25)
//
//        containerView.addSubview(imageViewDor2)
//        imageViewDor2 = UIImageView(image: UIImage(named: "dor.png"))
//        containerView.addSubview(imageViewDor2)
//        containerView.bringSubviewToFront(imageViewDor2)
        
//        imageViewDor2Full.pin
//            .top(120)
//            .left(110)
//            .height(25)
//            .width(25)
        
//        let numberOfCabinets = Int((frame.width - 220)/50) - 1
        
//        let ulkStrings = Int(ULKcabinets.count/numberOfCabinets) + 1
//        let gzStrings = Int(GZcabinets.count/numberOfCabinets) + 1
        
        
        let ulkStrings = ULKcabinetsFullStrings[indexCell].split(separator: "\n").count
        let gzStrings = GZcabinetsFullStrings[indexCell].split(separator: "\n").count
        
//        print(ulkStrings, gzStrings)
        
        dor2FullPos.top += CGFloat((gzStrings-1) * 21)
        ULKListFullPos.top += CGFloat((gzStrings-1) * 21)
        
        GZListText.numberOfLines = gzStrings
        ULKListText.numberOfLines = ulkStrings
        
//        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35",
//                          "13:50\n15:25", "15:40\n17:15", "17:25\n19:00",
//                          "19:10\n20:45"]
        
//        let timee: String
//        var gzString: String = ""
//        var ulkString: String = ""
//
//        if indexCell > 6 {
//            timee = "Мухосранск"
//        }
//        else {
//            timee = studyTimes[indexCell]
//        }
        
//        GZText.text = "ГЗ"
//        ULKText.text = "УЛК"
//        timeText.text = timee
        
//        for k in 0..<gzStrings {
//            for i in 0..<numberOfCabinets {
//                gzString += (GZcabinets[k*numberOfCabinets + i] + ", ")
//
//            }
//            gzString += "\n"
//        }
        
//        for k in 0..<ulkStrings {
//            for i in 0..<numberOfCabinets {
//                ulkString += (ULKcabinets[k*numberOfCabinets + i] + ", ")
//
//            }
//            ulkString += "\n"
//        }
        GZListText.text = GZcabinetsFullStrings[indexCell]
        ULKListText.text = ULKcabinetsFullStrings[indexCell]

    }
}

//
//final class BigPairTableViewCell: UITableViewCell {
//    private let timeText = UILabel()
//    private let GZText = UILabel()
//    private let ULKText = UILabel()
//    private let GZListText = UILabel()
//    private let ULKListText = UILabel()
//
//    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
//    private let imageViewDor = UIImageView(image: UIImage(named: "dor.png"))
//    private let imageViewDor2 = UIImageView(image: UIImage(named: "dor.png"))
//
//    private let GZcabinets = ["240", "333ю", "426", "232", "327.1", "430", "384", "323", "427ю", "502ю", "522", "514", "504", "425ю", "390", "432", "420", "419ю", "386", "429ю", "505", "304", "424", "526", "228"]
//
//    private let ULKcabinets = ["218л", "829л", "1108л", "224л", "529л", "732л", "615л", "711л", "189.4", "708л", "520л", "836л", "437л", "533л", "908л", "141л", "818л", "225л", "523л", "114л", "259л", "1022л", "531л", "1019л", "822л", "522л", "619л", "530л", "1035л", "145л", "518л", "189.5", "243л", "212л", "532л", "544л", "253л", "222л", "915л", "534л", "1013л", "744л", "1139л", "834л", "536л", "820л", "1017л", "503", "727л", "210", "739л", "1120л", "255л", "725л", "831л"]
////    private let timeLabel = UILabel()
//
////    private let images: [String] = ["personalhotspot", "person", "asterisk"]
//
//    private let containerView = UIView()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
////        self.alpha = 0
////        self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
////                UIView.animate(withDuration: 1) {
////                    self.alpha = 1
////                    self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
////                }
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        containerView.addSubview(imageViewClock)
//        containerView.bringSubviewToFront(imageViewClock)
//
//        containerView.addSubview(imageViewDor)
//        containerView.bringSubviewToFront(imageViewDor)
//
//        containerView.addSubview(imageViewDor2)
//        containerView.bringSubviewToFront(imageViewDor2)
//
//        selectionStyle = .none
//
//        timeText.font = .systemFont(ofSize: 17, weight: .semibold)
//        timeText.textColor = .black
//        timeText.numberOfLines = 2
//        timeText.textAlignment = .right
//
//        GZText.font = .systemFont(ofSize: 17, weight: .bold)
//        GZText.textColor = .black
//        GZText.numberOfLines = 1
//        GZText.textAlignment = .left
//
//        ULKText.font = .systemFont(ofSize: 17, weight: .bold)
//        ULKText.textColor = .black
//        ULKText.numberOfLines = 1
//        ULKText.textAlignment = .left
//
//        GZListText.font = .systemFont(ofSize: 17, weight: .medium)
//        GZListText.textColor = .black
//        GZListText.numberOfLines = 1
//        GZListText.textAlignment = .left
//
//        ULKListText.font = .systemFont(ofSize: 17, weight: .medium)
//        ULKListText.textColor = .black
//        ULKListText.numberOfLines = 1
//        ULKListText.textAlignment = .left
//
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowRadius = 0.5
//        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
//        containerView.layer.shadowOpacity = 0.8
//        containerView.layer.cornerRadius =  20
//        containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
//
//
//        [timeText, GZText, ULKText, GZListText, ULKListText].forEach {
//            containerView.addSubview($0)
//        }
//
//        contentView.addSubview(containerView)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        containerView.pin
//            .horizontally(15)
//            .vertically(6)
//
//
//        timeText.pin
//            .vCenter()
////            .bottom(8)
//            .left(52)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        GZText.pin
//            .vCenter(-15)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        ULKText.pin
//            .vCenter(15)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        GZListText.pin
//            .vCenter(-15)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        ULKListText.pin
//            .vCenter(15)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        imageViewClock.pin
//            .vCenter()
//            .left(15)
//            .height(25)
//            .width(25)
////            .sizeToFit(.height)
//
//        imageViewDor.pin
//            .top(11)
//            .left(110)
//            .height(25)
//            .width(25)
//
//        imageViewDor2.pin
//            .top(46)
//            .left(110)
//            .height(25)
//            .width(25)
//    }
//
//    func config(with indexCell: Int) {
//        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35",
//                          "13:50\n15:25", "15:40\n17:15", "17:25\n19:00",
//                          "19:10\n20:45"]
//
//        let timee: String
//        var gzString: String = ""
//        var ulkString: String = ""
//
//        if indexCell > 6 {
//            timee = "Мухосранск"
//        }
//        else {
//            timee = studyTimes[indexCell]
//        }
//
//        GZText.text = "ГЗ"
//        ULKText.text = "УЛК"
//        timeText.text = timee
//
//        let numberOfCabinets = Int((frame.width - 220)/50) - 1
//        print(numberOfCabinets)
//        for i in 0..<numberOfCabinets {
//            gzString += (GZcabinets[Int.random(in: i..<GZcabinets.count)] + ", ")
//            ulkString += (ULKcabinets[Int.random(in: i..<ULKcabinets.count)] + ", ")
//        }
//        GZListText.text = gzString + "..."
//        ULKListText.text = ulkString + "..."
//
//    }
//
//    private func setup2() {
//        GZText.pin
////            .vCenter(-15)
//            .top(30)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        ULKText.pin
////            .vCenter(15)
//            .top(120)
//            .right(25)
//            .height(30)
//            .width(35)
//            .sizeToFit(.width)
//
//        GZListText.pin
//            .top(30)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        ULKListText.pin
//            .top(120)
//            .left(155)
//            .height(60)
//            .width(60)
//            .sizeToFit(.height)
//
//        imageViewDor.pin
//            .top(11)
//            .left(110)
//            .height(25)
//            .width(25)
//
//        imageViewDor2.pin
//            .top(120)
//            .left(110)
//            .height(25)
//            .width(25)
//    }
//
//    func config2(with indexCell: Int) {
//        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35",
//                          "13:50\n15:25", "15:40\n17:15", "17:25\n19:00",
//                          "19:10\n20:45"]
//
//        let timee: String
//        var gzString: String = ""
//        var ulkString: String = ""
//
//        if indexCell > 6 {
//            timee = "Мухосранск"
//        }
//        else {
//            timee = studyTimes[indexCell]
//        }
//
//        GZText.text = "ГЗ"
//        ULKText.text = "УЛК"
//        timeText.text = timee
//
//        let numberOfCabinets = Int((frame.width - 220)/50) - 1
//        print(numberOfCabinets)
//        for i in 0..<numberOfCabinets {
//            gzString += (GZcabinets[Int.random(in: i..<GZcabinets.count)] + ", ")
//            ulkString += (ULKcabinets[Int.random(in: i..<ULKcabinets.count)] + ", ")
//        }
//        GZListText.text = gzString + "..."
//        ULKListText.text = ulkString + "..."
//
//    }
//}

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
