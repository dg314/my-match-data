import UIKit

class StatList {
    var title: String
    var stats: [Stat]
    
    init(title: String, stats: [Stat]) {
        self.title = title
        self.stats = stats
    }
    
    convenience init() {
        self.init(title: "", stats: [])
    }
}
