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
    
    private var dor2FullPos = CGFloat(45)
    private var ULKListFullPos = CGFloat(47)
    private var ListWidth = CGFloat(UIScreen.main.bounds.width - 220)
//    private var ULKTextFullPos: UIEdgeInsets = UIEdgeInsets(top: 47, left: 0, bottom: 0, right: 0)

    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDor = UIImageView(image: UIImage(named: "door.png"))
    private var imageViewDor2 = UIImageView(image: UIImage(named: "door.png"))
//    private var imageViewDor2Full = UIImageView(image: UIImage(named: "dor.png"))
    
//    var GZcabinets = ["240", "333ю", "426", "232", "327.1", "430", "384", "323", "427ю", "502ю", "522", "514", "504", "425ю", "390", "432", "420", "419ю", "386", "429ю", "505", "304", "424", "526", "228"]
//
//    var ULKcabinets = ["218л", "829л", "1108л", "224л", "529л", "732л", "615л", "711л", "189.4", "708л", "520л", "836л", "437л", "533л", "908л", "141л", "818л", "225л", "523л", "114л", "259л", "1022л", "531л", "1019л", "822л", "522л", "619л", "530л", "1035л", "145л", "518л", "189.5", "243л", "212л", "532л", "544л", "253л", "222л", "915л", "534л", "1013л", "744л", "1139л", "834л", "536л", "820л", "1017л", "503", "727л", "210", "739л", "1120л", "255л", "725л", "831л"]
//
    var GZcabinets: [String] = []

    var ULKcabinets: [String] = []
    
    
