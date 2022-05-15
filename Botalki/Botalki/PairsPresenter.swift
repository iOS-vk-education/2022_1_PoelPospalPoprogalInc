//
//  PairsPresenter.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation

final class PairsPresenter {
    private let model = PairsModel()
    weak var viewController: PairsViewController?
    var cabinetsStringFromFile: String = ""
    var semesterStartFromFile: String = ""
    
    var myCells: [PairTableViewCell?] {
        return model.myCells
    }
    
    cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
    semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
    
    if self.cabinetsStringFromFile == "" || self.semesterStartFromFile == "" {
        loadAndParseCabinetsFileFromFirebase {
            self.initCellsAndloadTableData()
        }
        loadAndSetCurWeekFromFirebase {
            self.setCurWeekDate()
            self.reloadTableData()
        }
    } else {
        self.initCellsAndloadTableData()
        self.setCurWeekDate()
        self.reloadTableData()
    }
}
