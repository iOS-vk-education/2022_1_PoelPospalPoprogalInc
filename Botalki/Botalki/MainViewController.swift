import UIKit
import SwiftUI

class PairsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let weakButton = UIButton()
    
    private var muxosranskCount = 6
    
//    private var cities: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
        view.addSubview(tableView)
        view.addSubview(weakButton)
        
        weakButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weakButton.layer.cornerRadius = 16
        weakButton.layer.masksToBounds = true
        weakButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        weakButton.setTitleColor = UIColor(rgb: 0x000000)
        weakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
        
//        weakButton.titleLabel?.textColor = .black
        weakButton.setTitle("9 неделя - числитель", for: .normal)
        weakButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        weakButton.frame = .init(x: 15, y: 75, width: view.frame.width / 2, height: 35)
        
//        tableView.frame = view.bounds
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(.init(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin
            .top(200)
            .bottom(130)
            .left(0)
            .right(0)
//            .horizontally(0)
//            .vertically(200)
    }
    
    
    //тут completion нужен чтобы знать когда остановить анимацию
    private func loadData(compl: (() -> Void)? = nil) {
        tableView.reloadData()
//        NetworkManager.shared.loadCities { [weak self] cities in
//            self?.cities = cities
//            self?.tableView.reloadData()
//            compl?()
//        }
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

//    private func open(city: City) {
//        let viewController = CityViewController(city: city)
////        let viewController = UIViewController()
////        viewController.title = city.title
////        viewController.view.backgroundColor = .systemBackground
//        let navigationController = UINavigationController(rootViewController: viewController)
//        present(navigationController, animated: true, completion: nil)
//    }
}

extension PairsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? PairTableViewCell
        
        cell?.config(with: indexPath.row)

        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (muxosranskCount + 1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let city = cities[indexPath.row]
//        open(city: city)
        print("Tap on cell")
    }
//
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}