import UIKit
import PinLayout
//import SwiftUI

class PairsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let houseImg = UIImageView(image: UIImage(named: "house"))
    private let magnifierImg = UIImageView(image: UIImage(named: "magnifier"))
//    private let weekSwitcher = UIPickerView()
//    private let viewForSwitcher = UIView()
    private let weeks = (1...17).map {"\($0) неделя - \(["знаменатель", " числитель"][$0%2])" }
    private var myCells: [PairTableViewCell] = []
    
    private let weakButton = UIButton()
    private var cellForReloadInd = -1
    
    private var firstScreenButton = UIButton()
    private var secondScreenButton = UIButton()
    
    var daysOfWeakButton: [Int:UIButton] = [:]
    
    private var muxosranskCount = 6
    private let margins = CGFloat(22)
    private let screenWidth = UIScreen.main.bounds.width
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        view.addSubview(tableView)
        view.addSubview(weakButton)
        view.addSubview(firstScreenButton)
        view.addSubview(secondScreenButton)
        view.addSubview(houseImg)
        view.addSubview(magnifierImg)
        
        weakButton.backgroundColor = UIColor(rgb: 0xC4C4C4)
        weakButton.layer.cornerRadius = 10
        weakButton.layer.masksToBounds = true
        weakButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        weakButton.setTitleColor = UIColor(rgb: 0x000000)
        weakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
        
//        weakButton.titleLabel?.textColor = .black
        weakButton.setTitle("11 неделя - числитель", for: .normal)
        weakButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
//        weakButton.frame = .init(x: 15, y: 75, width: view.frame.width / 2, height: 35)
        
        
        createDayButtons()
        screenSelection()
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PairTableViewCell.self, forCellReuseIdentifier: "PairTableViewCell")
//        tableView.register(BigPairTableViewCell.self, forCellReuseIdentifier: "BigPairTableViewCell")

        //связать кастоиную ячейку с таблицей (если nib-ом)
//        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")
        //связать кастоиную ячейку с таблицей (если кодом)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
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
        
        secondScreenButton.backgroundColor = UIColor(rgb: 0xC2A894)
        secondScreenButton.layer.cornerRadius = 10
        secondScreenButton.layer.masksToBounds = true
        secondScreenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        secondScreenButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
    
        secondScreenButton.addTarget(self, action: #selector(goToFilterScreen), for: .touchUpInside)
        
//        layoutScreenButtonsSubviews(buttonSubView: firstScreenButton, iconNameOfButton: "house")
//        layoutScreenButtonsSubviews(buttonSubView: secondScreenButton, iconNameOfButton: "magnifier")
    }
    
    @objc
    func goToFilterScreen() {
        let secondViewController:FilterViewController = FilterViewController()
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
//    private func layoutScreenButtonsSubviews(buttonSubView: UIButton, iconNameOfButton: String) {
//        let imageViewButton = UIImageView(image: UIImage(named: iconNameOfButton))
//
//        buttonSubView.addSubview(imageViewButton)
//        buttonSubView.bringSubviewToFront(imageViewButton)
//
////        buttonSubView.layoutSubviews()
//
////        imageViewButton.pin
////            .vCenter()
////            .left(buttonSubView.frame.width / 2 - 17)
////            .height(35)
////            .width(35)
//        imageViewButton.pin
//            .center()
////            .left(50)
//            .height(35)
//            .width(35)
//    }
    
    private func createDayButtons() {
        let dayOfWeak = ["Пн\n18", "Вт\n19", "Ср\n20", "Чт\n21", "Пт\n22", "Сб\n23"]
//        var x = 15
//        let sizeOfButton = (UIScreen.main.bounds.width - (16*5 + 30)) / 6
        let sizeOfButton = 55
        var x = Int(margins)
        let sizeOfSeparator = (Int(UIScreen.main.bounds.width) - sizeOfButton*6 - x*2)/5
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(rgb: 0x785A43)
        
        for indexOfDay in 0...5 {
            let dayOfWeakButton = UIButton(type: .system)
            dayOfWeakButton.frame = CGRect(x: 15, y: 120, width: view.frame.width / 7, height: view.frame.width / 7)
            
            dayOfWeakButton.backgroundColor = UIColor(rgb: 0xC2A894)
            dayOfWeakButton.layer.cornerRadius = 16
            dayOfWeakButton.layer.masksToBounds = true
            dayOfWeakButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            dayOfWeakButton.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
            dayOfWeakButton.titleLabel?.numberOfLines = 2
            dayOfWeakButton.titleLabel?.textAlignment = .center

            dayOfWeakButton.setTitle(dayOfWeak[indexOfDay], for: .normal)
            dayOfWeakButton.addTarget(self, action: #selector(changeButtonColor(_ :)), for: .touchUpInside)
            
            dayOfWeakButton.pin
                .top(130)
                .left(CGFloat(x))
                .width(CGFloat(sizeOfButton))
                .height(CGFloat(sizeOfButton))
            
//            dayOfWeakButton.frame = .init(x: CGFloat(x), y: 130, width: sizeOfButton, height: sizeOfButton)
            
            
            
            view.addSubview(dayOfWeakButton)

            
            daysOfWeakButton[indexOfDay] = dayOfWeakButton
            
            x += Int(sizeOfButton) + sizeOfSeparator
        }
    }
    
    @objc
    func changeButtonColor(_ buttonSubView: UIButton) {
        myCells = []
        cellForReloadInd = -1
        tableView.reloadData()
        if buttonSubView.backgroundColor == UIColor(rgb: 0xC2A894) {
            for indexOfDay in 0...5 {
                daysOfWeakButton[indexOfDay]?.backgroundColor = UIColor(rgb: 0xC2A894)
            }
            
            buttonSubView.backgroundColor = UIColor(rgb: 0xEA7500)
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
        
        
        weakButton.pin
            .top(75)
            .height(CGFloat(35))
            .left(margins)
            .width(CGFloat(view.frame.width / 2))
        
        let ButtonsWidth = CGFloat(Float(Int(screenWidth) / 2) - 1.5*Float(margins))
        firstScreenButton.pin
            .top(CGFloat(view.frame.height - 95))
            .height(45)
            .left(margins)
            .width(ButtonsWidth)
        
        secondScreenButton.pin
            .top(CGFloat(view.frame.height - 95))
            .height(45)
            .right(margins)
            .width(ButtonsWidth)
        
        houseImg.pin
            .top(CGFloat(view.frame.height - 90))
            .left(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
        magnifierImg.pin
            .top(CGFloat(view.frame.height - 90))
            .right(ButtonsWidth/2 + margins - 35/2)
            .height(35)
            .width(35)
        
//        firstScreenButton.frame = .init(x: 20, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
        
//        secondScreenButton.frame = .init(x: view.frame.width / 2 + 15, y: view.frame.height - 95, width: view.frame.width / 2 - 30, height: 45)
//        weakButton.frame = .init(x: 15, y: 75, width: view.frame.width / 2, height: 35)
        
//        viewForSwitcher.pin
//            .height(200)
//            .bottom(0)
//            .left(0)
//            .right(0)
//            .sizeToFit(.height)
////            .horizontally(0)
////            .vertically(200)
//
//        weekSwitcher.pin
//            .width(200)
//            .bottom(0)
//            .left(0)
//            .right(0)
//            .sizeToFit(.width)
        
        
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
        print("tapped week B")
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        cell?.config(with: indexPath.row)
        myCells.append(cell ?? .init())
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (muxosranskCount + 1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

//extension PairsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        weeks.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
////        weeks[row]
//        "\(row)"
//    }
//}
