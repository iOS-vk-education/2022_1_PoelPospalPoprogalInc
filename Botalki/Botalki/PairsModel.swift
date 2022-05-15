//
//  PairsModel.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation

//enum NetworkError: Error {
//    case invalidUrl
//    case emptyData
//}

final class PairsModel {
    private let networkManager = NetworkManager.shared
    private let fileManager = MyFileManager.shared
    weak var presenter: PairsPresenter?
    private var semStartDate = Date()
    private var FreeCabinets = [[[[String]]]]()
    
    var myCells = [PairTableViewCell?]()
    
    func loadAndParseCabinetsFileFromFirebase(completion: @escaping ((Result<Any, Error>) -> Void)) {
        NetworkManager.shared.downloadFileFromFirebaseStorage(toFile: "cabinets.txt") { error in
            if error == nil {
                self.presenter?.cabinetsStringFromFile = MyFileManager.shared.getStringFromTextFile(with: "cabinets.txt") ?? ""
                
                if self.presenter?.cabinetsStringFromFile == "" {
                    print("Downloading file error...")
                    completion(.failure(error!))
//                    AlertManager.shared.showAlert(presentTo: self, title: "Downloading file cabinets.txt error...", message: "")
                } else {
                    self.parseCabinetsFile()
                }
                completion(.success((Any).self))
                
            } else {
                completion(.failure(error!))
//                AlertManager.shared.showAlert(presentTo: self, title: "Error", message: error?.localizedDescription)
//                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    func loadAndSetCurWeekFromFirebase(completion: @escaping (() -> Void)) {
        NetworkManager.shared.downloadFileFromFirebaseStorage(toFile: "uuids.txt") { error in
            if error == nil {
                self.presenter?.semesterStartFromFile = MyFileManager.shared.getStringFromTextFile(with: "uuids.txt") ?? ""
                
                if self.presenter?.semesterStartFromFile == "" {
                    print("Downloading file error...")
                    AlertManager.shared.showAlert(presentTo: self, title: "Downloading file uuids.txt error...", message: "")
                } else {
                    self.setCurWeekDate()
                }
//                self.reloadTableData()
                completion()
                
            } else {
                AlertManager.shared.showAlert(presentTo: self, title: "Error", message: error?.localizedDescription)
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func parseCabinetsFile() {
        self.presenter?.cabinetsStringFromFile.split(separator: "\n").forEach { line in
            var pairsForNumenatorOrDen = [[[String]]]()
            line.components(separatedBy: "###").forEach { day in
                var pairsForDay = [[String]]()
                day.components(separatedBy: "##").forEach { pair in
                    var cabinetsForPair = [String]()
                    pair.components(separatedBy: "#").forEach { cabinet in
                        cabinetsForPair.append(cabinet.trimmingCharacters(in: CharacterSet(charactersIn: "кк ")))
                    }
                    pairsForDay.append(cabinetsForPair)
                }
                pairsForNumenatorOrDen.append(pairsForDay)
            }
            self.FreeCabinets.append(pairsForNumenatorOrDen)
        }
    }
    
    private func setCurWeekDate() {
        self.presenter?.semesterStartFromFile = semesterStartFromFile.components(separatedBy: "\n")[0]
        let dateFormatter = ISO8601DateFormatter()
        semStartDate = dateFormatter.date(from: self.presenter?.semesterStartFromFile)!
        secondViewController.semStartDate = semStartDate
        semStartDate = Calendar.current.date(byAdding: .day, value: -1, to: semStartDate)!
        let deltaSecs = Date() - semStartDate
        curWeek = Int(deltaSecs/604800 + 1)
        choosenWeek = curWeek - 1
//        weekPicker.selectRow(curWeek-1, inComponent: 0, animated: true)
//        weekLabel.text = weeks[curWeek-1]
        weekButton.setTitle(weeks[curWeek-1], for: .normal)
        curNumOrDenom = (curWeek-1) % 2
//        print(curWeek)
    }
}
