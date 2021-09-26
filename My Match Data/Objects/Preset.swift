import UIKit
import RealmSwift

class Preset: Object {
    @objc dynamic var presetID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var type: Int = 0 // 0 -> won points, 1 -> serving points, 2 -> returning points
    
    let firstRowOptions = List<PresetOption>()
    let secondRowOptions = List<PresetOption>()
    
    override static func primaryKey() -> String? {
        return "presetID"
    }
    
    func numRows() -> Int {
        if secondRowOptions.isEmpty {
            if firstRowOptions.isEmpty {
                return 0
            }
            
            return 1
        }
        
        return 2
    }
    
    static func serveIn() -> Preset {
        let firstServe = PresetOption()
        firstServe.name = "1st Serve In"
        firstServe.individualName = "1st Serve %"
        firstServe.individualWonName = "1st Serve Win %"
        firstServe.individualType = 1
        firstServe.individualWonType = 0
        
        let secondServe = PresetOption()
        secondServe.name = "1st Serve Out"
        secondServe.individualWonName = "2nd Serve Win %"
        secondServe.individualType = -1
        secondServe.individualWonType = 0
        
        let preset = Preset()
        preset.name = "Serve"
        preset.type = 1
        preset.firstRowOptions.append(firstServe)
        preset.firstRowOptions.append(secondServe)
        
        return preset
    }
    
    static func pointFinish() -> Preset {
        let forehand = PresetOption()
        forehand.name = "Forehand"
        forehand.combinedName = "FH"
        forehand.individualType = -1
        forehand.combinedType = 0
        
        let backhand = PresetOption()
        backhand.name = "Backhand"
        backhand.combinedName = "BH"
        backhand.individualType = -1
        backhand.combinedType = 0
        
        let volley = PresetOption()
        volley.name = "Volley"
        volley.combinedName = "Net"
        volley.individualType = -1
        volley.combinedType = 0
        
        let serve = PresetOption()
        serve.name = "Serve"
        serve.combinedName = "Serve"
        serve.individualType = -1
        serve.combinedType = 0
        
        let other = PresetOption()
        other.name = "Other"
        other.individualType = -1
        other.combinedType = -1
        
        let winner = PresetOption()
        winner.name = "Winner"
        winner.individualName = "Winners"
        winner.combinedName = "Winners"
        winner.individualType = 0
        winner.combinedType = 0
        
        let forcedError = PresetOption()
        forcedError.name = "Forced Error"
        forcedError.individualName = "Forced Errors"
        forcedError.individualType = 0
        forcedError.combinedType = -1
        
        let unforcedError = PresetOption()
        unforcedError.name = "Unforced Error"
        unforcedError.individualName = "Unforced Errors"
        unforcedError.combinedName = "Unforced Errors"
        unforcedError.individualType = 0
        unforcedError.combinedType = 0
        unforcedError.flipped = true
        
        let preset = Preset()
        preset.name = "Point Finish"
        preset.type = 0
        preset.firstRowOptions.append(forehand)
        preset.firstRowOptions.append(backhand)
        preset.firstRowOptions.append(volley)
        preset.firstRowOptions.append(serve)
        preset.firstRowOptions.append(other)
        preset.secondRowOptions.append(winner)
        preset.secondRowOptions.append(forcedError)
        preset.secondRowOptions.append(unforcedError)
        
        return preset
    }
    
    static func rallyLength() -> Preset {
        let zeroToFourShots = PresetOption()
        zeroToFourShots.name = "0-4 Shots"
        zeroToFourShots.individualName = "0-4 Shot Points Won"
        zeroToFourShots.individualType = 0
        
        let fiveToEightShots = PresetOption()
        fiveToEightShots.name = "5-8 Shots"
        fiveToEightShots.individualName = "5-8 Shot Points Won"
        fiveToEightShots.individualType = 0
        
        let ninePlusShots = PresetOption()
        ninePlusShots.name = "9+ Shots"
        ninePlusShots.individualName = "9+ Shot Points Won"
        ninePlusShots.individualType = 0
        
        let preset = Preset()
        preset.name = "Rally Length"
        preset.type = 0
        preset.firstRowOptions.append(zeroToFourShots)
        preset.firstRowOptions.append(fiveToEightShots)
        preset.firstRowOptions.append(ninePlusShots)
        
        return preset
    }
    
    static func servePlacement() -> Preset {
        let T = PresetOption()
        T.name = "Up the T"
        T.individualName = "Up the T"
        T.individualWonName = "T Serve Win %"
        T.individualType = 1
        T.individualWonType = 0
        
        let body = PresetOption()
        body.name = "Body"
        body.individualName = "Body"
        body.individualWonName = "Body Serve Win %"
        body.individualType = 1
        body.individualWonType = 0
        
        let wide = PresetOption()
        wide.name = "Wide"
        wide.individualName = "Wide"
        wide.individualWonName = "Wide Serve Win %"
        wide.individualType = 1
        wide.individualWonType = 0
        
        let preset = Preset()
        preset.name = "Serve Placement"
        preset.type = 1
        preset.firstRowOptions.append(T)
        preset.firstRowOptions.append(body)
        preset.firstRowOptions.append(wide)
        
        return preset
    }
    
