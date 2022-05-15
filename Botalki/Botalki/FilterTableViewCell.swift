import Foundation
import UIKit
import PinLayout

final class FilterTableViewCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let pairLabel = UILabel()
    private let GZLabel = UILabel()
    private let cabinetLabel = UILabel()

    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDoor = UIImageView(image: UIImage(named: "door.png"))
    private let imageViewCalendarClock = UIImageView(image: UIImage(named: "calendarClock.png"))
    private let imageViewUniver = UIImageView(image: UIImage(named: "univer.png"))
    
    private let studyTimesStart = ["8:30\n", "10:15\n", "12:00\n", "13:50\n", "15:40\n", "17:25\n", "19:10\n"]
    private let studyTimesEnd = ["10:05", "11:50", "13:35", "15:25", "17:15", "19:00", "20:45"]
    
//    private let GZcabinets = ["240", "333ю", "426", "232", "327.1", "430", "384", "323", "427ю", "502ю", "522", "514", "504", "425ю", "390", "432", "420", "419ю", "386", "429ю", "505", "304", "424", "526", "228"]
    
    private let containerView = UIView()
    
//    private var pairStartInd = 0
//    private var pairEndInd = 0
//    private var building = ["ГЗ", "УЛК"]
//    private var cabinet = ""
    
    
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
    
    private func setup() {
        containerView.addSubview(imageViewClock)
        containerView.bringSubviewToFront(imageViewClock)
        
        containerView.addSubview(imageViewCalendarClock)
        containerView.bringSubviewToFront(imageViewCalendarClock)
        
        containerView.addSubview(imageViewDoor)
        containerView.bringSubviewToFront(imageViewDoor)
        
        containerView.addSubview(imageViewUniver)
        containerView.bringSubviewToFront(imageViewUniver)
        
        selectionStyle = .none
        
        timeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        timeLabel.textColor = .black
        timeLabel.numberOfLines = 2
        timeLabel.textAlignment = .right
        
        pairLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        pairLabel.textColor = .black
        pairLabel.numberOfLines = 2
        pairLabel.textAlignment = .right
        
        GZLabel.font = .systemFont(ofSize: 14, weight: .bold)
        GZLabel.textColor = .black
        GZLabel.numberOfLines = 1
        GZLabel.textAlignment = .left
        
        cabinetLabel.font = .systemFont(ofSize: 14, weight: .bold)
        cabinetLabel.textColor = .black
        cabinetLabel.numberOfLines = 1
        cabinetLabel.textAlignment = .left
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 0.5
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 10
        
//        containerView.backgroundColor = UIColor(rgb: 0xC2A894)
        
        
        [timeLabel, GZLabel, pairLabel, cabinetLabel].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin
            .horizontally(15)
            .vertically(6)
        
        
        imageViewClock.pin
            .top(17)
            .left(17)
            .height(20)
            .width(20)
        
        timeLabel.pin
            .top(8)
            .left(48)
            .height(40)
            .width(40)
            .sizeToFit(.height)
        
        
        imageViewCalendarClock.pin
            .top(17)
            .left(117)
            .height(23)
            .width(23)
        
        pairLabel.pin
            .top(8)
            .left(150)
            .height(40)
            .width(40)
            .sizeToFit(.height)
        
        
        imageViewUniver.pin
            .top(14)
            .left(205)
            .height(25)
            .width(25)
        
        GZLabel.pin
            .top(18)
            .left(235)
            .height(30)
            .width(35)
            .sizeToFit(.width)
        

        imageViewDoor.pin
            .top(14)
            .right(65)
            .height(25)
            .width(25)
        
        cabinetLabel.pin
            .top(14)
            .right(5)
            .height(25)
            .width(55)
    }
    
    func config(pairStartInd: Int, pairEndInd: Int, buildingInd: Int, cabinet: String, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let cellDate = formatter.date(from: "\(Calendar.current.component(.year, from: date))/\(Calendar.current.component(.month, from: date))/\(Calendar.current.component(.day, from: date)) \(studyTimesEnd[pairEndInd])")!
        let userDate = Date()
        
        if cellDate > userDate {
            containerView.backgroundColor = UIColor(rgb: 0xC2A894)
        } else {
            containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
        }
        
        timeLabel.text = studyTimesStart[pairStartInd] + studyTimesEnd[pairEndInd]
        cabinetLabel.text = cabinet
        
        pairLabel.text = pairStartInd != pairEndInd ? "\(pairStartInd + 1)-я\n\(pairEndInd + 1)-я" : "\(pairStartInd + 1)-я"
        GZLabel.text = ["ГЗ", "УЛК"][buildingInd]
    }
}

