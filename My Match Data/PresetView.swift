//
//  PresetView.swift
//  My Match Data
//
//  Created by David Grossman on 8/2/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class PresetView: UIView {
    let preset: Preset
    let example: Bool
    let inverted: Bool
    let rows: Int
    
    var titleLabel: UILabel!
    var slider: UISlider!
    var sliderValueLabel: UILabel!
    var segmentedControl: UISegmentedControl!
    var segmentedControlTwo: UISegmentedControl!
    
    var width: CGFloat!
    var height: CGFloat!
    
    init(frame: CGRect, preset: Preset, example: Bool, inverted: Bool) {
        self.preset = preset
        self.example = example
        self.inverted = inverted
        self.rows = preset.numRows()
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height * 3/8))
        titleLabel.textAlignment = .center
        
        if example {
            titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
            titleLabel.text = rows == 0 ? "" : "Preview"
            titleLabel.textColor = .lightGray
        }
        else {
            titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
            titleLabel.text = preset.name
            titleLabel.textColor = .white
        }
        
        if inverted {
            titleLabel.textColor = .black
        }
        
        self.addSubview(titleLabel)
        
        initializeSegmentedControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func segmentedControlChanged(sender: UISegmentedControl) {
        if example {
            sender.selectedSegmentIndex = -1
        }
        
        if !example && !inverted {
            if #available(iOS 13.0, *) {
                sender.selectedSegmentTintColor = .white
                sender.backgroundColor = .gray
            }
            else {
                sender.tintColor = .white
            }
        }
    }
    
    func getValue() -> Int {
        if rows == 1 {
            return segmentedControl.selectedSegmentIndex
        }
        else if rows == 2 {
            if segmentedControl.selectedSegmentIndex == -1 || segmentedControlTwo.selectedSegmentIndex == -1 {
                return -1
            }
            
            return segmentedControl.selectedSegmentIndex + segmentedControlTwo.selectedSegmentIndex * 1000
        }
        
        return -1
    }
    
    func reset() {
        if rows >= 1 {
            segmentedControl.removeFromSuperview()
            
            if rows == 2 {
                segmentedControlTwo.removeFromSuperview()
            }
        }

        initializeSegmentedControls()
    }
    
    func initializeSegmentedControls() {
        if rows >= 1 {
            var firstRowNames: [String] = []
            
            for firstRowOption in preset.firstRowOptions {
                firstRowNames.append(firstRowOption.name)
            }
            
            segmentedControl = UISegmentedControl(items: firstRowNames)
            segmentedControl.frame = CGRect(x: 0, y: height * 3/8, width: width, height: height/2)
            
            if inverted {
                if #available(iOS 13.0, *) {
                    segmentedControl.selectedSegmentTintColor = .black
                    segmentedControl.backgroundColor = .gray
                    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
                }
                else {
                    segmentedControl.tintColor = .black
                }
            }
            else {
                if #available(iOS 13.0, *) {
                    segmentedControl.selectedSegmentTintColor = .white
                    segmentedControl.backgroundColor = .lightGray
                    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
                }
                else {
                    segmentedControl.tintColor = .lightGray
                }
            }

            segmentedControl.isUserInteractionEnabled = !example
            segmentedControl.apportionsSegmentWidthsByContent = true
            segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
            self.addSubview(segmentedControl)
            
            if rows == 2 {
                segmentedControl.frame = CGRect(x: 0, y: height * 3/8, width: width, height: height/4)
                
                var secondRowNames: [String] = []
                
                for secondRowOption in preset.secondRowOptions {
                    secondRowNames.append(secondRowOption.name)
                }
                
                segmentedControlTwo = UISegmentedControl(items: secondRowNames)
                segmentedControlTwo.frame = CGRect(x: 0, y: height * 3/4, width: width, height: height/4)
                
                if inverted {
                    if #available(iOS 13.0, *) {
                        segmentedControlTwo.selectedSegmentTintColor = .black
                        segmentedControlTwo.backgroundColor = .gray
                        segmentedControlTwo.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
                    }
                    else {
                        segmentedControlTwo.tintColor = .black
                    }
                }
                else {
                    if #available(iOS 13.0, *) {
                        segmentedControlTwo.selectedSegmentTintColor = .white
                        segmentedControlTwo.backgroundColor = .lightGray
                        segmentedControlTwo.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
                    }
                    else {
                        segmentedControlTwo.tintColor = .lightGray
                    }
                }
                
                segmentedControlTwo.isUserInteractionEnabled = !example
                segmentedControlTwo.apportionsSegmentWidthsByContent = true
                segmentedControlTwo.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
                self.addSubview(segmentedControlTwo)
            }
        }
    }
}
