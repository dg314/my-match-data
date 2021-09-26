import UIKit

class Scoreboard: UIView {
    var score: Score
    var relSize: CGFloat
    
    var servingIconView: UIView!
    var playerOneNameLabel: UILabel!
    var playerTwoNameLabel: UILabel!
    var playerOnePointLabel: UILabel!
    var playerTwoPointLabel: UILabel!
    var playerOneGamesPerSetLabels: [UILabel]!
    var playerTwoGamesPerSetLabels: [UILabel]!
    
    init(frame: CGRect, score: Score) {
        self.score = score
        self.relSize = UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20
        
        super.init(frame: frame)
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        if score.server > 0 {
            servingIconView = UIView(frame: CGRect(x: 0, y: height/2 - 13 - relSize * 3/4, width: 5, height: 10 + relSize/2))
        }
        else {
            servingIconView = UIView(frame: CGRect(x: 0, y: height/2 + 2 + relSize/4, width: 5, height: 10 + relSize/2))
        }
        
        servingIconView.backgroundColor = .highlightedColor
        servingIconView.isHidden = abs(score.winningState) == 2
        self.addSubview(servingIconView)
        
        playerOneNameLabel = UILabel(frame: CGRect(x: 10, y: height/2 - relSize - 10, width: width - relSize - 55 - CGFloat(score.gamesPerSetPlayerOne.count) * (relSize + 10), height: relSize + 5))
        playerOneNameLabel.textAlignment = .left
        playerOneNameLabel.textColor = .playerOneColor
        playerOneNameLabel.font = UIFont.regular(size: relSize)
        playerOneNameLabel.text = score.fullPlayerOneName
        playerOneNameLabel.adjustsFontSizeToFitWidth = true
        playerOneNameLabel.minimumScaleFactor = 0.6
        self.addSubview(playerOneNameLabel)
        
        playerTwoNameLabel = UILabel(frame: CGRect(x: 10, y: height/2 + 5, width: width - relSize - 55 - CGFloat(score.gamesPerSetPlayerOne.count) * (relSize + 10), height: relSize + 5))
        playerTwoNameLabel.textAlignment = .left
        playerTwoNameLabel.textColor = .playerTwoColor
        playerTwoNameLabel.font = UIFont.regular(size: relSize)
        playerTwoNameLabel.text = score.fullPlayerTwoName
        playerTwoNameLabel.adjustsFontSizeToFitWidth = true
        playerTwoNameLabel.minimumScaleFactor = 0.6
        self.addSubview(playerTwoNameLabel)
        
        playerOnePointLabel = UILabel(frame: CGRect(x: width - relSize - 15, y: height/2 - relSize - 10, width: relSize + 15, height: relSize + 5))
        playerOnePointLabel.textAlignment = .center
        
        if abs(score.winningState) < 2 {
            playerOnePointLabel.backgroundColor = .white
            playerOnePointLabel.textColor = UIColor.black
            playerOnePointLabel.font = UIFont.regular(size: relSize)
            playerOnePointLabel.text = score.playerOnePoints
            playerOnePointLabel.layer.masksToBounds = true
            playerOnePointLabel.layer.cornerRadius = 10
        }
        else {
            playerOnePointLabel.textColor = .highlightedColor
            playerOnePointLabel.font = UIFont.regular(size: relSize + 5)
            playerOnePointLabel.text = score.winningState > 0 ? "✓" : ""
        }
        
        self.addSubview(playerOnePointLabel)
        
        playerTwoPointLabel = UILabel(frame: CGRect(x: width - relSize - 15, y: height/2 + 5, width: relSize + 15, height: relSize + 5))
        playerTwoPointLabel.textAlignment = .center
        
        if abs(score.winningState) < 2 {
            playerTwoPointLabel.backgroundColor = .white
            playerTwoPointLabel.textColor = UIColor.black
            playerTwoPointLabel.font = UIFont.regular(size: relSize)
            playerTwoPointLabel.text = score.playerTwoPoints
            playerTwoPointLabel.layer.masksToBounds = true
            playerTwoPointLabel.layer.cornerRadius = 10
        }
        else {
            playerTwoPointLabel.textColor = .highlightedColor
            playerTwoPointLabel.font = UIFont.regular(size: relSize + 5)
            playerTwoPointLabel.text = score.winningState < 0 ? "✓" : ""
        }
        
        self.addSubview(playerTwoPointLabel)
        
        playerOneGamesPerSetLabels = []
        playerTwoGamesPerSetLabels = []
        
        for n in 0..<score.gamesPerSetPlayerOne.count {
            let playerOneGamesPerSetLabel = UILabel(frame: CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 - relSize - 10, width: relSize + 5, height: relSize + 5))
            playerOneGamesPerSetLabel.textAlignment = .center
            playerOneGamesPerSetLabel.textColor = UIColor.white
            playerOneGamesPerSetLabel.font = UIFont.regular(size: relSize)
            playerOneGamesPerSetLabel.text = score.gamesPerSetPlayerOne[n]
            self.addSubview(playerOneGamesPerSetLabel)
            
            playerOneGamesPerSetLabels.append(playerOneGamesPerSetLabel)
            
            let playerTwoGamesPerSetLabel = UILabel(frame: CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 + 5, width: relSize + 5, height: relSize + 5))
            playerTwoGamesPerSetLabel.textAlignment = .center
            playerTwoGamesPerSetLabel.textColor = UIColor.white
            playerTwoGamesPerSetLabel.font = UIFont.regular(size: relSize)
            playerTwoGamesPerSetLabel.text = score.gamesPerSetPlayerTwo[n]
            self.addSubview(playerTwoGamesPerSetLabel)
            
