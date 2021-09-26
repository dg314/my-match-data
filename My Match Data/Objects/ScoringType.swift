import UIKit
import RealmSwift

class ScoringType: Object {
    @objc dynamic var scoringTypeID = UUID().uuidString
    @objc dynamic var sport = ""
    @objc dynamic var pointsToWinGame: Int = 4
    @objc dynamic var pointLeadToWinGame: Int = 2
    @objc dynamic var setsToWinMatch: Int = 2
    @objc dynamic var gamesToWinDefaultSet: Int = 6
    @objc dynamic var gamesToWinFinalSet: Int = 6
    @objc dynamic var gameLeadToWinDefaultSet: Int = 2
    @objc dynamic var gameLeadToWinFinalSet: Int = 2
    @objc dynamic var gamesUntilTiebreakerDefaultSet: Int = 6
    @objc dynamic var gamesUntilTiebreakerFinalSet: Int = 6
    @objc dynamic var pointsToWinTiebreakerDefaultSet: Int = 7
    @objc dynamic var pointsToWinTiebreakerFinalSet: Int = 7
    @objc dynamic var pointLeadToWinTiebreakerDefaultSet: Int = 2
    @objc dynamic var pointLeadToWinTiebreakerFinalSet: Int = 2
    
    override static func primaryKey() -> String? {
        return "scoringTypeID"
    }
    
    static func getTennisTiebreakerServingPattern() -> [Int] {
        return [1, -1, -1, 1]
    }
}

