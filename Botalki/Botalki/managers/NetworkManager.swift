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
            self.storage.child(fName).write(toFile: filePath) { url, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}

