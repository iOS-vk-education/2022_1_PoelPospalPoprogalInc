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
    
    private let studyTimes = ["8:30\n10:05", "13:50\n15:25", "15:40\n17:15",  "19:10\n20:45", "10:15\n11:50", "12:00\n13:35", "17:25\n19:00", "17:25\n19:00", "15:40\n17:15", "13:50\n15:25", "15:40\n17:15", "19:10\n20:45", "19:10\n20:45", "19:10\n20:45", "17:25\n19:00", "19:10\n20:45"]
    
    private let GZcabinets = ["240", "333ю", "426", "232", "327.1", "430", "384", "323", "427ю", "502ю", "522", "514", "504", "425ю", "390", "432", "420", "419ю", "386", "429ю", "505", "304", "424", "526", "228"]
    
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
        containerView.backgroundColor = UIColor(rgb: 0xC2A894)
        
        
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
            .right(20)
            .height(25)
            .width(40)
    }
    
    func config(with indexCell: Int) {
        
        timeLabel.text = studyTimes[indexCell]
        cabinetLabel.text = GZcabinets[indexCell]
        
        pairLabel.text = "1-я\n4-я"
        GZLabel.text = "ГЗ"
    }
}

