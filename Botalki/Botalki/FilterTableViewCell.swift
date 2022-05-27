import Foundation
import UIKit
import PinLayout

final class FilterTableViewCell: UITableViewCell {
    weak var sortedController: SortedViewController?
    
    private let timeLabel = UILabel()
    private let pairLabel = UILabel()
    private let buildingLabel = UILabel()
    private let cabinetLabel = UILabel()

    private let imageViewClock = UIImageView(image: UIImage(named: "clock.png"))
    private let imageViewDoor = UIImageView(image: UIImage(named: "door.png"))
    private let imageViewCalendarClock = UIImageView(image: UIImage(named: "calendarClock.png"))
    private let imageViewUniver = UIImageView(image: UIImage(named: "univer.png"))
    
    private let studyTimesStart = ["8:30\n", "10:15\n", "12:00\n", "13:50\n", "15:40\n", "17:25\n", "19:10\n"]
    private let studyTimesEnd = ["10:05", "11:50", "13:35", "15:25", "17:15", "19:00", "20:45"]
    
    private let containerView = UIView()
    
    var pairStartInd: Int = 0
    var pairEndInd: Int = 0
    var buildingInd: Int = 0
    var cabinet: String = ""
    
    private var screenWidth = UIScreen.main.bounds.width
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print(screenWidth)
        setup()
    }
    
    @objc
    private func didTapOnTime(_ sender: UITapGestureRecognizer) {
        sortedController!.sortCellsArrayByTime()
    }
    
    @objc
    private func didTapOnBuilding(_ sender: UITapGestureRecognizer) {
        sortedController!.sortCellsArrayByBuilding()
    }
    
    @objc
    private func didTapOnAudience(_ sender: UITapGestureRecognizer) {
        sortedController!.sortCellsArrayByAudience()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        screenWidth = sortedController!.view.frame.width
        
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
            .left(screenWidth/4 + 10)
            .height(23)
            .width(23)
        
        pairLabel.pin
            .top(8)
            .after(of: imageViewCalendarClock)
            .marginHorizontal(5)
            .height(40)
            .width(40)
            .sizeToFit(.height)
        
        imageViewUniver.pin
            .top(14)
            .left(screenWidth/2 - (screenWidth > 400 && screenWidth < 500 ? (428 - screenWidth) : 15))
            .height(25)
            .width(25)
        
        buildingLabel.pin
            .top(18)
            .after(of: imageViewUniver)
            .height(30)
            .width(35)
            .sizeToFit(.width)

        imageViewDoor.pin
            .top(14)
            .right(65 - CGFloat(screenWidth < 380 ? 5 : 0))
            .height(25)
            .width(25)
        
        cabinetLabel.pin
            .top(14)
            .right(5 - CGFloat(screenWidth < 380 ? 3 : 0))
            .height(25)
            .width(55)
    }
    
    private func setup() {
        let tapOnTimeLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime))
        let tapOnPairLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime))
        let tapOnClockViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime))
        let tapOnCalendarClockViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime))
        
        let tapOnBuildingLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnBuilding))
        let tapOnBuildingViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnBuilding))
        
        let tapOnAudienceLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAudience))
        let tapOnAudienceViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAudience))
        
        timeLabel.isUserInteractionEnabled = true
        pairLabel.isUserInteractionEnabled = true
        imageViewClock.isUserInteractionEnabled = true
        imageViewCalendarClock.isUserInteractionEnabled = true
        timeLabel.addGestureRecognizer(tapOnTimeLabelGesture)
        pairLabel.addGestureRecognizer(tapOnPairLabelGesture)
        imageViewClock.addGestureRecognizer(tapOnClockViewGesture)
        imageViewCalendarClock.addGestureRecognizer(tapOnCalendarClockViewGesture)
        
        buildingLabel.isUserInteractionEnabled = true
        imageViewUniver.isUserInteractionEnabled = true
        buildingLabel.addGestureRecognizer(tapOnBuildingLabelGesture)
        imageViewUniver.addGestureRecognizer(tapOnBuildingViewGesture)
        
        cabinetLabel.isUserInteractionEnabled = true
        imageViewDoor.isUserInteractionEnabled = true
        cabinetLabel.addGestureRecognizer(tapOnAudienceLabelGesture)
        imageViewDoor.addGestureRecognizer(tapOnAudienceViewGesture)
        
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
        
        buildingLabel.font = .systemFont(ofSize: 14, weight: .bold)
        buildingLabel.textColor = .black
        buildingLabel.numberOfLines = 1
        buildingLabel.textAlignment = .left
        
        cabinetLabel.font = .systemFont(ofSize: 14, weight: .bold)
        cabinetLabel.textColor = .black
        cabinetLabel.numberOfLines = 1
        cabinetLabel.textAlignment = .left
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 0.5
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 10
        
        
        [timeLabel, buildingLabel, pairLabel, cabinetLabel].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    private func isCellDataActual(curDate: Date, pairEndInd: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let cellDate = formatter.date(from: "\(Calendar.current.component(.year, from: curDate))/\(Calendar.current.component(.month, from: curDate))/\(Calendar.current.component(.day, from: curDate)) \(studyTimesEnd[pairEndInd])")!
        let userDate = Date()
        
        if cellDate > userDate {
            return true
        } else {
            return false
        }
    }
    
    func config(pairStartInd: Int, pairEndInd: Int, buildingInd: Int, cabinet: String, date: Date) {
        self.pairStartInd = pairStartInd
        self.pairEndInd = pairEndInd
        self.buildingInd = buildingInd
        self.cabinet = cabinet
        
        if isCellDataActual(curDate: date, pairEndInd: pairEndInd) {
            containerView.backgroundColor = UIColor(rgb: 0xC2A894)
        } else {
            containerView.backgroundColor = UIColor(rgb: 0xC4C4C4)
        }
        
        timeLabel.text = studyTimesStart[pairStartInd] + studyTimesEnd[pairEndInd]
        cabinetLabel.text = cabinet
        
        pairLabel.text = pairStartInd != pairEndInd ? "\(pairStartInd + 1)-я\n\(pairEndInd + 1)-я" : "\(pairStartInd + 1)-я"
        buildingLabel.text = ["ГЗ", "УЛК"][buildingInd]
    }
}
