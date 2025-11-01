import Foundation

class Person: Codable {
    var fullname: String
    var height: Double
    var birthDay: Date  // mejor usar Date en lugar de NSDate

    init(fullname: String, height: Double, birthDay: Date) {
        self.fullname = fullname
        self.height = height
        self.birthDay = birthDay
    }
}