    static func serveSpin() -> Preset {
        let slice = PresetOption()
        slice.name = "Slice"
        slice.individualName = "Slice"
        slice.individualWonName = "Slice Serve Win %"
        slice.individualType = 1
        slice.individualWonType = 0
        
        let flat = PresetOption()
        flat.name = "Flat"
        flat.individualName = "Flat"
        flat.individualWonName = "Flat Serve Win %"
        flat.individualType = 1
        flat.individualWonType = 0
        
        let kick = PresetOption()
        kick.name = "Kick"
        kick.individualName = "Kick"
        kick.individualWonName = "Kick Serve Win %"
        kick.individualType = 1
        kick.individualWonType = 0
        
        let preset = Preset()
        preset.name = "Serve Spin"
        preset.type = 1
        preset.firstRowOptions.append(slice)
        preset.firstRowOptions.append(flat)
        preset.firstRowOptions.append(kick)
        
        return preset
    }
    
    static func firstBallAfterServe() -> Preset {
        let forehand = PresetOption()
        forehand.name = "Forehand"
        forehand.individualName = "Forehand"
        forehand.individualWonName = "Forehand Win %"
        forehand.individualType = 1
        forehand.individualWonType = 0
        
        let backhand = PresetOption()
        backhand.name = "Backhand"
        backhand.individualName = "Backhand"
        backhand.individualWonName = "Backhand Win %"
        backhand.individualType = 1
        backhand.individualWonType = 0
        
        let volley = PresetOption()
        volley.name = "Volley"
        volley.individualName = "Serve & Volley"
        volley.individualWonName = "Serve & Volley Win %"
        volley.individualType = 1
        volley.individualWonType = 0
        
        let other = PresetOption()
        other.name = "Other"
        other.individualType = -1
        
        let preset = Preset()
        preset.name = "First Ball After Serve"
        preset.type = 1
        preset.firstRowOptions.append(forehand)
        preset.firstRowOptions.append(backhand)
        preset.firstRowOptions.append(volley)
        
        return preset
    }
    
    static func returnType() -> Preset {
        let slice = PresetOption()
        slice.name = "Slice"
        slice.individualName = "Slice"
        slice.individualWonName = "Slice Win %"
        slice.individualType = 1
        slice.individualWonType = 0
        
        let topspin = PresetOption()
        topspin.name = "Topspin"
        topspin.individualName = "Topspin"
        topspin.individualWonName = "Topspin Win %"
        topspin.individualType = 1
        topspin.individualWonType = 0

        let other = PresetOption()
        other.name = "Other"
        other.individualType = -1
        
        let preset = Preset()
        preset.name = "Return"
        preset.type = 2
        preset.firstRowOptions.append(slice)
        preset.firstRowOptions.append(topspin)
        preset.firstRowOptions.append(other)
        
        return preset
    }
    
    static func defaultPresets() -> [Preset] {
        return [serveIn(), pointFinish(), rallyLength(), servePlacement(), serveSpin(), firstBallAfterServe(), returnType()]
    }
    
    func getStatNames() -> [String] {
        var statNames: [String] = []
        
        let rows = numRows()
        
        if rows >= 1 {
            for firstRowOption in firstRowOptions {
                if firstRowOption.individualType >= 0 {
                    statNames.append(firstRowOption.individualName)
                }
                
                if firstRowOption.individualWonType >= 0 {
                    statNames.append(firstRowOption.individualWonName)
                }
            }
            
            if rows == 2 {
                for secondRowOption in secondRowOptions {
                    if secondRowOption.individualType >= 0 {
                        statNames.append(secondRowOption.individualName)
                    }
                    
                    if secondRowOption.individualWonType >= 0 {
                        statNames.append(secondRowOption.individualWonName)
                    }
                }
                
                for firstRowOption in firstRowOptions {
                    for secondRowOption in secondRowOptions {
                        if firstRowOption.combinedType >= 0 && secondRowOption.combinedType >= 0 {
                            var title = firstRowOption.combinedName + " " + secondRowOption.combinedName
                            
                            if name == "Point Finish" {
                                if title == "Serve Winners" {
                                    title = "Aces"
                                }
                                else if title == "Serve Unforced Errors" {
                                    title = "Double Faults"
                                }
                            }
                            
                            statNames.append(title)
                        }
                    }
                }
            }
        }
        
        return statNames
    }
    
    func delete() {
        for firstRowOption in firstRowOptions {
            realm?.delete(firstRowOption)
        }
        
        for secondRowOption in secondRowOptions {
            realm?.delete(secondRowOption)
        }
        
        realm?.delete(self)
    }
}
