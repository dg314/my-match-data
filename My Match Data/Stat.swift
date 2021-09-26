import UIKit

class Stat {
    var title: String
    var playerOneValue: String
    var playerTwoValue: String
    var lead: Int
    
    init(title: String, playerOneValue: String, playerTwoValue: String, lead: Int) {
        self.title = title
        self.playerOneValue = playerOneValue
        self.playerTwoValue = playerTwoValue
        self.lead = lead
    }
    
    convenience init() {
        self.init(title: "", playerOneValue: "", playerTwoValue: "", lead: 0)
    }
}
