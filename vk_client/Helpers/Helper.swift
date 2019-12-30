import Foundation

class Helper {
    
    static func getAgeFromBirthDate(birthDate: String) -> Int {
        
        //Приходит birthDate в формате строки dd.mm.yyyy

        let dateComponents = birthDate.components(separatedBy: ".")
        guard let date = Calendar.current.date(from: DateComponents(year: Int(dateComponents[2]), month: Int(dateComponents[1]), day: Int(dateComponents[0]))) else {
            return -1
        }
        guard let calculatedAge = Calendar.current.dateComponents([.year], from: date, to: Date()).year else {
            return -1
        }
        
        return calculatedAge
    }
}
