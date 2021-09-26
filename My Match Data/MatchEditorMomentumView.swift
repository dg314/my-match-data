import UIKit

class MatchEditorMomentumView: UIView {
    var matchEditorView: MatchEditorMainView
    
    var width: CGFloat!
    var height: CGFloat!
    var comingSoonLabel: UILabel!
    
    init(frame: CGRect, matchEditorView: MatchEditorMainView) {
        self.matchEditorView = matchEditorView
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        comingSoonLabel = UILabel(frame: CGRect(x: width/2 - 100, y: height/2 - 15, width: 200, height: 30))
        comingSoonLabel.textAlignment = .center
        comingSoonLabel.textColor = .white
        comingSoonLabel.font = UIFont.regular(size: 25)
        comingSoonLabel.text = "Coming Soon"
        self.addSubview(comingSoonLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
