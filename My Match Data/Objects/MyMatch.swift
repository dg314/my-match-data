import UIKit
import RealmSwift
import Realm

class MyMatch: Object {
    @objc dynamic var matchID = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var sport = ""
    @objc dynamic var startingServer = 1
    @objc dynamic var doubles = false
    @objc dynamic var playerOneName = ""
    @objc dynamic var partnerOneName = ""
    @objc dynamic var playerTwoName = ""
    @objc dynamic var partnerTwoName = ""
    @objc dynamic var scoringType: ScoringType? = ScoringType()
    @objc dynamic var date = MyMatch.getFormattedDate()
    
    let sets = List<MySet>()
    let presets = List<Preset>()
    
    override static func primaryKey() -> String? {
        return "matchID"
    }
    
    func addPoint() -> MyPoint? {
        if didWin() == 0 {
            if sets.isEmpty {
                let set = MySet()
                set.startingServer = startingServer
                set.finalSet = scoringType!.setsToWinMatch == 1
                set.scoringType = scoringType
                sets.append(set)
            }
            
            var point = sets.last!.addPoint()
            
            while point == nil {
                let set = MySet()
                set.startingServer = sets.last!.games.last!.startingServer * -1
                set.finalSet = scoringType!.setsToWinMatch * 2 == sets.count + 2
                set.scoringType = scoringType
                sets.append(set)
                
                point = sets.last!.addPoint()
            }
            
            point?.score = getScore()
            
            return point
        }
        
        return nil
    }
    
    func didWin() -> Int {
        var s1 = 0
        var s2 = 0
        
        for set in sets {
            let setWon = set.didWin()
            
            if setWon == 1 {
                s1 += 1
            }
            else if setWon == -1 {
                s2 += 1
            }
            
            if s1 == scoringType!.setsToWinMatch {
                return 1
            }
            else if s2 == scoringType!.setsToWinMatch {
                return -1
            }
        }
        
        return 0
    }
    
    func getScore() -> Score {
        let score = Score()
        
        score.fullPlayerOneName = getFullPlayerOneName()
        score.fullPlayerTwoName = getFullPlayerTwoName()
        
        if sets.count > 0 {
            let finalGame = sets.last!.games.last!
            
            score.playerOnePoints = finalGame.getPointsText(playerOne: true)
            score.playerTwoPoints = finalGame.getPointsText(playerOne: false)
            
            score.server = sets.last!.games.last!.points.last!.server
            
            for set in sets {
                score.gamesPerSetPlayerOne.append(String(set.getGames(playerOne: true)))
                score.gamesPerSetPlayerTwo.append(String(set.getGames(playerOne: false)))
            }
            
            let didWinMatch = didWin()
            
            if didWinMatch != 0 {
                score.winningState = didWinMatch * 2
            }
            else {
                score.winningState = isWinningInGames()
            }
        }
        
        return score
    }
    
    func getFullPlayerOneName() -> String {
        if doubles {
            return playerOneName + " / " + partnerOneName
        }
        
        return playerOneName
    }
    
    func getFullPlayerTwoName() -> String {
        if doubles {
            return playerTwoName + " / " + partnerTwoName
        }
        
        return playerTwoName
    }
    
    func getPoints() -> [MyPoint] {
        var points: [MyPoint] = []
        
        for set in sets {
            for game in set.games {
                for point in game.points {
                    points.append(point)
                }
            }
        }
        
        return points
    }
    
    func getNotes() -> [Note] {
        var notes: [Note] = []
        
        for point in getPoints() {
            for note in point.notes {
                notes.append(note)
            }
        }
        
        return notes
    }
    
    func deleteNote(note: Note) -> Bool {
        for point in getPoints() {
            if point.deleteNote(note: note) {
                return true
            }
        }
        
        return false
    }
    
    func isWinning() -> Int {
        let winningInGames = isWinningInGames()
        
        if winningInGames != 0 {
            return winningInGames
        }
        
        var p1 = 0
        var p2 = 0
        
        for point in sets.last!.games.last!.points {
            let pointWon = point.won
            
            if pointWon == 1 {
                p1 += 1
            }
            else if pointWon == -1 {
                p2 += 1
            }
        }
        
        if p1 > p2 {
            return 1
        }
        else if p2 > p1 {
            return -1
        }
        
        return 0
    }
    
