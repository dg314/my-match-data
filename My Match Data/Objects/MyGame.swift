import UIKit
import RealmSwift

class MyGame: Object {
    @objc dynamic var gameID = UUID().uuidString
    @objc dynamic var startingServer: Int = 1
    @objc dynamic var tiebreaker: Bool = false
    @objc dynamic var finalSet: Bool = false
    @objc dynamic var scoringType: ScoringType? = ScoringType()
    
    let points = List<MyPoint>()
    
    override static func primaryKey() -> String? {
        return "gameID"
    }
    
    func addPoint() -> MyPoint? {
        if didWin() == 0 {
            let point = MyPoint()
            point.server = tiebreaker ? (startingServer == ScoringType.getTennisTiebreakerServingPattern()[points.count % 4] ? 1 : -1) : startingServer
            
            points.append(point)
            
            return point
        }
        
        return nil
    }
    
    func didWin() -> Int {
        var p1 = 0
        var p2 = 0
        
        for point in points {
            if point.won == 1 {
                p1 += 1
            }
            else if point.won == -1 {
                p2 += 1
            }
        }
        
        if tiebreaker {
            if finalSet {
                if p1 >= scoringType!.pointsToWinTiebreakerFinalSet && p1 - p2 >= scoringType!.pointLeadToWinTiebreakerFinalSet {
                    return 1
                }
                else if p2 >= scoringType!.pointsToWinTiebreakerFinalSet && p2 - p1 >= scoringType!.pointLeadToWinTiebreakerFinalSet {
                    return -1
                }
            }
            else {
                if p1 >= scoringType!.pointsToWinTiebreakerDefaultSet && p1 - p2 >= scoringType!.pointLeadToWinTiebreakerDefaultSet {
                    return 1
                }
                else if p2 >= scoringType!.pointsToWinTiebreakerDefaultSet && p2 - p1 >= scoringType!.pointLeadToWinTiebreakerDefaultSet {
                    return -1
                }
            }
        }
        else if p1 >= scoringType!.pointsToWinGame && p1 - p2 >= scoringType!.pointLeadToWinGame {
            return 1
        }
        else if p2 >= scoringType!.pointsToWinGame && p2 - p1 >= scoringType!.pointLeadToWinGame {
            return -1
        }
        
        return 0
    }
    
    func getPoints(playerOne: Bool) -> Int {
        var p = 0
        
        for point in points {
            if (playerOne && point.won == 1) || (!playerOne && point.won == -1) {
                p += 1
            }
        }
        
        return p
    }
    
    func getPointsText(playerOne: Bool) -> String {
        if didWin() != 0 {
            return "0"
        }
        
        let pp = getPoints(playerOne: playerOne)
        
        if tiebreaker {
            return String(pp)
        }
        
        switch(pp) {
        case 0:
            return "0"
        case 1:
            return "15"
        case 2:
            return "30"
        case 3:
            return "40"
        default:
            switch(pp - getPoints(playerOne: !playerOne)) {
            case 1:
                return "AD"
            default:
                return "40"
            }
        }
    }
    
    func delete() {
        if scoringType != nil {
            realm?.delete(scoringType!)
        }
        
        for point in points {
            point.delete()
        }
        
        realm?.delete(self)
    }
}
