//
//  NoteView.swift
//  My Match Data
//
//  Created by David Grossman on 9/1/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    var note: Note!
    
    var gameScoreLineLabel: UILabel!
    var pointScoreLineLabel: UILabel!
    var noteTextView: UITextView!
    var deleteButton: UIButton!
    
    var width: CGFloat!
    var height: CGFloat!

    init(frame: CGRect, note: Note) {
        self.note = note
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        gameScoreLineLabel = UILabel(frame: CGRect(x: 20, y: 0, width: width, height: 25))
        gameScoreLineLabel.textAlignment = .left
        gameScoreLineLabel.text = note.score?.getGamesScoreline(playerOneIsFirst: true)
        gameScoreLineLabel.textColor = .white
        gameScoreLineLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        self.addSubview(gameScoreLineLabel)
        
        pointScoreLineLabel = UILabel(frame: CGRect(x: 30 + gameScoreLineLabel.intrinsicContentSize.width, y: 0, width: 100, height: 25))
        pointScoreLineLabel.textAlignment = .center
        pointScoreLineLabel.text = note.score?.getPointsScoreline(playerOneIsFirst: true)
        pointScoreLineLabel.backgroundColor = .white
        pointScoreLineLabel.textColor = .black
        pointScoreLineLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        pointScoreLineLabel.layer.cornerRadius = 5
        pointScoreLineLabel.layer.masksToBounds = true
        pointScoreLineLabel.frame = CGRect(x: 30 + gameScoreLineLabel.intrinsicContentSize.width, y: 0, width: pointScoreLineLabel.intrinsicContentSize.width + 10, height: 25)
        self.addSubview(pointScoreLineLabel)
        
        noteTextView = UITextView(frame: CGRect(x: 20, y: 35, width: width - 80, height: 1000))
        noteTextView.textAlignment = .left
        noteTextView.backgroundColor = .clear
        noteTextView.textColor = .white
        noteTextView.font = UIFont(name: "AvenirNext-Regular", size: 15)
        noteTextView.text = note.text
        noteTextView.isEditable = false
        noteTextView.isScrollEnabled = false
        noteTextView.textContainerInset = UIEdgeInsets.zero
        noteTextView.textContainer.lineFragmentPadding = 0
        noteTextView.sizeToFit()
        self.addSubview(noteTextView)
        
        deleteButton = UIButton(frame: CGRect(x: width - 50, y: 10, width: 30, height: 30))
        deleteButton.setImage(UIImage(named: "delete_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.tintColor = .lightGray
        deleteButton.layer.cornerRadius = 5
        self.addSubview(deleteButton)
        
        height = noteTextView.frame.height + 60
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteNote() {
        
    }
}
