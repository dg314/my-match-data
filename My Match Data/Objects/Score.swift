import UIKit
import RealmSwift

class Score: Object {
    @objc dynamic var scoreID = UUID().uuidString
    @objc dynamic var playerOnePoints: String = "0"
    @objc dynamic var playerTwoPoints: String = "0"
    @objc dynamic var fullPlayerOneName: String = ""
    @objc dynamic var fullPlayerTwoName: String = ""
    @objc dynamic var server: Int = 1
    @objc dynamic var winningState: Int = 0
    
    let gamesPerSetPlayerOne = List<String>()
    let gamesPerSetPlayerTwo = List<String>()
    
    override static func primaryKey() -> String? {
        return "scoreID"
    }
    
    func getGamesScoreline(playerOneIsFirst: Bool) -> String {
        if gamesPerSetPlayerOne.count == 0 {
            return "0-0"
        }
        
        var gamesScoreline = ""
        
        for n in 0..<gamesPerSetPlayerOne.count {
            if playerOneIsFirst {
                gamesScoreline += gamesPerSetPlayerOne[n] + "-" + gamesPerSetPlayerTwo[n]
            }
            else {
                gamesScoreline += gamesPerSetPlayerTwo[n] + "-" + gamesPerSetPlayerOne[n]
            }
            
            if n < gamesPerSetPlayerOne.count - 1 {
                gamesScoreline += " "
            }
        }
        
        return gamesScoreline
    }
    
    func getGamesScorelineInOrder() -> String {
        return getGamesScoreline(playerOneIsFirst: winningState >= 0)
    }
    
    func getPointsScoreline(playerOneIsFirst: Bool) -> String {
        if playerOneIsFirst {
            return playerOnePoints + "-" + playerTwoPoints
        }
        
        return playerTwoPoints + "-" + playerOnePoints
    }
    
    func getScoreline(playerOneIsFirst: Bool) -> String {
        return getGamesScoreline(playerOneIsFirst: playerOneIsFirst) + "  (" + getPointsScoreline(playerOneIsFirst: playerOneIsFirst) + ")"
    }
    
    func getResult() -> String {
        var result = ""
        
        if winningState >= 0 {
            result += fullPlayerOneName
        }
        else {
            result += fullPlayerTwoName
        }
        
        if abs(winningState) == 2 {
            result += " d. "
        }
        else if abs(winningState) == 1 {
            result += " leads "
        }
        else {
            result += " vs. "
        }
        
        if winningState < 0 {
            result += fullPlayerOneName
        }
        else {
            result += fullPlayerTwoName
        }
        
        return result
    }
    
    func getScorelineWithNames() -> String {
        return getResult() + "  (" + getGamesScorelineInOrder() + ")"
    }
}
