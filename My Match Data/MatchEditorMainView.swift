import UIKit

class MatchEditorMainView: UIView, UITextViewDelegate {
    var matchEditorViewController: MatchEditorViewController
    let shift: CGFloat!
    
    var backgroundView: UIView!
    var scoreboard: Scoreboard!
    var tabButtons: [UIButton]!
    var tabDividerView: UIView!
    var tabSelectedView: UIView!
    var matchEditorScoringView: MatchEditorScoringView!
    var matchEditorNotesView: MatchEditorNotesView!
    var matchEditorStatsView: MatchEditorStatsView!
    var matchEditorMomentumView: MatchEditorMomentumView!
    var tabViews: [UIView]!
    
    var width: CGFloat!
    var height: CGFloat!
    
    let tabTitles = ["Scoring",
                     "Notes", "Stats", "Momentum"]

    init(frame: CGRect, matchEditorViewController: MatchEditorViewController) {
        self.matchEditorViewController = matchEditorViewController
        self.shift = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 150
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        tabButtons = []
            
        for n in 0..<tabTitles.count {
            let tabButton = UIButton(frame: CGRect(x: width/4 * CGFloat(n), y: shift * 4/5, width: width/4, height: shift/5))
            tabButton.setTitle(tabTitles[n], for: .normal)
            tabButton.setTitleColor(.lightGray, for: .normal)
            tabButton.setTitleColor(.gray, for: .highlighted)
            tabButton.setTitleColor(.white, for: .selected)
            tabButton.backgroundColor = .clear
            tabButton.titleLabel?.font = UIFont.regular(size: shift/10)
            tabButton.titleLabel?.adjustsFontSizeToFitWidth = true
            tabButton.addTarget(self, action: #selector(updateSelectedTab), for: .touchUpInside)
            
            if n == 0 {
                tabButton.isSelected = true
            }
            
            tabButtons.append(tabButton)
            self.addSubview(tabButton)
        }
        
        tabDividerView = UIView(frame: CGRect(x: 0, y: shift - 1, width: width, height: 1))
        tabDividerView.backgroundColor = .gray
        self.addSubview(tabDividerView)
        
        tabSelectedView = UIView(frame: CGRect(x: 0, y: shift - 2, width: width/4, height: 2))
        tabSelectedView.backgroundColor = .white
        self.addSubview(tabSelectedView)
        
        tabViews = []
        
        matchEditorScoringView = MatchEditorScoringView(frame: CGRect(x: 0, y: shift, width: width, height: height - shift), matchEditorView: self)
        tabViews.append(matchEditorScoringView)
        self.addSubview(matchEditorScoringView)
        
        matchEditorNotesView = MatchEditorNotesView(frame: CGRect(x: width, y: shift, width: width, height: height - shift), matchEditorView: self)
        tabViews.append(matchEditorNotesView)
        
        matchEditorStatsView = MatchEditorStatsView(frame: CGRect(x: width * 2, y: shift, width: width, height: height - shift), matchEditorView: self)
        tabViews.append(matchEditorStatsView)
        
        matchEditorMomentumView = MatchEditorMomentumView(frame: CGRect(x: width * 3, y: shift, width: width, height: height - shift), matchEditorView: self)
        tabViews.append(matchEditorMomentumView)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            scoreboard = Scoreboard(frame: CGRect(x: width/2 - 300, y: 20, width: 600, height: 120), score: matchEditorViewController.match.getScore())
        }
        else {
            scoreboard = Scoreboard(frame: CGRect(x: 20, y: 20, width: width - 40, height: 80), score: matchEditorViewController.match.getScore())
        }
        
        self.addSubview(scoreboard)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateSelectedTab(sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        var selectedIndex = -1
        var wasSelectedIndex = -1
        
        for n in 0..<tabTitles.count {
            if sender == tabButtons[n] {
                sender.isSelected = true
                
                selectedIndex = n
                
                self.addSubview(tabViews[n])
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.tabSelectedView.frame = CGRect(x: self.width/4 * CGFloat(n), y: self.shift - 2, width: self.width/4, height: 2)
                })
            }
            else if tabButtons[n].isSelected {
                tabButtons[n].isSelected = false
                
                wasSelectedIndex = n
            }
        }
        
        for n in 0..<tabTitles.count {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabViews[n].frame = CGRect(x: CGFloat(n - selectedIndex) * self.width, y: self.shift, width: self.width, height: self.height - self.shift)
            }, completion: { (value: Bool) in
                if n == selectedIndex {
                    self.addSubview(self.tabViews[n])
                }
                else if n == wasSelectedIndex {
                    self.tabViews[n].removeFromSuperview()
                }
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        matchEditorNotesView.addNoteButton.isEnabled = textView.text != ""
        matchEditorNotesView.updateAddNoteButton()
    }
}
