import UIKit
import RealmSwift

class PresetOption: Object {
    @objc dynamic var presetOptionID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var individualName: String = ""
    @objc dynamic var combinedName: String = ""
    @objc dynamic var individualWonName: String = ""
    @objc dynamic var individualType: Int = 0 // -1 -> not shown, 0 -> count, 1 -> ratio (%) of option to all options
    @objc dynamic var combinedType: Int = -1 // -1 -> not shown, 0 -> count
    @objc dynamic var individualWonType: Int = -1 // -1 -> not shown, 0 -> ratio (%) of option to all options AND ratio (%) of wins to option
    @objc dynamic var flipped: Bool = false
    
    override static func primaryKey() -> String? {
        return "presetOptionID"
    }
}
