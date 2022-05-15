//
//  NetworkManager.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation
import FirebaseStorage

protocol NetworkManagerDescription {
    func downloadFileFromFirebaseStorage(toFile fName: String, completion: @escaping (Error?) -> Void)
}

enum NetworkError: Error {
    case invalidUrl
    case emptyData
}

final class NetworkManager: NetworkManagerDescription {
    static let shared: NetworkManagerDescription = NetworkManager()
    
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    func downloadFileFromFirebaseStorage(toFile fName: String, completion: @escaping (Error?) -> Void) {
        guard let documentsUrl = MyFileManager.shared.getDocumentDirUrl() else {
            print("documentsUrl Error!")
            return
        }
        
        let filePath = documentsUrl.appendingPathComponent(fName)
        
        DispatchQueue.global(qos: .userInitiated).async {
//            let downloadTask =
            self.storage.child(fName).write(toFile: filePath) { url, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
//                    print("Uh-oh, an error occurred!")
//                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .cancel)
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    self.tableView.refreshControl?.endRefreshing()
                // Uh-oh, an error occurred!
                } else {
//                    print("Local file URL is returned")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                // Local file URL for "images/island.jpg" is returned
                }
            }
        }
    }
}


//downloadFile(with: "cabinets.txt") {
//    self.allCabinetsFromFile = self.readTextFile(with: "cabinets.txt") ?? ""
//    
//    if self.allCabinetsFromFile == "" {
//        print("Downloading file error...")
//    }
//    else {
//        
//        self.parseSourceFile()
//    }
//    
//    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
//    for i in 0...6 {
//        indexPath.row = i
//        indexPath.section = 0
//        self.myCells[i] = self.tableView.dequeueReusableCell(withIdentifier: "PairTableViewCell", for: indexPath) as? PairTableViewCell
//    }
//    
//    self.tableView.refreshControl?.endRefreshing()
//    self.tableView.delegate = self
//    self.tableView.dataSource = self
//    self.loadData()
//}


