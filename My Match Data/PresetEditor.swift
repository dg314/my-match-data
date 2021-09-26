//
//  PresetEditor.swift
//  My Match Data
//
//  Created by David Grossman on 8/2/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class PresetEditor: UIView {
    var presets: [Preset]
    var gap: CGFloat
    
    var presetViews: [PresetView]!
    
    var width: CGFloat!
    var height: CGFloat!
    
    init(frame: CGRect, presets: [Preset], gap: CGFloat) {
        self.presets = presets
        self.gap = gap
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        presetViews = []
        
        for preset in 0..<presets.count {
            let presetView = PresetView(frame: CGRect(x: 0, y: CGFloat(preset) * gap, width: width, height: 75), preset: presets[preset], example: false, inverted: false)
            
            presetViews.append(presetView)
            self.addSubview(presetView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        for presetView in presetViews {
            presetView.reset()
        }
    }
}
