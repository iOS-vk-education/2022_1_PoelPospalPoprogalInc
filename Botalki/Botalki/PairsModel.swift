import Foundation


final class PairsModel {
    private let networkManager = NetworkManager.shared
    private let fileManager = MyFileManager.shared
    weak var presenter: PairsPresenter?
    var cabinetsStringFromFile: String = ""
    var semesterStartFromFile: String = ""
    var semStartDate = Date()
    var semEndDate = Date()
    var curWeek = 0
    var curWeekInFilter = 0
    var curWeekDayInFilter = 0
    var daysOfWeak = ["Пн\n", "Вт\n", "Ср\n", "Чт\n", "Пт\n", "Сб\n"]
    var FreeCabinets = [[[[String]]]]()
    var curDay = 2
    var selectedDate = Date()
    var curNumOrDenom = 0
    var curWeekInMain = 0
    var cellForReloadIndexes = [Int]()
    
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
        FreeCabinets = []
        cabinetsStringFromFile.split(separator: "\n").forEach { line in
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
            FreeCabinets.append(pairsForNumenatorOrDen)
        }
    }
    
    func setup() {
        formDaysOfWeakStrings()
        setCurDay()
    }
    
    func calculateCurWeek() {
        semesterStartFromFile = semesterStartFromFile.components(separatedBy: "\n")[0]
        let dateFormatter = ISO8601DateFormatter()
        semStartDate = dateFormatter.date(from: semesterStartFromFile)!
        semStartDate = Calendar.current.date(byAdding: .day, value: -1, to: semStartDate)!
        let deltaSecs = Date() - semStartDate
        curWeek = Int(deltaSecs/604800 + 1)
        if curWeek > 17 {
            curWeek = 17
        }
    }
    
    private func allocateCellsArr() {
        for _ in 0...6 {
            myCells.append(nil)
        }
    }
    
    private func formDaysOfWeakStrings() {
        var i = 0
        for delta in -curDay...(5 - curDay) {
            daysOfWeak[i] += String(Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: delta, to: selectedDate) ?? selectedDate))
            i += 1
        }
    }
    
    func setCurDay() {
        let calendar = Calendar.current
        semEndDate = calendar.date(byAdding: .day, value: 7*17, to: semStartDate)!
        if Date() > calendar.date(byAdding: .day, value: -1, to: semEndDate)! {
            selectedDate = calendar.date(byAdding: .day, value: -1, to: semEndDate)!
        } else {
            selectedDate = Date()
        }
        curDay = calendar.component(.weekday, from: selectedDate) - 2
        
        //Обработка воскресенья
        if curDay == -1 {
            curDay = 0
            selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
            changeNumOrDenom()
        }
    }
    
    private func changeNumOrDenom() {
        if curNumOrDenom == 0 {
            curNumOrDenom = 1
        } else {
            curNumOrDenom = 0
        }
    }
}
