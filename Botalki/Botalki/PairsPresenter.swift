//
//  PairsPresenter.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation

final class PairsPresenter {
    private let model = PairsModel()
    weak var mainViewController: PairsViewController?
    weak var secondViewController: FilterViewController?
    
    var myCells: [PairTableViewCell?] {
        return model.myCells
    }
    
    var curWeek: Int {
        return model.curWeek
    }
    
    var semStartDate: Date {
        return model.semStartDate
    }
    
    var FreeCabinets: [[[[String]]]] {
        return model.FreeCabinets
    }
    
    func didLoadView(completion: @escaping ((Result<Any, Error>) -> Void)) {
        model.cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
        model.semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
        
        if model.cabinetsStringFromFile == "" || model.semesterStartFromFile == "" {
            loadAllData { result in
                switch result {
                case .success(_):
                    self.model.calculateCurWeek()
                    self.initCells()
                    completion(.success((Any).self))
                    break
                    
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        } else {
            model.parseCabinetsFile()
            self.model.calculateCurWeek()
            self.initCells()
            completion(.success((Any).self))
        }
        
        
    }
    
    func loadAllData(completion: @escaping ((Result<Any, Error>) -> Void)) {
        model.loadAndParseCabinetsFileFromFirebase { result in
            switch result {
            case .success(_):
                self.model.loadAndSetCurWeekFromFirebase { result in
                    switch result {
                    case .success(_):
                        self.model.parseCabinetsFile()
                        completion(.success((Any).self))
                        break
                        
                    case .failure(let error):
                        completion(.failure(error))
                        break
                    }
                }
                break
                
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    

    private func initCells() {
        
        var indexPath: IndexPath = IndexPath(row: 0, section: 0)
        for i in 0...6 {
            indexPath.row = i
            indexPath.section = 0
            model.myCells[i] = mainViewController!.tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
        }
    }
    
    func unconfigCells() {
        model.myCells.forEach {$0?.wasConfiguredFlag = 0}
    }
    
    func didLoadSecondController() {
        secondViewController!.FreeCabinets = FreeCabinets
    }
    
}
