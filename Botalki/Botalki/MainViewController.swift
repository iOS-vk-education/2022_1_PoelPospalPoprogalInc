import UIKit
import PinLayout
//import SwiftUI

class PairsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var myCells: [PairTableViewCell] = []
    
    private let weakButton = UIButton()
    private var cellForReloadInd = -1
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    var daysOfWeakButton: [Int:UIButton] = [:]
    
    private var muxosranskCount = 6
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtosnItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
//        typealias ConfigurationUpdateHandler = (UIButton) -> Void
        
        
        view.addSubview(tableView)
        view.addSubview(weakButton)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        
        weakButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weakButton.layer.cornerRadius = 10
        weakButton.layer.masksToBounds = true
        weakButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        weakButton.setTitleColor = UIColor(rgb: 0x000000)
        weakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
        
//        weakButton.titleLabel?.textColor = .black
        weakButton.setTitle("11 неделя - числитель", for: .normal)
        weakButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        weakButton.frame = .init(x: 15, y: 75, width: view.frame.width / 2, height: 35)
        
        
        createDayButtons()
        screenSelection()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(.init(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell")
//        tableView.register(BigPairTableViewCell.self, forCellReuseIdentifier: "BigPairTableViewCell")

        //связать кастоиную ячейку с таблицей (если nib-ом)
//        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")
        //связать кастоиную ячейку с таблицей (если кодом)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
//        title = "Test xib table"
        
        //в loadData completion не нужен, потому что не важно знать когда закончилась функция
        loadData()
    }
    
    
    private func screenSelection() {
        firstScreenButton.backgroundColor = UIColor(rgb: 0x785A43)
        firstScreenButton.layer.cornerRadius = 10
        firstScreenButton.layer.masksToBounds = true
        firstScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        firstScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        firstScreenButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        firstScreenButton.frame = .init(x: 20, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        secondScreenButton.addTarget(self, action: #selector(goToFilterScreen), for: .touchUpInside)
        secondScreenButton.frame = .init(x: view.frame.width / 2 + 15, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
        layoutScreenButtonsSubviews(buttonSubView: firstScreenButton, iconNameOfButton: "house")
        layoutScreenButtonsSubviews(buttonSubView: secondScreenButton, iconNameOfButton: "magnifier")
    }
    
    @objc
    func goToFilterScreen() {
        let secondViewController:FilterViewController = FilterViewController()
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
    private func layoutScreenButtonsSubviews(buttonSubView: UIButton, iconNameOfButton: String) {
        let imageViewButton = UIImageView(image: UIImage(named: iconNameOfButton))
        
        buttonSubView.addSubview(imageViewButton)
        buttonSubView.bringSubviewToFront(imageViewButton)
        
        buttonSubView.layoutSubviews()
        
        imageViewButton.pin
            .vCenter()
            .left(buttonSubView.frame.width / 2 - 17)
            .height(35)
            .width(35)
    }
    
    private func createDayButtons() {
        let dayOfWeak = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
        var x = 15
        let sizeOfButton = view.frame.width / 8
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(rgb: 0x785A43)
        
        for indexOfDay in 0...5 {
            let dayOfWeakButton = UIButton(type: .system)
            dayOfWeakButton.frame = CGRect(x: 15, y: 120, width: view.frame.width / 7, height: view.frame.width / 7)
            
            dayOfWeakButton.backgroundColor = UIColor.systemGroupedBackground
            dayOfWeakButton.layer.cornerRadius = 16
            dayOfWeakButton.layer.masksToBounds = true
            dayOfWeakButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//            dayOfWeakButton.setTitleColor(UIColor.systemBackground, for: .normal)
            dayOfWeakButton.layer.borderWidth = 2
            dayOfWeakButton.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor

//            dayOfWeakButton.setTitle(dayOfWeak[indexOfDay], for: .normal)
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
            dayLabel.numberOfLines = 1
            dayLabel.textAlignment = .right
            dayLabel.text = dayOfWeak[indexOfDay]
            
            dayOfWeakButton.addSubview(dayLabel)
            dayOfWeakButton.bringSubviewToFront(dayLabel)
            dayOfWeakButton.layoutSubviews()
            
            dayLabel.pin
                .top(17)
                .left(3)
                .height(20)
                .width(35)
            
            dayOfWeakButton.frame = .init(x: CGFloat(x), y: 130, width: sizeOfButton, height: sizeOfButton)
            
            view.addSubview(dayOfWeakButton)
            daysOfWeakButton[indexOfDay] = dayOfWeakButton
            
            x += Int(sizeOfButton) + 16
        }
    }
    
    @objc
    func changeButtonColor(_ buttonSubView: UIButton) {
        tableView.reloadData()
        if buttonSubView.backgroundColor == .systemGroupedBackground {
            for indexOfDay in 0...5 {
                daysOfWeakButton[indexOfDay]?.backgroundColor = .systemGroupedBackground
                daysOfWeakButton[indexOfDay]?.layer.borderColor = UIColor(rgb: 0xC2A894).cgColor
            }
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
            buttonSubView.layer.borderColor = UIColor(rgb: 0xEA7500).cgColor
            
        }
        
//        print(daysOfWeakButton[buttonSubView]!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin
            .top(200)
            .bottom(130)
            .left(0)
            .right(0)
//            .horizontally(0)
//            .vertically(200)
        
        
        // не работает ааааа
//        for i in 0...5 {
//            daysOfWeakButton[i]?.pin
//                .top(50)
//                .left(30)
////                .bottom(130)
//                .width(30)
//                .height(30)
//        }
    }
    
    
    
    
    //тут completion нужен чтобы знать когда остановить анимацию
    private func loadData(compl: (() -> Void)? = nil) {
        tableView.reloadData()
//        NetworkManager.shared.loadCities { [weak self] cities in
//            self?.cities = cities
//            self?.tableView.reloadData()
//            compl?()
//        }
        compl?()
    }
    
    @objc
    private func didPullToRefresh() {
        loadData { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    
    @objc
    private func didTapAddButton() {
//        cities.append(City(title: "Мухосранск \(muxosranskCount)", temperature: "-\(Int.random(in: 30...150)) °C", timeDelta: Int.random(in: 1...10)))
//        tableView.reloadData()
        muxosranskCount += 1
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: muxosranskCount, section: 0)], with: .automatic)
        tableView.endUpdates()
        
    }

//    @objc
    @objc private func open() {
        let viewController = CityViewController()
//        let viewController = UIViewController()
//        viewController.title = city.title
//        viewController.view.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == cellForReloadInd {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BigPairTableViewCell", for: indexPath) as? BigPairTableViewCell
//            cell?.config(with: indexPath.row)
//            return cell ?? .init()
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
//            cell?.config(with: indexPath.row)
//            return cell ?? .init()
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        cell?.config(with: indexPath.row)
        myCells.append(cell ?? .init())
        return cell ?? .init()

        
//        cell?.config(with: indexPath.row)

//        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (muxosranskCount + 1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        let city = cities[indexPath.row]
//        open()
        print("touched \(indexPath.row)")
        if indexPath.row != cellForReloadInd {
            if cellForReloadInd != -1 {
                myCells[cellForReloadInd].config(with: cellForReloadInd)
            }
            
            cellForReloadInd = indexPath.row
            tableView.beginUpdates()
            myCells[indexPath.row].config2(with: indexPath.row)
            tableView.endUpdates()
        }
        else {
            cellForReloadInd = -1
            tableView.beginUpdates()
            myCells[indexPath.row].config(with: indexPath.row)
            tableView.endUpdates()
        }
//        tableView.reloadData()
//        tableView.beginUpdates()
//        myCells[indexPath.row].config2(with: indexPath.row)
//        tableView.endUpdates()
//        tableView.performBatchUpdates() {
//            tableView.reloadRows(at: [indexPath], with: BigPairTableViewCell.self)
//        }
//        print("Tap on cell")
    }
//
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cellForReloadInd {
            return CGFloat(myCells[indexPath.row].fullCellSz)
        }
        else {
            return 95
        }
    }
}
