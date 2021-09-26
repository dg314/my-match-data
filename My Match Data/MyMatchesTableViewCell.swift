//
//  MyMatchesTableViewCell.swift
//  My Match Data
//
//  Created by David Grossman on 8/23/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit
import RealmSwift

class MyMatchesTableViewCell: UITableViewCell {
    
    var match: MyMatch
    
    var width: CGFloat
    
    var sportIconImageView: UIImageView!
    var matchTitleLabel: UILabel!
    var dateLabel: UILabel!
    var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, match: MyMatch, width: CGFloat) {
        self.match = match
        self.width = width
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        sportIconImageView = UIImageView(image: UIImage(named: "tennis_icon")?.withRenderingMode(.alwaysTemplate))
        sportIconImageView.frame = CGRect(x: 20, y: 10, width: 50, height: 50)
        sportIconImageView.tintColor = .white
        self.addSubview(sportIconImageView)
        
        matchTitleLabel = UILabel(frame: CGRect(x: 85, y: 10, width: width - 210, height: 25))
        matchTitleLabel.font = UIFont.regular(size: 20)
        matchTitleLabel.text = match.title
        matchTitleLabel.textColor = .white
        matchTitleLabel.textAlignment = .left
        matchTitleLabel.adjustsFontSizeToFitWidth = true
        matchTitleLabel.minimumScaleFactor = 0.7
        self.addSubview(matchTitleLabel)
        
        dateLabel = UILabel(frame: CGRect(x: width - 120, y: 10, width: 105, height: 20))
        dateLabel.font = UIFont.regular(size: 15)
        dateLabel.text = match.date
        dateLabel.textColor = .lightGray
        dateLabel.textAlignment = .right
        self.addSubview(dateLabel)
        
        scoreLabel = UILabel(frame: CGRect(x: 85, y: 35, width: width - 100, height: 30))
        scoreLabel.font = UIFont.regular(size: 17)
        scoreLabel.text = match.getScore().getScorelineWithNames()
        scoreLabel.textColor = .lightGray
        scoreLabel.textAlignment = .left
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.4
        self.addSubview(scoreLabel)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.selectedBackgroundView = blurEffectView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
