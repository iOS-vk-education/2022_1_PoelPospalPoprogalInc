import UIKit
import PinLayout
//import SwiftUI

class PairsViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let weakButton = UIButton()
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    private var daysOfWeakButton = [UIButton]()
    
    private var muxosranskCount = 6
    
//    private var cities: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtosnItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        typealias ConfigurationUpdateHandler = (UIButton) -> Void
        
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
    
        secondScreenButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        secondScreenButton.frame = .init(x: view.frame.width / 2 + 15, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
        layoutScreenButtonsSubviews(buttonSubView: firstScreenButton, iconNameOfButton: "house")
        layoutScreenButtonsSubviews(buttonSubView: secondScreenButton, iconNameOfButton: "magnifier")
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
//            var container = AttributeContainer()
//            container.underlineStyle = .single
            
//            var configuration = UIButton.Configuration.filled()
//            configuration.baseBackgroundColor = UIColor(rgb: 0x785A43)
//
//            let handler: UIButton.ConfigurationUpdateHandler = { button in
//                switch button.state {
//                case .disabled:
//                    button.configuration?.baseBackgroundColor = UIColor(rgb: 0xC2A894)
//                default:
//                    button.configuration?.baseBackgroundColor = UIColor(rgb: 0x785A43)
//                }
//            }
//
//            let button = UIButton(configuration: configuration, primaryAction: nil)
//            button.configurationUpdateHandler = handler
//
//            let selectedButton = UIButton(configuration: configuration, primaryAction: nil)
//            selectedButton.isTracking = false
//            selectedButton.configurationUpdateHandler = handler
//
//            let dayOfWeakButton = selectedButton
            let dayOfWeakButton = UIButton(type: .system)
            dayOfWeakButton.frame = CGRect(x: 15, y: 120, width: view.frame.width / 7, height: view.frame.width / 7)
        
            
            dayOfWeakButton.backgroundColor = UIColor(rgb: 0xC2A894)
            dayOfWeakButton.layer.cornerRadius = 16
            dayOfWeakButton.layer.masksToBounds = true
            dayOfWeakButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            dayOfWeakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)

            dayOfWeakButton.setTitle(dayOfWeak[indexOfDay], for: .normal)
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            dayOfWeakButton.frame = .init(x: CGFloat(x), y: 130, width: sizeOfButton, height: sizeOfButton)
            
            view.addSubview(dayOfWeakButton)
            daysOfWeakButton.append(dayOfWeakButton)
            
            x += Int(sizeOfButton) + 16
        }
    }
    
    @objc
    func changeButtonColor(_ buttonSubView: UIButton) {
        if buttonSubView.backgroundColor == UIColor(rgb: 0xC2A894) {
            buttonSubView.backgroundColor = UIColor(rgb: 0x785A43)
        }
        else {
            buttonSubView.backgroundColor = UIColor(rgb: 0xC2A894)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? PairTableViewCell
        
        cell?.config(with: indexPath.row)

        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (muxosranskCount + 1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
//        let city = cities[indexPath.row]
        open()
//        print("Tap on cell")
    }
//
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}
