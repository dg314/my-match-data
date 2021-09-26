//
//  StatsTableViewCell.swift
//  My Match Data
//
//  Created by David Grossman on 9/1/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    var stat: Stat
    
    var width: CGFloat
    
    var statTitleLabel: UILabel!
    var playerOneValueLabel: UILabel!
    var playerTwoValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, stat: Stat, width: CGFloat) {
        self.stat = stat
        self.width = width
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        statTitleLabel = UILabel(frame: CGRect(x: width/4, y: 5, width: width/2, height: 20))
        statTitleLabel.font = UIFont.regular(size: 15)
        statTitleLabel.text = stat.title
        statTitleLabel.textColor = .white
        statTitleLabel.textAlignment = .center
        statTitleLabel.adjustsFontSizeToFitWidth = true
        statTitleLabel.minimumScaleFactor = 0.5
        self.addSubview(statTitleLabel)
        
        playerOneValueLabel = UILabel(frame: CGRect(x: 20, y: 5, width: width/4 - 20, height: 20))
        playerOneValueLabel.font = stat.lead > 0 ? UIFont.medium(size: 15) : UIFont.regular(size: 15)
        playerOneValueLabel.text = stat.playerOneValue
        playerOneValueLabel.textColor = stat.lead > 0 ? .brightPlayerOneColor : .playerOneColor
        playerOneValueLabel.textAlignment = .center
        playerOneValueLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(playerOneValueLabel)
        
        playerTwoValueLabel = UILabel(frame: CGRect(x: width * 3/4, y: 5, width: width/4 - 20, height: 20))
        playerTwoValueLabel.font = stat.lead < 0 ? UIFont.medium(size: 15) : UIFont.regular(size: 15)
        playerTwoValueLabel.text = stat.playerTwoValue
        playerTwoValueLabel.textColor = stat.lead < 0 ? .brightPlayerTwoColor : .playerTwoColor
        playerTwoValueLabel.textAlignment = .center
        playerTwoValueLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(playerTwoValueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
