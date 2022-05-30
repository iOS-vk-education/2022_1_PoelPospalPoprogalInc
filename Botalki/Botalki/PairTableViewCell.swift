import Foundation
import UIKit
import PinLayout


final class PairTableViewCell: UITableViewCell {
    
    private let timeText = UILabel()
    private let GZText = UILabel()
    private let ULKText = UILabel()
    private let GZListText = UILabel()
    private let ULKListText = UILabel()
    
    private var dor2FullPos = CGFloat(45)
    private var ULKListFullPos = CGFloat(47)
    private var ListWidth = CGFloat(UIScreen.main.bounds.width - 220)
    
    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDor = UIImageView(image: UIImage(named: "door.png"))
    private var imageViewDor2 = UIImageView(image: UIImage(named: "door.png"))
    
    private let containerView = UIView()
    
    var GZcabinets: [String] = []
    var ULKcabinets: [String] = []
    private var GZcabinetsShortString: String = ""
    private var ULKcabinetsShortString: String = ""
    private var GZcabinetsFullString: String = ""
    private var ULKcabinetsFullString: String = ""
    private var numberOfCabinetsInLine: Int = 0
    var fullCellSz: Int = 95
    var wasConfiguredFlag = 0
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin
            .horizontally(22)
            .vertically(6)
        
        timeText.pin
            .top(11)
            .left(52)
            .height(60)
            .width(60)
            .sizeToFit(.height)
        
        GZText.pin
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
            .top(28)
            .left(15)
            .height(25)
            .width(25)
        
        imageViewDor.pin
            .top(11)
            .left(110)
            .height(25)
            .width(25)
        
        imageViewDor2.pin
            .top(dor2FullPos)
            .left(110)
            .height(25)
            .width(25)
    }
    
    private func setup() {
        containerView.addSubview(imageViewClock)
        containerView.bringSubviewToFront(imageViewClock)
        
        containerView.addSubview(imageViewDor)
        containerView.bringSubviewToFront(imageViewDor)
        
        containerView.addSubview(imageViewDor2)
        containerView.bringSubviewToFront(imageViewDor2)
        
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
    
    private func initCabinetsFields() {
        GZcabinetsShortString = ""
        ULKcabinetsShortString = ""
        GZcabinetsFullString = ""
        ULKcabinetsFullString = ""
        
        numberOfCabinetsInLine = Int((UIScreen.main.bounds.width - 220)/48) - 1
        
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
                if j != GZcabinets.count - 1 && cab[0] != GZcabinets[j+1][0] {
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
            } else if j != GZcabinets.count - 1 && cab[0] != GZcabinets[j+1][0] {
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
                if j != ULKcabinets.count - 1 && cab[0] != ULKcabinets[j+1][0] {
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
            } else if j != ULKcabinets.count - 1 && cab[0] != ULKcabinets[j+1][0] {
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
    
    func loadCabinets(Cabinets CabinetsForCell: [String]) {
        ULKcabinets = []
        GZcabinets = []
        
        for cab in CabinetsForCell {
            if cab.contains("л") {
                ULKcabinets.append(cab)
            } else {
                GZcabinets.append(cab)
            }
        }
    
        initCabinetsFields()
    }
    
    func config(with indexCell: Int) {
        wasConfiguredFlag = 1
        dor2FullPos = 45
        ULKListFullPos = 47
        
        let studyTimes = ["8:30\n10:05", "10:15\n11:50", "12:00\n13:35", "13:50\n15:25", "15:40\n17:15", "17:25\n19:00", "19:10\n20:45"]
        
        let timee: String
        
        timee = studyTimes[indexCell]
        
        GZText.text = "ГЗ"
        ULKText.text = "УЛК"
        timeText.text = timee
        
        GZListText.text = GZcabinetsShortString
        ULKListText.text = ULKcabinetsShortString
    }
    
    func config2(with indexCell: Int) {
        let ulkStrings = ULKcabinetsFullString.split(separator: "\n").count
        let gzStrings = GZcabinetsFullString.split(separator: "\n").count
        
        dor2FullPos += CGFloat((gzStrings-1) * 21)
        ULKListFullPos += CGFloat((gzStrings-1) * 21)
        
        GZListText.numberOfLines = gzStrings
        ULKListText.numberOfLines = ulkStrings
        
        GZListText.text = GZcabinetsFullString
        ULKListText.text = ULKcabinetsFullString

    }
}

extension String {
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func strip(by str: String) -> String {
        let cs = CharacterSet.init(charactersIn: str)
        return self.trimmingCharacters(in: cs)
    }
}
