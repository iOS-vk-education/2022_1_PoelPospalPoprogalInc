import Foundation
import UIKit
import PinLayout

final class SortedViewController: UIViewController {
    
    private let tempLabel = UILabel()
    private let tableView = UITableView()
    private let imageDoor = UIImageView(image: UIImage(named: "doorWhite.png"))
    
    private var audCells: [FilterTableViewCell] = []
    private var cellForReloadInd = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        if self.traitCollection.userInterfaceStyle == .dark {
            imageDoor.setImageColor(color: UIColor.white)
        } else {
            imageDoor.setImageColor(color: UIColor.black)
        }
        
        view.addSubview(tableView)
        view.addSubview(tempLabel)
        view.addSubview(imageDoor)
        
        createDefaultDatas()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
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
    }
    
    private func createDefaultDatas() {
        tempLabel.text = "Вам подойдут:"
        tempLabel.font = .systemFont(ofSize: 28, weight: .bold)
    }
}


extension SortedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell
        cell?.config(with: indexPath.row)
        audCells.append(cell ?? .init())
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != cellForReloadInd {
            if cellForReloadInd != -1 {
                audCells[cellForReloadInd].config(with: cellForReloadInd)
            }
            
            cellForReloadInd = indexPath.row
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else {
            cellForReloadInd = -1
            tableView.beginUpdates()
            audCells[indexPath.row].config(with: indexPath.row)
            tableView.endUpdates()
        }
    }

    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
        }
}
