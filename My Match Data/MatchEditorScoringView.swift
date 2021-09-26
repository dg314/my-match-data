import UIKit
import RealmSwift

class MatchEditorScoringView: UIView {
    var matchEditorView: MatchEditorMainView
    var shift: CGFloat
    
    var realm: Realm!
    
    var backgroundView: UIView!
    var currentPoint: MyPoint!
    var presetValues: [Int]!
    var presetEditor: PresetEditor!
    var pointWinnerLabel: UILabel!
    var playerButton: UIButton!
    var opponentButton: UIButton!
    var disabledButtonsView: UIView!
    var disabledButtonsLabel: UILabel!
    var resultLabel: UILabel!
    var scoreLabel: UILabel!
    
    var width: CGFloat!
    var height: CGFloat!
    
    init(frame: CGRect, matchEditorView: MatchEditorMainView) {
        self.matchEditorView = matchEditorView
        self.shift = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 150
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        realm = try! Realm()
        
        if matchEditorView.matchEditorViewController.match.getPoints().isEmpty {
            try! realm.write {
                if let point = matchEditorView.matchEditorViewController.match.addPoint() {
                    currentPoint = point
                }
            }
        }
        else {
            currentPoint = matchEditorView.matchEditorViewController.match.getPoints().last!
        }
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        let minGap = min((height - 110) / 3, 100)
        
        presetEditor = PresetEditor(frame: CGRect(x: 20, y: 10, width: width - 40, height: CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap), presets: Array(matchEditorView.matchEditorViewController.match.presets), gap: minGap)
        
        presetValues = Array(repeating: -1, count: matchEditorView.matchEditorViewController.match.presets.count)
        
        for presetView in presetEditor.presetViews {
            let rows = presetView.preset.numRows()
            
            if rows >= 1 {
                presetView.segmentedControl.addTarget(self, action: #selector(updatePresetValues), for: .valueChanged)
                
                if rows == 2 {
                    presetView.segmentedControlTwo.addTarget(self, action: #selector(updatePresetValues), for: .valueChanged)
                }
            }
        }
        
        self.addSubview(presetEditor)
        
        pointWinnerLabel = UILabel(frame: CGRect(x: 20, y: 10 + CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap, width: width - 40, height: 30))
        pointWinnerLabel.textAlignment = .center
        pointWinnerLabel.textColor = .white
        pointWinnerLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        pointWinnerLabel.text = "Point Winner"
        self.addSubview(pointWinnerLabel)
        
        playerButton = UIButton(frame: CGRect(x: 20, y: 40 + CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap, width: width/2 - 30, height: height - 70 - CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap))
        playerButton.backgroundColor = .playerOneColor
        playerButton.layer.masksToBounds = true
        playerButton.layer.cornerRadius = 20
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            playerButton.titleLabel?.font = UIFont.regular(size: 30)
        }
        else {
            playerButton.titleLabel?.font = UIFont.regular(size: 20)
        }
        
        playerButton.titleLabel?.numberOfLines = 0
        playerButton.titleLabel?.lineBreakMode = .byWordWrapping
        playerButton.titleLabel?.textAlignment = .center
        playerButton.setTitle(matchEditorView.matchEditorViewController.match.getFullPlayerOneName(), for: .normal)
        playerButton.setTitleColor(.black, for: .normal)
        playerButton.setBackgroundColor(color: .playerOneColor, forState: .normal)
        playerButton.setBackgroundColor(color: .darkPlayerOneColor, forState: .highlighted)
        playerButton.addTarget(self, action: #selector(pointWinnerEntered), for: .touchUpInside)
        self.addSubview(playerButton)
        
        opponentButton = UIButton(frame: CGRect(x: width/2 + 10, y: 40 + CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap, width: width/2 - 30, height: height - 70 - CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap))
        opponentButton.layer.masksToBounds = true
        opponentButton.layer.cornerRadius = 20
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            opponentButton.titleLabel?.font = UIFont.regular(size: 30)
        }
        else {
            opponentButton.titleLabel?.font = UIFont.regular(size: 20)
        }
        
        opponentButton.titleLabel?.numberOfLines = 0
        opponentButton.titleLabel?.lineBreakMode = .byWordWrapping
        opponentButton.titleLabel?.textAlignment = .center
        opponentButton.setTitle(matchEditorView.matchEditorViewController.match.getFullPlayerTwoName(), for: .normal)
        opponentButton.setTitleColor(.black, for: .normal)
        opponentButton.setBackgroundColor(color: .playerTwoColor, forState: .normal)
        opponentButton.setBackgroundColor(color: .darkPlayerTwoColor, forState: .highlighted)
        opponentButton.addTarget(self, action: #selector(pointWinnerEntered), for: .touchUpInside)
        opponentButton.isEnabled = matchEditorView.matchEditorViewController.match.didWin() == 0
        self.addSubview(opponentButton)
        
        disabledButtonsView = UIView(frame: CGRect(x: 20, y: 40 + CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap, width: width - 40, height: height - 70 - CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap))
        disabledButtonsView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        disabledButtonsLabel = UILabel(frame: CGRect(x: width/2 - shift * 4/5, y: 40 + CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap, width: shift * 8/5, height: height - 70 - CGFloat(matchEditorView.matchEditorViewController.match.presets.count) * minGap))
        disabledButtonsLabel.textColor = .lightGray
        disabledButtonsLabel.font = UIFont(name: "AvenirNext-Regular", size: shift/10)
        disabledButtonsLabel.text = "All presets must be set before entering point winner."
        disabledButtonsLabel.lineBreakMode = .byWordWrapping
        disabledButtonsLabel.numberOfLines = 0
        disabledButtonsLabel.textAlignment = .center
        
        resultLabel = UILabel(frame: CGRect(x: width/2 - shift, y: height/2 - 35, width: shift * 2, height: 35))
        resultLabel.text = ""
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "AvenirNext-Regular", size: shift/6)
        resultLabel.textColor = .white
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.7
        resultLabel.layer.zPosition = 999
        self.addSubview(resultLabel)
        
        scoreLabel = UILabel(frame: CGRect(x: width/2 - shift, y: height/2, width: shift * 2, height: 35))
        scoreLabel.text = ""
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "AvenirNext-Regular", size: shift/6)
        scoreLabel.textColor = .white
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.7
        scoreLabel.layer.zPosition = 999
        self.addSubview(scoreLabel)
        
        updatePointWinnerButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pointWinnerEntered(sender: UIButton) {
        if matchEditorView.matchEditorViewController.match.didWin() == 0 {
            try! realm.write {
                currentPoint.won = sender == playerButton ? 1 : -1
                
                for presetValue in presetValues {
                    currentPoint.presetValues.append(presetValue)
                }
                
                if let point = matchEditorView.matchEditorViewController.match.addPoint() {
                    currentPoint = point
                }
            }
            
            if matchEditorView.matchEditorViewController.match.didWin() == 0 {
                matchEditorView.scoreboard.update(score: currentPoint.score!)
            }
            else {
                matchEditorView.scoreboard.update(score: matchEditorView.matchEditorViewController.match.getScore())
            }
            
            matchEditorView.matchEditorStatsView.update()
        }
        
        presetValues = Array(repeating: -1, count: matchEditorView.matchEditorViewController.match.presets.count)
        
        presetEditor.reset()
        
        for presetView in presetEditor.presetViews {
            let rows = presetView.preset.numRows()
            
            if rows >= 1 {
                presetView.segmentedControl.addTarget(self, action: #selector(updatePresetValues), for: .valueChanged)
                
                if rows == 2 {
                    presetView.segmentedControlTwo.addTarget(self, action: #selector(updatePresetValues), for: .valueChanged)
                }
            }
        }
        
        updatePointWinnerButtons()
        
        matchEditorView.matchEditorViewController.save()
    }
    
    @objc func updatePresetValues(sender: UISegmentedControl) {
        for n in 0..<presetEditor.presetViews.count {
            if sender == presetEditor.presetViews[n].segmentedControl || sender == presetEditor.presetViews[n].segmentedControlTwo {
                presetValues[n] = presetEditor.presetViews[n].getValue()
            }
        }
        
        updatePointWinnerButtons()
    }
    
    func updatePointWinnerButtons() {
        let matchWon = matchEditorView.matchEditorViewController.match.didWin()
        
        let couldEnterPointWinner = playerButton.isEnabled
        var canEnterPointWinner = matchWon == 0
        
        for presetValue in presetValues {
            if presetValue == -1 {
                canEnterPointWinner = false
            }
        }
        
        playerButton.isEnabled = canEnterPointWinner
        opponentButton.isEnabled = canEnterPointWinner
        
        if couldEnterPointWinner && !canEnterPointWinner {
            self.addSubview(disabledButtonsView)
            self.addSubview(disabledButtonsLabel)
        }
        else if !couldEnterPointWinner && canEnterPointWinner {
            disabledButtonsView.removeFromSuperview()
            disabledButtonsLabel.removeFromSuperview()
        }
        
        if matchWon != 0 {
            disabledButtonsView.frame = CGRect(x: 20, y: 10, width: width - 40, height: height - 20)
            disabledButtonsLabel.text = ""
            resultLabel.text = matchEditorView.matchEditorViewController.match.getScore().getResult()
            scoreLabel.text = matchEditorView.matchEditorViewController.match.getScore().getGamesScorelineInOrder()
        }
    }
}