    func isWinningInGames() -> Int {
        if sets.isEmpty {
            return 0
        }
        
        var p1 = 0
        var p2 = 0
        
        for set in sets {
            let setWon = set.didWin()
            
            if setWon == 1 {
                p1 += 1
            }
            else if setWon == -1 {
                p2 += 1
            }
        }
        
        if p1 > p2 {
            return 1
        }
        else if p2 > p1 {
            return -1
        }
        
        p1 = 0
        p2 = 0
        
        for game in sets.last!.games {
            let gameWon = game.didWin()
            
            if gameWon == 1 {
                p1 += 1
            }
            else if gameWon == -1 {
                p2 += 1
            }
        }
        
        if p1 > p2 {
            return 1
        }
        else if p2 > p1 {
            return -1
        }
        
        return 0
    }
    
    func getStatList(index: Int) -> [StatList] {
        if index == -1 {
            return getStatLists(sets: Array(sets))
        }
        else {
            return getStatLists(sets: [sets[index]])
        }
    }
    
    func getStatLists(sets: [MySet]) -> [StatList] {
        var basicInfo: [Stat] = []
        var streaks: [Stat] = []
        
        var numGames: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        var gameStreak: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        var longestGameStreak: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        var numPoints: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        var pointStreak: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        var longestPointStreak: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        var breakPoints: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        var breakPointsWon: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        var breakPointConversionPercentage: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        var serviceGamesWon: (playerOne: Int, playerTwo: Int) = (playerOne: 0, playerTwo: 0)
        
        for set in sets {
            for game in set.games {
                let gameWon = game.didWin()
                
                if gameWon == 1 {
                    numGames.playerOne += 1
                    
                    gameStreak.playerOne += 1
                    gameStreak.playerTwo = 0
                    
                    if !game.tiebreaker {
                        if game.startingServer > 0 {
                            serviceGamesWon.playerOne += 1
                        }
                        else {
                            breakPointsWon.playerOne += 1
                        }
                    }
                }
                else if gameWon == -1 {
                    numGames.playerTwo += 1
                    
                    gameStreak.playerOne = 0
                    gameStreak.playerTwo += 1
                    
                    if !game.tiebreaker {
                        if game.startingServer > 0 {
                            breakPointsWon.playerTwo += 1
                        }
                        else {
                            serviceGamesWon.playerTwo += 1
                        }
                    }
                }
                
                if gameStreak.playerOne > longestGameStreak.playerOne {
                    longestGameStreak.playerOne = gameStreak.playerOne
                }
                
                if gameStreak.playerTwo > longestGameStreak.playerTwo {
                    longestGameStreak.playerTwo = gameStreak.playerTwo
                }
                
                var p1 = 0
                var p2 = 0
                
                for point in game.points {
                    if point.won == 1 {
                        numPoints.playerOne += 1
                        
                        pointStreak.playerOne += 1
                        pointStreak.playerTwo = 0
                        
                        p1 += 1
                    }
                    else if point.won == -1 {
                        numPoints.playerTwo += 1
                        
                        pointStreak.playerOne = 0
                        pointStreak.playerTwo += 1
                        
                        p2 += 1
                    }
                    
                    if pointStreak.playerOne > longestPointStreak.playerOne {
                        longestPointStreak.playerOne = pointStreak.playerOne
                    }
                    
                    if pointStreak.playerTwo > longestPointStreak.playerTwo {
                        longestPointStreak.playerTwo = pointStreak.playerTwo
                    }
                    
                    if !game.tiebreaker && game.points.index(of: point)! < game.points.count - 2 + abs(gameWon) {
                        if p1 - p2 + 1 >= set.scoringType!.pointLeadToWinGame && p1 + 1 >= set.scoringType!.pointsToWinGame && game.startingServer < 0 {
                            breakPoints.playerOne += 1
                        }
                        else if p2 - p1 + 1 >= set.scoringType!.pointLeadToWinGame && p2 + 1 >= set.scoringType!.pointsToWinGame && game.startingServer > 0 {
                            breakPoints.playerTwo += 1
                        }
                    }
                }
            }
        }
        if breakPoints.playerOne > 0 {
            breakPointConversionPercentage.playerOne = Int(Double(breakPointsWon.playerOne)/Double(breakPoints.playerOne) * 100 + 0.5)
        }
        
        if breakPoints.playerTwo > 0 {
            breakPointConversionPercentage.playerTwo = Int(Double(breakPointsWon.playerTwo)/Double(breakPoints.playerTwo) * 100 + 0.5)
        }
        
        basicInfo.append(Stat(title: "Points Won", playerOneValue: String(numPoints.playerOne), playerTwoValue: String(numPoints.playerTwo), lead: numPoints.playerOne - numPoints.playerTwo))
        basicInfo.append(Stat(title: "Games Won", playerOneValue: String(numGames.playerOne), playerTwoValue: String(numGames.playerTwo), lead: numGames.playerOne - numGames.playerTwo))
        basicInfo.append(Stat(title: "Service Games Won", playerOneValue: String(serviceGamesWon.playerOne), playerTwoValue: String(serviceGamesWon.playerTwo), lead: serviceGamesWon.playerOne - serviceGamesWon.playerTwo))
        basicInfo.append(Stat(title: "Break Points Won", playerOneValue: "\(breakPointsWon.playerOne)/\(breakPoints.playerOne) (\(breakPointConversionPercentage.playerOne)%)", playerTwoValue: "\(breakPointsWon.playerTwo)/\(breakPoints.playerTwo) (\(breakPointConversionPercentage.playerTwo)%)", lead: breakPointConversionPercentage.playerOne - breakPointConversionPercentage.playerTwo))
        
        streaks.append(Stat(title: "Longest Point Streak", playerOneValue: String(longestPointStreak.playerOne), playerTwoValue: String(longestPointStreak.playerTwo), lead: longestPointStreak.playerOne - longestPointStreak.playerTwo))
        streaks.append(Stat(title: "Longest Game Streak", playerOneValue: String(longestGameStreak.playerOne), playerTwoValue: String(longestGameStreak.playerTwo), lead: longestGameStreak.playerOne - longestGameStreak.playerTwo))
        
        var statLists: [StatList] = []
        
        statLists.append(StatList(title: "Basic Info", stats: basicInfo))
        statLists.append(StatList(title: "Streaks", stats: streaks))
        
        var count = 0
        
        for preset in presets {
            var customStats: [Stat] = []
            
            let rows = preset.numRows()
            
            var firstRowFrequencesPlayerOne: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count)
            var secondRowFrequencesPlayerOne: [Int] = Array(repeating: 0, count: preset.secondRowOptions.count)
            var combinationFrequencesPlayerOne: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count * preset.secondRowOptions.count)
            