            playerTwoGamesPerSetLabels.append(playerTwoGamesPerSetLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(score: Score) {
        self.score = score
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        if score.server > 0 {
            servingIconView.frame = CGRect(x: 0, y: height/2 - 13 - relSize * 3/4, width: 5, height: 10 + relSize/2)
        }
        else {
            servingIconView.frame = CGRect(x: 0, y: height/2 + 2 + relSize/4, width: 5, height: 10 + relSize/2)
        }
        
        if abs(score.winningState) < 2 {
            playerOnePointLabel.backgroundColor = .white
            playerOnePointLabel.textColor = UIColor.black
            playerOnePointLabel.font = UIFont.regular(size: relSize)
            playerOnePointLabel.text = score.playerOnePoints
            playerOnePointLabel.layer.masksToBounds = true
            playerOnePointLabel.layer.cornerRadius = 10
        }
        else {
            playerOnePointLabel.backgroundColor = .clear
            playerOnePointLabel.textColor = .highlightedColor
            playerOnePointLabel.font = UIFont.regular(size: relSize + 5)
            playerOnePointLabel.text = score.winningState > 0 ? "✓" : ""
        }
        
        servingIconView.isHidden = abs(score.winningState) == 2
        
        if abs(score.winningState) < 2 {
            playerTwoPointLabel.backgroundColor = .white
            playerTwoPointLabel.textColor = UIColor.black
            playerTwoPointLabel.font = UIFont.regular(size: relSize)
            playerTwoPointLabel.text = score.playerTwoPoints
            playerTwoPointLabel.layer.masksToBounds = true
            playerTwoPointLabel.layer.cornerRadius = 10
        }
        else {
            playerTwoPointLabel.backgroundColor = .clear
            playerTwoPointLabel.textColor = .highlightedColor
            playerTwoPointLabel.font = UIFont.regular(size: relSize + 5)
            playerTwoPointLabel.text = score.winningState < 0 ? "✓" : ""
        }
        
        playerOneNameLabel.text = score.fullPlayerOneName
        playerTwoNameLabel.text = score.fullPlayerTwoName
        
        for n in 0..<score.gamesPerSetPlayerOne.count {
            if n < playerOneGamesPerSetLabels.count {
                playerOneGamesPerSetLabels[n].text = score.gamesPerSetPlayerOne[n]
                playerTwoGamesPerSetLabels[n].text = score.gamesPerSetPlayerTwo[n]
                
                if playerOneGamesPerSetLabels.count < score.gamesPerSetPlayerOne.count {
                    playerOneGamesPerSetLabels[n].frame = CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 - relSize - 10, width: relSize + 5, height: relSize + 5)
                    playerTwoGamesPerSetLabels[n].frame = CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 + 5, width: relSize + 5, height: relSize + 5)
                }
            }
            else {
                let playerOneGamesPerSetLabel = UILabel(frame: CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 - relSize - 10, width: relSize + 5, height: relSize + 5))
                playerOneGamesPerSetLabel.textAlignment = .center
                playerOneGamesPerSetLabel.textColor = UIColor.white
                playerOneGamesPerSetLabel.font = UIFont.regular(size: relSize)
                playerOneGamesPerSetLabel.text = score.gamesPerSetPlayerOne[n]
                self.addSubview(playerOneGamesPerSetLabel)
                
                playerOneGamesPerSetLabels.append(playerOneGamesPerSetLabel)
                
                let playerTwoGamesPerSetLabel = UILabel(frame: CGRect(x: width - relSize - 25 + CGFloat(n - score.gamesPerSetPlayerOne.count) * (relSize + 10), y: height/2 + 5, width: relSize + 5, height: relSize + 5))
                playerTwoGamesPerSetLabel.textAlignment = .center
                playerTwoGamesPerSetLabel.textColor = UIColor.white
                playerTwoGamesPerSetLabel.font = UIFont.regular(size: relSize)
                playerTwoGamesPerSetLabel.text = score.gamesPerSetPlayerTwo[n]
                self.addSubview(playerTwoGamesPerSetLabel)
                
                playerTwoGamesPerSetLabels.append(playerTwoGamesPerSetLabel)
                
                playerOneNameLabel.frame = CGRect(x: 10, y: height/2 - relSize - 10, width: width - relSize - 55 - CGFloat(score.gamesPerSetPlayerOne.count) * (relSize + 10), height: relSize + 5)
                playerTwoNameLabel.frame = CGRect(x: 10, y: height/2 + 5, width: width - relSize - 55 - CGFloat(score.gamesPerSetPlayerOne.count) * (relSize + 10), height: relSize + 5)
            }
        }
    }
}
