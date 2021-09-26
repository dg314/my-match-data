import UIKit
import RealmSwift

class MyPoint: Object {
    @objc dynamic var pointID = UUID().uuidString
    @objc dynamic var won: Int = 0
    @objc dynamic var server: Int = 0
    @objc dynamic var score: Score? = Score()
    
    let presetValues = List<Int>()
    let notes = List<Note>()
    
    override static func primaryKey() -> String? {
        return "pointID"
    }
    
    func deleteNote(note: Note) -> Bool {
        for n in 0..<notes.count {
            if notes[n] == note {
                notes.remove(at: n)
                
                realm?.delete(note)
                
                return true
            }
        }
        
        return false
    }
    
    func delete() {
        if score != nil {
            realm?.delete(score!)
        }
        
        for note in notes {
            note.delete()
        }
        
        realm?.delete(self)
    }
}