            var firstRowFrequencesPlayerTwo: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count)
            var secondRowFrequencesPlayerTwo: [Int] = Array(repeating: 0, count: preset.secondRowOptions.count)
            var combinationFrequencesPlayerTwo: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count * preset.secondRowOptions.count)
            
            var firstRowFrequencesPlayerOneWon: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count)
            var secondRowFrequencesPlayerOneWon: [Int] = Array(repeating: 0, count: preset.secondRowOptions.count)
            var combinationFrequencesPlayerOneWon: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count * preset.secondRowOptions.count)
            
            var firstRowFrequencesPlayerTwoWon: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count)
            var secondRowFrequencesPlayerTwoWon: [Int] = Array(repeating: 0, count: preset.secondRowOptions.count)
            var combinationFrequencesPlayerTwoWon: [Int] = Array(repeating: 0, count: preset.firstRowOptions.count * preset.secondRowOptions.count)
            
            var playerOneDenominator = 0
            var playerTwoDenominator = 0
            
            for set in sets {
                for game in set.games {
                    for point in game.points {
                        if !point.presetValues.isEmpty {
                            let val = point.presetValues[count]
                            
                            if (preset.type == 0 && point.won == 1) || (preset.type == 1 && point.server > 0) || (preset.type == 2 && point.server < 0) {
                                playerOneDenominator += 1
                                
                                if rows >= 1 {
                                    firstRowFrequencesPlayerOne[val%1000] += 1
                                    
                                    if point.won == 1 {
                                        firstRowFrequencesPlayerOneWon[val%1000] += 1
                                    }
                                    
                                    if rows == 2 {
                                        secondRowFrequencesPlayerOne[val/1000] += 1
                                        combinationFrequencesPlayerOne[val%1000 + val/1000 * preset.firstRowOptions.count] += 1
                                        
                                        if point.won == 1 {
                                            secondRowFrequencesPlayerOneWon[val/1000] += 1
                                            combinationFrequencesPlayerOneWon[val%1000 + val/1000 * preset.firstRowOptions.count] += 1
                                        }
                                    }
                                }
                            }
                            else if (preset.type == 0 && point.won == -1) || (preset.type == 1 && point.server < 0) || (preset.type == 2 && point.server > 0) {
                                playerTwoDenominator += 1
                                
                                if rows >= 1 {
                                    firstRowFrequencesPlayerTwo[val%1000] += 1
                                    
                                    if point.won == -1 {
                                        firstRowFrequencesPlayerTwoWon[val%1000] += 1
                                    }
                                    
                                    if rows == 2 {
                                        secondRowFrequencesPlayerTwo[val/1000] += 1
                                        combinationFrequencesPlayerTwo[val%1000 + val/1000 * preset.firstRowOptions.count] += 1
                                        
                                        if point.won == -1 {
                                            secondRowFrequencesPlayerTwoWon[val/1000] += 1
                                            combinationFrequencesPlayerTwoWon[val%1000 + val/1000 * preset.firstRowOptions.count] += 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if rows >= 1 {
                for n in 0..<preset.firstRowOptions.count {
                    if preset.firstRowOptions[n].individualType >= 0 {
                        let playerOnePercentage = playerOneDenominator == 0 ? 0 : Int(Double(firstRowFrequencesPlayerOne[n])/Double(playerOneDenominator) * 100 + 0.5)
                        let playerOneValue = String(firstRowFrequencesPlayerOne[n]) + (preset.firstRowOptions[n].individualType >= 1 ? "/\(playerOneDenominator) (\(playerOnePercentage)%)" : "")
                        
                        let playerTwoPercentage = playerTwoDenominator == 0 ? 0 : Int(Double(firstRowFrequencesPlayerTwo[n])/Double(playerTwoDenominator) * 100 + 0.5)
                        let playerTwoValue = String(firstRowFrequencesPlayerTwo[n]) + (preset.firstRowOptions[n].individualType >= 1 ? "/\(playerTwoDenominator) (\(playerTwoPercentage)%)" : "")
                        
                        var lead = 0
                        
                        if preset.firstRowOptions[n].individualType == 0 {
                            lead = firstRowFrequencesPlayerOne[n] - firstRowFrequencesPlayerTwo[n]
                        }
                        else if preset.firstRowOptions[n].individualType == 1 {
                            lead = playerOnePercentage - playerTwoPercentage
                        }
                        
                        if preset.firstRowOptions[n].flipped {
                            customStats.append(Stat(title: preset.firstRowOptions[n].individualName, playerOneValue: playerTwoValue, playerTwoValue: playerOneValue, lead: lead))
                        }
                        else {
                            customStats.append(Stat(title: preset.firstRowOptions[n].individualName, playerOneValue: playerOneValue, playerTwoValue: playerTwoValue, lead: lead))
                        }
                    }
                    
                    if preset.firstRowOptions[n].individualWonType >= 0 {
                        let playerOnePercentageWon = firstRowFrequencesPlayerOne[n] == 0 ? 0 : Int(Double(firstRowFrequencesPlayerOneWon[n])/Double(firstRowFrequencesPlayerOne[n]) * 100 + 0.5)
                        let playerOneValueWon = "\(firstRowFrequencesPlayerOneWon[n])/\(firstRowFrequencesPlayerOne[n]) (\(playerOnePercentageWon)%)"
                        
                        let playerTwoPercentageWon = firstRowFrequencesPlayerTwo[n] == 0 ? 0 : Int(Double(firstRowFrequencesPlayerTwoWon[n])/Double(firstRowFrequencesPlayerTwo[n]) * 100 + 0.5)
                        let playerTwoValueWon = "\(firstRowFrequencesPlayerTwoWon[n])/\(firstRowFrequencesPlayerTwo[n]) (\(playerTwoPercentageWon)%)"
                        
                        let lead = playerOnePercentageWon - playerTwoPercentageWon
                        
                        if preset.firstRowOptions[n].flipped {
                            customStats.append(Stat(title: preset.firstRowOptions[n].individualWonName, playerOneValue: playerTwoValueWon, playerTwoValue: playerOneValueWon, lead: lead))
                        }
                        else {
                            customStats.append(Stat(title: preset.firstRowOptions[n].individualWonName, playerOneValue: playerOneValueWon, playerTwoValue: playerTwoValueWon, lead: lead))
                        }
                    }
                }
                
                if rows == 2 {
                    for n in 0..<preset.secondRowOptions.count {
                        if preset.secondRowOptions[n].individualType >= 0 {
                            let playerOnePercentage = playerOneDenominator == 0 ? 0 : Int(Double(secondRowFrequencesPlayerOne[n])/Double(playerOneDenominator) * 100 + 0.5)
                            let playerOneValue = String(secondRowFrequencesPlayerOne[n]) + (preset.secondRowOptions[n].individualType >= 1 ? "/\(playerOneDenominator) (\(playerOnePercentage)%)"  : "")
                            
                            let playerTwoPercentage = playerTwoDenominator == 0 ? 0 : Int(Double(secondRowFrequencesPlayerTwo[n])/Double(playerTwoDenominator) * 100 + 0.5)
                            let playerTwoValue = String(secondRowFrequencesPlayerTwo[n]) + (preset.secondRowOptions[n].individualType >= 1 ? "/\(playerTwoDenominator) (\(playerTwoPercentage)%)"  : "")
                            
                            var lead = 0
                            
                            if preset.secondRowOptions[n].individualType == 0 {
                                lead = secondRowFrequencesPlayerOne[n] - secondRowFrequencesPlayerTwo[n]
                            }
                            else if preset.secondRowOptions[n].individualType == 1 {
                                lead = playerOnePercentage - playerTwoPercentage
                            }
                            
                            if preset.secondRowOptions[n].flipped {
                                customStats.append(Stat(title: preset.secondRowOptions[n].individualName, playerOneValue: playerTwoValue, playerTwoValue: playerOneValue, lead: lead))
                            }
                            else {
                                customStats.append(Stat(title: preset.secondRowOptions[n].individualName, playerOneValue: playerOneValue, playerTwoValue: playerTwoValue, lead: lead))
                            }
                        }
                    }
                    
                    for n1 in 0..<preset.firstRowOptions.count {
                        for n2 in 0..<preset.secondRowOptions.count {
                            if preset.firstRowOptions[n1].combinedType >= 0 && preset.secondRowOptions[n2].combinedType >= 0 {
                                var title = preset.firstRowOptions[n1].combinedName + " " + preset.secondRowOptions[n2].combinedName
                                
                                if preset.name == "Point Finish" {
                                    if title == "Serve Winners" {
                                        title = "Aces"
                                    }
                                    else if title == "Serve Unforced Errors" {
                                        title = "Double Faults"
                                    }
                                }
                                
                                let pos = n1 + n2 * preset.firstRowOptions.count
                                let playerOneValue = String(combinationFrequencesPlayerOne[pos])
                                let playerTwoValue = String(combinationFrequencesPlayerTwo[pos])
                                let lead = combinationFrequencesPlayerOne[pos] - combinationFrequencesPlayerTwo[pos]
                                
                                if preset.secondRowOptions[n2].flipped {
                                    customStats.append(Stat(title: title, playerOneValue: playerTwoValue, playerTwoValue: playerOneValue, lead: lead))
                                }
                                else {
                                    customStats.append(Stat(title: title, playerOneValue: playerOneValue, playerTwoValue: playerTwoValue, lead: lead))
                                }
                            }
                        }
                    }
                }
            }
            
            statLists.append(StatList(title: preset.name, stats: customStats))
            
            count += 1
        }
        
        return statLists
    }
    
    func delete() {
        try! realm?.write {
            if scoringType != nil {
                realm?.delete(scoringType!)
            }
            
            for set in sets {
                set.delete()
            }
            
            for preset in presets {
                preset.delete()
            }
            
            realm?.delete(self)
        }
    }
    
    static func getFormattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}
