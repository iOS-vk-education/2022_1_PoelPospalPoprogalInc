import Foundation
import UIKit
import PinLayout


final class SortedViewController: UIViewController {
    private let tempLabel = UILabel()
    private let tableView = UITableView()
    private let imageDoor = UIImageView(image: UIImage(named: "doorWhite.png"))
    private var curDate = Date()
    private var myCells = [FilterTableViewCell?]()
    
    private var cellData: [FilterCellData] = []
    private var numOfSections = 0
    
    init(cellData: [FilterCellData], date: Date) {
        super.init(nibName: nil, bundle: nil)
        self.numOfSections = cellData.count
        self.cellData = cellData
        self.curDate = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(tempLabel)
        view.addSubview(imageDoor)
        
        createDefaultDatas()
        
        tableView.frame = view.bounds
        tableView.layer.cornerRadius = 35
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        
        initCellsArray()
        sortCellsArrayByAudience()
        sortCellsArrayByTime()
        sortCellsArrayAvailability()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            imageDoor.setImageColor(color: UIColor.white)
        } else {
            imageDoor.setImageColor(color: UIColor.black)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        tempLabel.pin
            .top(60)
            .right(37)
            .sizeToFit()
        
        imageDoor.pin
            .top(50)
            .left(43)
            .height(45)
            .width(45)
        
        tableView.pin
            .top(120)
            .horizontally(13)
            .bottom(0)
    }
    
    private func initCellsArray() {
        var indexPath: IndexPath = IndexPath(row: 0, section: 0)
        for i in 0..<numOfSections {
            indexPath.row = i
            indexPath.section = 0
            myCells.append(tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell)
            
            myCells[i]?.config(pairStartInd: cellData[indexPath.row].pairStartInd, pairEndInd: cellData[indexPath.row].pairEndInd, buildingInd: cellData[indexPath.row].buildingInd, cabinet: cellData[indexPath.row].cabinet, date: curDate)
            
            myCells[i]?.sortedController = self
        }
    }
    
    func sortCellsArrayByTime() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        myCells.sort { $0!.pairStartInd < $1!.pairStartInd }
        tableView.reloadData()
    }
    
    func sortCellsArrayByBuilding() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        myCells.sort { $0!.buildingInd < $1!.buildingInd }
        tableView.reloadData()
    }
    
    func sortCellsArrayByAudience() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        myCells.sort { Double($0!.cabinet.strip(by: "лаю")) ?? 0 < Double($1!.cabinet.strip(by: "лаю")) ?? 0 }
        tableView.reloadData()
    }
    
    func sortCellsArrayAvailability() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        myCells.sort { $0!.isAvailable > $1!.isAvailable }
        tableView.reloadData()
    }
    
    private func createDefaultDatas() {
        tempLabel.text = "Вам подойдут:"
        tempLabel.font = .systemFont(ofSize: 28, weight: .bold)
    }
}


extension SortedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCells[indexPath.row]
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
    }
}
