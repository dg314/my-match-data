import UIKit
import RealmSwift

class Note: Object {
    @objc dynamic var noteID = UUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var score: Score? = Score()
    
    override static func primaryKey() -> String? {
        return "noteID"
    }
    
    func delete() {
        if score != nil {
            realm?.delete(score!)
        }
    }
}
