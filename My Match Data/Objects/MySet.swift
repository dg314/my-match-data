import UIKit
import RealmSwift

class MySet: Object {
    @objc dynamic var setID = UUID().uuidString
    @objc dynamic var startingServer: Int = 1
    @objc dynamic var finalSet: Bool = false
    @objc dynamic var scoringType: ScoringType? = ScoringType()
    
    let games = List<MyGame>()
    
    override static func primaryKey() -> String? {
        return "setID"
    }
    
    func addPoint() -> MyPoint? {
        if didWin() == 0 {
            if games.isEmpty {
                let game = MyGame()
                game.startingServer = startingServer
                game.tiebreaker = finalSet ? scoringType!.gamesUntilTiebreakerFinalSet == 0 : scoringType!.gamesUntilTiebreakerDefaultSet == 0
                game.finalSet = finalSet
                game.scoringType = scoringType
                games.append(game)
            }
            
            var point = games.last!.addPoint()
            
            while point == nil {
                let pg = getGames(playerOne: true)
                let og = getGames(playerOne: false)
                
                let game = MyGame()
                game.startingServer = games.last!.startingServer * -1
                game.tiebreaker = (pg == og) && (finalSet ? scoringType!.gamesUntilTiebreakerFinalSet == pg : scoringType!.gamesUntilTiebreakerDefaultSet == pg)
                game.finalSet = finalSet
                game.scoringType = scoringType
                games.append(game)
                
                point = games.last!.addPoint()
            }
            
            return point
        }
        
        return nil
    }
    
    func didWin() -> Int {
        var g1 = 0
        var g2 = 0
        
        for game in games {
            let gameWon = game.didWin()
            
            if gameWon == 1 {
                g1 += 1
            }
            else if gameWon == -1 {
                g2 += 1
            }
            
            if game.tiebreaker {
                if g1 > g2 {
                    return 1
                }
                else if g2 > g1 {
                    return -1
                }
            }
            else if finalSet {
                if g1 >= scoringType!.gamesToWinFinalSet && g1 - g2 >= scoringType!.gameLeadToWinFinalSet {
                    return 1
                }
                else if g2 >= scoringType!.gamesToWinFinalSet && g2 - g1 >= scoringType!.gameLeadToWinFinalSet {
                    return -1
                }
            }
            else {
                if g1 >= scoringType!.gamesToWinDefaultSet && g1 - g2 >= scoringType!.gameLeadToWinDefaultSet {
                    return 1
                }
                else if g2 >= scoringType!.gamesToWinDefaultSet && g2 - g1 >= scoringType!.gameLeadToWinDefaultSet {
                    return -1
                }
            }
        }
        
        return 0
    }
    
    func getGames(playerOne: Bool) -> Int {
        var g = 0
        
        for game in games {
            let gameWon = game.didWin()
            
            if (playerOne && gameWon == 1) || (!playerOne && gameWon == -1) {
                g += 1
            }
        }
        
        return g
    }
    
    func delete() {
        if scoringType != nil {
            realm?.delete(scoringType!)
        }
        
        for game in games {
            game.delete()
        }
        
        realm?.delete(self)
    }
}
