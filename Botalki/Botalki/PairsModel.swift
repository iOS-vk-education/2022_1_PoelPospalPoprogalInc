//
//  PairsModel.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation


final class PairsModel {
    private let networkManager = NetworkManager.shared
    private let fileManager = MyFileManager.shared
    weak var presenter: PairsPresenter?
    var cabinetsStringFromFile: String = ""
    var semesterStartFromFile: String = ""
    var semStartDate = Date()
    var curWeek = 0
    var FreeCabinets = [[[[String]]]]()
    
    var myCells = [PairTableViewCell?]()
    
    
    init() {
        allocateCellsArr()
    }
    
    func loadAndParseCabinetsFileFromFirebase(completion: @escaping ((Result<Any, Error>) -> Void)) {
        networkManager.downloadFileFromFirebaseStorage(toFile: "cabinets.txt") { error in
            if error == nil {
                self.cabinetsStringFromFile = self.fileManager.getStringFromTextFile(with: "cabinets.txt") ?? ""
                
                if self.cabinetsStringFromFile == "" {
                    print("Downloading file error...")
                    completion(.failure(error!))
                } else {
                    completion(.success((Any).self))
                }
                
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func loadAndSetCurWeekFromFirebase(completion: @escaping ((Result<Any, Error>) -> Void)) {
        networkManager.downloadFileFromFirebaseStorage(toFile: "uuids.txt") { error in
            if error == nil {
                self.semesterStartFromFile = self.fileManager.getStringFromTextFile(with: "uuids.txt") ?? ""
                
                if self.semesterStartFromFile == "" {
                    print("Downloading file error...")
                    completion(.failure(error!))
                }
                completion(.success((Any).self))
                
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func parseCabinetsFile() {
        self.cabinetsStringFromFile.split(separator: "\n").forEach { line in
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
    
    func calculateCurWeek() {
        semesterStartFromFile = semesterStartFromFile.components(separatedBy: "\n")[0]
        let dateFormatter = ISO8601DateFormatter()
        semStartDate = dateFormatter.date(from: semesterStartFromFile)!
//        secondViewController.semStartDate = semStartDate
        semStartDate = Calendar.current.date(byAdding: .day, value: -1, to: semStartDate)!
        let deltaSecs = Date() - semStartDate
        curWeek = Int(deltaSecs/604800 + 1)
    }
    
    private func allocateCellsArr() {
        for _ in 0...6 {
            myCells.append(nil)
        }
    }
}
