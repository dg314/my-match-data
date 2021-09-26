import UIKit
import RealmSwift

class MatchEditorNotesView: UIView {
    var matchEditorView: MatchEditorMainView
    
    var realm: Realm!
    
    var backgroundView: UIView!
    var notesTextView: UITextView!
    var addNoteButton: UIButton!
    var notesScrollView: NotesScrollView!
    
    var width: CGFloat!
    var height: CGFloat!
    var maxKeyboardHeight: CGFloat!
    
    init(frame: CGRect, matchEditorView: MatchEditorMainView) {
        self.matchEditorView = matchEditorView
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        maxKeyboardHeight = 253
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        let shift = min(160, height - maxKeyboardHeight)
        
        addNoteButton = UIButton(frame: CGRect(x: width - 60, y: 20, width: 40, height: shift - 40))
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.setTitleColor(.black, for: .normal)
        addNoteButton.setTitleColor(.highlightedColor, for: .highlighted)
        addNoteButton.clipsToBounds = true
        addNoteButton.layer.cornerRadius = 5
        addNoteButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        addNoteButton.backgroundColor = .gray
        addNoteButton.isEnabled = false
        addNoteButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        self.addSubview(addNoteButton)
        
        notesTextView = UITextView(frame: CGRect(x: 20, y: 20, width: width - 80, height: shift - 40))
        notesTextView.textAlignment = .left
        notesTextView.backgroundColor = .white
        notesTextView.textColor = .black
        notesTextView.font = UIFont(name: "AvenirNext-Regular", size: 14)
        notesTextView.text = ""
        notesTextView.isEditable = true
        notesTextView.clipsToBounds = true
        notesTextView.layer.cornerRadius = 5
        notesTextView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        notesTextView.layer.masksToBounds = true
        self.addSubview(notesTextView)
        
        notesScrollView = NotesScrollView(frame: CGRect(x: 0, y: shift, width: width, height: height - shift), matchEditorView: matchEditorView)
        self.addSubview(notesScrollView)
        
        notesTextView.delegate = matchEditorView
        
        realm = try! Realm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    @objc func addNote() {
        self.endEditing(true)
        
        let note = Note()
        
        try! realm.write {
            note.text = notesTextView.text!
            note.score = matchEditorView.matchEditorScoringView.currentPoint.score
            
            matchEditorView.matchEditorScoringView.currentPoint.notes.append(note)
        }
        
        notesScrollView.addNote(newNote: note)
        
        notesTextView.text = ""
        
        addNoteButton.isEnabled = false
        
        updateAddNoteButton()
        
        matchEditorView.matchEditorViewController.save()
    }
    
    func updateAddNoteButton() {
        if addNoteButton.isEnabled {
            addNoteButton.backgroundColor = .highlightedColor
        }
        else {
            addNoteButton.backgroundColor = .darkGray
        }
    }
}
