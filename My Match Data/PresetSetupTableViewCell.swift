//
//  StatsTableViewCell.swift
//  My Match Data
//
//  Created by David Grossman on 9/1/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class PresetSetupTableViewCell: UITableViewCell {
    
    var preset: Preset
    
    var chosen: Bool
    
    var width: CGFloat
    
    var presetNameLabel: UILabel!
    var previewPresetView: PresetView!
    var statsLabel: UILabel!
    var statsListTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, preset: Preset, width: CGFloat) {
        self.preset = preset
        self.width = width
        self.chosen = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func changeChosen(numChosen: Int) {
        if chosen || numChosen < 3 {
            chosen = !chosen
            
            updateChosen()
        }
    }
    
    func updateChosen() {
        presetNameLabel.removeFromSuperview()
        previewPresetView.removeFromSuperview()
        
        addViews()
    }
    
    func addViews() {
        backgroundColor = chosen ? .lightGray : .black
        
        presetNameLabel = UILabel(frame: CGRect(x: 60, y: 15, width: width - 120, height: 25))
        presetNameLabel.font = UIFont.regular(size: 20)
        presetNameLabel.text = preset.name
        presetNameLabel.textColor = chosen ? .black : .white
        presetNameLabel.textAlignment = .center
        presetNameLabel.adjustsFontSizeToFitWidth = true
        presetNameLabel.minimumScaleFactor = 0.7
        self.addSubview(presetNameLabel)
        
        previewPresetView = PresetView(frame: CGRect(x: 20, y: 50, width: width - 40, height: 55), preset: preset, example: true, inverted: chosen)
        self.addSubview(previewPresetView)
        
        statsLabel = UILabel(frame: CGRect(x: 60, y: 120, width: width - 120, height: 15))
        statsLabel.font = UIFont.regular(size: 15)
        statsLabel.text = "Available Stats"
        statsLabel.textColor = chosen ? .black : .lightGray
        statsLabel.textAlignment = .center
        self.addSubview(statsLabel)
        
        statsListTextView = UITextView(frame: CGRect(x: 20, y: 130, width: width - 40, height: 70))
        statsListTextView.backgroundColor = .clear
        statsListTextView.textColor = chosen ? .black : .lightGray
        statsListTextView.textAlignment = .center
        statsListTextView.isScrollEnabled = false
        statsListTextView.isUserInteractionEnabled = false
        statsListTextView.font = UIFont(name: "AvenirNext-Regular", size: 13)
        
        var statNamesText = ""
        let statNames = preset.getStatNames()
        
        for n in 0..<statNames.count {
            statNamesText += statNames[n]
            
            if n < statNames.count - 1 {
                statNamesText += ", "
            }
        }
        
        statsListTextView.text = statNamesText
        statsListTextView.isEditable = false
        self.addSubview(statsListTextView)
    }
}