//    var GZcabinets: [[[String]]]
//
//    var ULKcabinets: [[[String]]]
    
    private var GZcabinetsShortString: String = ""
    private var ULKcabinetsShortString: String = ""
    
    private var GZcabinetsFullString: String = ""
    private var ULKcabinetsFullString: String = ""
    
    private var numberOfCabinetsInLine: Int = 0
    var fullCellSz: Int = 95
    var wasConfiguredFlag = 0
    
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
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCabinetsFields() {
        GZcabinetsShortString = ""
        ULKcabinetsShortString = ""
        GZcabinetsFullString = ""
        ULKcabinetsFullString = ""
        
        numberOfCabinetsInLine = Int((UIScreen.main.bounds.width - 220)/47) - 1
//        print(UIScreen.main.bounds.width, numberOfCabinetsInLine)
        
        for i in 0..<numberOfCabinetsInLine {
            if i < GZcabinets.count {
                GZcabinetsShortString += (GZcabinets[i] + ((i != numberOfCabinetsInLine-1) ? ", " : "..."))
            }
            if i < ULKcabinets.count {
                ULKcabinetsShortString += (ULKcabinets[i] + ((i != numberOfCabinetsInLine-1) ? ", " : "..."))
            }
        }
        
        var GZLines = 1
        var ULKLines = 1
        
        var i = 0
        for (j, cab) in GZcabinets.enumerated() {
            if (i + 1) % numberOfCabinetsInLine == 0 {
                if j != GZcabinets.count - 1 && cab[String.Index(encodedOffset: 0)] != GZcabinets[j+1][String.Index(encodedOffset: 0)] {
                    GZcabinetsFullString += "\(cab);\n"
                    i = 0
                    GZLines += 1
                } else if j != GZcabinets.count - 1 {
                    GZcabinetsFullString += "\(cab),\n"
                    GZLines += 1
                    i = 0
                } else {
                    GZcabinetsFullString += "\(cab)"
                }
            } else if j != GZcabinets.count - 1 && cab[String.Index(encodedOffset: 0)] != GZcabinets[j+1][String.Index(encodedOffset: 0)] {
                GZcabinetsFullString += "\(cab);\n"
                i = 0
                GZLines += 1
            } else {
                i += 1
                GZcabinetsFullString += "\(cab)" + ((j != GZcabinets.count - 1) ? ", " : "")
            }
        }
        
        i = 0
        for (j, cab) in ULKcabinets.enumerated() {
            if (i + 1) % numberOfCabinetsInLine == 0 {
                if j != ULKcabinets.count - 1 && cab[String.Index(encodedOffset: 0)] != ULKcabinets[j+1][String.Index(encodedOffset: 0)] {
                    ULKcabinetsFullString += "\(cab);\n"
                    i = 0
                    ULKLines += 1
                } else if j != ULKcabinets.count - 1 {
                    ULKcabinetsFullString += "\(cab),\n"
                    ULKLines += 1
                    i = 0
                } else {
                    ULKcabinetsFullString += "\(cab)"
                }
            } else if j != ULKcabinets.count - 1 && cab[String.Index(encodedOffset: 0)] != ULKcabinets[j+1][String.Index(encodedOffset: 0)] {
                ULKcabinetsFullString += "\(cab);\n"
                i = 0
                ULKLines += 1
            } else {
                i += 1
                ULKcabinetsFullString += "\(cab)" + ((j != ULKcabinets.count - 1) ? ", " : "")
            }
        }
        
        fullCellSz = 45 + (GZLines + ULKLines) * 21
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
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
        
        
        [timeText, GZText, ULKText, GZListText, ULKListText].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin
            .horizontally(22)
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
            .right(21)
            .height(30)
            .width(35)
            .sizeToFit(.width)
        
        ULKText.pin
            .top(dor2FullPos)
            .right(21)
            .height(30)
            .width(35)
            .sizeToFit(.width)
        
        GZListText.pin
            .top(15)
            .left(155)
            .height(60)
            .width(ListWidth)
            .sizeToFit(.width)
        
        ULKListText.pin
            .top(ULKListFullPos)
            .left(155)
            .height(60)
            .width(ListWidth)
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
            .top(dor2FullPos)
            .left(110)
            .height(25)
            .width(25)
    }
    
    func loadCabinets(Cabinets CabinetsForCell: [String]) {
        ULKcabinets = []
        GZcabinets = []
//        if ULKcabinets.count != 0 {
//
//        }
            for cab in CabinetsForCell {
                if cab.contains("л") {
                    ULKcabinets.append(cab)
                } else {
                    GZcabinets.append(cab)
                }
            }
//            if wasConfiguredFlag == 0 {
//            } else {
//                wasConfiguredFlag = 0
//            }
            initCabinetsFields()
//        }
    }
    
    func config(with indexCell: Int) {
        
        wasConfiguredFlag = 1
        dor2FullPos = 45
        ULKListFullPos = 47
        
        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35", "13:50\n15:25", "15:40\n17:15", "17:25\n19:00", "19:10\n20:45"]
        
        let timee: String
//        let gzString: String = ""
//        let ulkString: String = ""
        
        timee = studyTimes[indexCell]
        
        GZText.text = "ГЗ"
        ULKText.text = "УЛК"
        timeText.text = timee
        
        GZListText.text = GZcabinetsShortString
        ULKListText.text = ULKcabinetsShortString
//        print(ULKListText.frame.height)

    }
    
    func config2(with indexCell: Int) {
        
        let ulkStrings = ULKcabinetsFullString.split(separator: "\n").count
        let gzStrings = GZcabinetsFullString.split(separator: "\n").count
        
//        for cab in CabinetsForCell {
//            if cab.contains("л") {
//                ULKcabinets.append(cab)
//            } else {
//                GZcabinets.append(cab)
//            }
//        }
        
//        initCabinetsFields()
        
        dor2FullPos += CGFloat((gzStrings-1) * 21)
        ULKListFullPos += CGFloat((gzStrings-1) * 21)
//        dor2FullPos.top = GZListText.frame.height
//        ULKListFullPos.top += ULKListText.frame.height
        
        GZListText.numberOfLines = gzStrings
        ULKListText.numberOfLines = ulkStrings
        
        GZListText.text = GZcabinetsFullString
        ULKListText.text = ULKcabinetsFullString

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
