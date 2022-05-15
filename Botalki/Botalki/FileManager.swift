//
//  FileManager.swift
//  Botalki
//
//  Created by Сергей Николаев on 15.05.2022.
//

import Foundation

protocol FileManagerDescription {
    func getStringFromTextFile(with fName: String) -> String?
    func getDocumentDirUrl() -> URL?
}

enum FileError: Error {
    case invalidUrl
    case emptyData
}

final class MyFileManager: FileManagerDescription {
    static let shared: FileManagerDescription = MyFileManager()
    
    private init() {}
    
    func getStringFromTextFile(with fName: String) -> String? {
        guard let documentsUrl = getDocumentDirUrl() else {
            print("documentsUrl Error!")
            return nil
        }
        
        let filename: String = fName
        
        let manager = FileManager.default
        
        let filePath = documentsUrl.appendingPathComponent(filename)
        
        if !manager.fileExists(atPath: filePath.path) {
            print("File not exist!")
            return nil
        }
        
        let content = (try? String(contentsOf: filePath, encoding: .utf8)) ?? ""
        
        return content
    }

    func getDocumentDirUrl() -> URL? {
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
