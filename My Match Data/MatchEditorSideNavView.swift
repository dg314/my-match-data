import UIKit
import RealmSwift
import Realm

class MatchEditorSideNavView: UIView {
    var matchEditorViewController: MatchEditorViewController
    
    var width: CGFloat!
    var height: CGFloat!
    
    var backgroundView: UIView!
    var saveButton: UIButton!
    var exitButton: UIButton!
    var buttons: [UIButton]!
    var dividerViews: [UIView]!
    var disclaimerTextView: UITextView!
    
    var realm: Realm!
    
    let buttonNames = ["Exit"]
    
    init(frame: CGRect, matchEditorViewController: MatchEditorViewController) {
        self.matchEditorViewController = matchEditorViewController
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView.backgroundColor = .lightGray
        self.addSubview(backgroundView)
        
        buttons = []
        dividerViews = []
        
        for n in 0..<buttonNames.count {
            let button = UIButton(frame: CGRect(x: 0, y: CGFloat(n) * 50, width: width, height: 50))
            button.titleLabel?.font = UIFont.regular(size: 16)
            button.contentHorizontalAlignment = .left
            button.setBackgroundColor(color: .lightGray, forState: .normal)
            button.setBackgroundColor(color: .white, forState: .highlighted)
            button.setTitle(buttonNames[n], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: buttonNames[n].lowercased() + "_icon")!.imageWith(newSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .black
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 20)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            buttons.append(button)
            self.addSubview(button)
            
            let dividerView = UIView(frame: CGRect(x: 0, y: 49 + CGFloat(n) * 50, width: width, height: 1))
            dividerView.backgroundColor = .darkGray
            dividerViews.append(dividerView)
            self.addSubview(dividerView)
        }
        
        disclaimerTextView = UITextView(frame: CGRect(x: 20, y: height - 100, width: width - 40, height: 80))
        disclaimerTextView.backgroundColor = .clear
        disclaimerTextView.textColor = .black
        disclaimerTextView.textAlignment = .center
        disclaimerTextView.font = UIFont(name: "AvenirNext-Regular", size: 14)
        disclaimerTextView.text = "All changes are automatically saved to memory." //Press the + button to create your own custom preset.
        disclaimerTextView.isEditable = false
        self.addSubview(disclaimerTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed(sender: UIButton) {
        for n in 0..<buttonNames.count {
            if sender == buttons[n] {
                switch buttonNames[n] {
                case "Exit":
                    areYouSureExit()
                //case "Delete":
                    //areYouSureDelete()
                default:
                    return
                }
            }
        }
    }
    
    func areYouSureExit() {
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to exit?", message: "", preferredStyle: .alert)
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        areYouSureAlert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { action in
            self.exit()
        }))
        matchEditorViewController.present(areYouSureAlert, animated: true, completion: nil)
    }
    
    /*func areYouSureDelete() {
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete \(matchEditorViewController.match.title)?", message: "", preferredStyle: .alert)
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        areYouSureAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.matchEditorViewController.match.delete()
            self.exit()
        }))
        
        matchEditorViewController.present(areYouSureAlert, animated: true, completion: nil)
    }*/
    
    func exit() {
        matchEditorViewController.dismiss(animated: true, completion: nil)
        matchEditorViewController.navigationController?.popViewController(animated: true);
    }
}
