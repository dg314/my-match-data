import UIKit
import RealmSwift

class NotesScrollView: UIScrollView, UIScrollViewDelegate {
    var matchEditorView: MatchEditorMainView
    
    var noteViews: [NoteView]!
    
    var realm: Realm!
    
    var width: CGFloat!
    var height: CGFloat!
    
    init(frame: CGRect, matchEditorView: MatchEditorMainView) {
        self.matchEditorView = matchEditorView
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        noteViews = []
        
        populateNotes(notes: matchEditorView.matchEditorViewController.match.getNotes())
        
        showsVerticalScrollIndicator = true
        
        realm = try! Realm()
        
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateNotes(notes: [Note]) {
        var totalHeight = getCurrentHeight()
        
        for note in notes {
            let noteView = NoteView(frame: CGRect(x: 0, y: totalHeight, width: width, height: 1000), note: note)
            noteView.deleteButton.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
            noteViews.append(noteView)
            self.addSubview(noteView)
            
            totalHeight += noteView.height
        }
        
        contentSize = CGSize(width: width, height: totalHeight)
        
        let yOffset = self.contentSize.height - height
        
        if yOffset > 0 {
            setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        }
    }
    
    func addNote(newNote: Note) {
        populateNotes(notes: [newNote])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = .white
        verticalIndicator?.layer.cornerRadius = (verticalIndicator?.frame.width)!
    }
    
    func getCurrentHeight() -> CGFloat {
        var currentHeight: CGFloat = 0
        
        for noteView in noteViews {
            currentHeight += noteView.height
        }
        
        return currentHeight
    }
    
    @objc func deleteNote(sender: UIButton) {
        var heightDecrease: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for n in 0..<noteViews.count {
            if heightDecrease > 0 {
                noteViews[n-1].frame = CGRect(x: 0, y: noteViews[n-1].frame.minY - heightDecrease, width: width, height: noteViews[n-1].height)
                
                totalHeight += noteViews[n-1].height
            }
            else if sender == noteViews[n].deleteButton {
                
                try! realm.write {
                    if !matchEditorView.matchEditorViewController.match.deleteNote(note: noteViews[n].note) {
                        //matchEditorView.matchEditorScoringView.currentPoint.deleteNote(note: noteViews[n].note)
                    }
                }
                
                heightDecrease = noteViews[n].height
                
                noteViews[n].removeFromSuperview()
                noteViews.remove(at: n)
            }
            else {
                totalHeight += noteViews[n].height
            }
        }
        
        contentSize = CGSize(width: width, height: totalHeight)
        
        let yOffset = self.contentSize.height - height + 35
        
        if yOffset > 0 && yOffset < contentOffset.y {
            setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        }
    }
}
