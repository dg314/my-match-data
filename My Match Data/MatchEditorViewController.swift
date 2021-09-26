import UIKit
import RealmSwift

class MatchEditorViewController: UIViewController {
    
    var match: MyMatch!
    
    var realm: Realm!
    
    var sideNavOpen = false
    
    var modalBackgroundView: UIView!
    var matchEditorMainView: MatchEditorMainView!
    var matchEditorSideNavView: MatchEditorSideNavView!
    var sideNavShadingButton: UIButton!
    
    var width: CGFloat!
    var height: CGFloat!
    
    let tabTitles = ["Scoring",
    "Notes", "Stats", "Momentum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        
        title = "Match Editor"
        
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(named: "hamburger_menu_icon"), style: .plain, target: self, action: #selector(updateSideNav))
        hamburgerMenuButton.tintColor = .white
        self.navigationController?.topViewController?.navigationItem.leftBarButtonItem = hamburgerMenuButton
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        modalBackgroundView.backgroundColor = .black
        self.view.addSubview(modalBackgroundView)
        
        matchEditorMainView = MatchEditorMainView(frame: CGRect(x: 0, y: 0, width: width, height: height), matchEditorViewController: self)
        self.view.addSubview(matchEditorMainView)
        
        matchEditorSideNavView = MatchEditorSideNavView(frame: CGRect(x: -width * 3/4, y: 0, width: width * 3/4, height: height), matchEditorViewController: self)
        
        sideNavShadingButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        sideNavShadingButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        sideNavShadingButton.addTarget(self, action: #selector(updateSideNav), for: .touchUpInside)
        
        realm = try! Realm()
        
        save()
    }
    
    @objc func updateSideNav() {
        if self.matchEditorSideNavView.frame == CGRect(x: -self.width * 3/4, y: 0, width: self.width * 3/4, height: self.height) && !sideNavOpen {
            self.view.addSubview(matchEditorSideNavView)
            self.view.addSubview(sideNavShadingButton)
            
            self.navigationController?.topViewController?.navigationItem.leftBarButtonItem?.image = UIImage(named: "hamburger_menu_closed_icon")
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.matchEditorSideNavView.frame = CGRect(x: 0, y: 0, width: self.width * 3/4, height: self.height)
                //self.matchEditorMainView.frame = CGRect(x: self.width * 3/4, y: self.navHeight, width: self.width, height: self.height)
                self.sideNavShadingButton.frame = CGRect(x: self.width * 3/4, y: 0, width: self.width, height: self.height)
            }, completion: { (value: Bool) in
                self.sideNavOpen = true
            })
        }
        else if self.matchEditorSideNavView.frame == CGRect(x: 0, y: 0, width: self.width * 3/4, height: self.height) && sideNavOpen {
            self.navigationController?.topViewController?.navigationItem.leftBarButtonItem?.image = UIImage(named: "hamburger_menu_icon")
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.matchEditorSideNavView.frame = CGRect(x: -self.width * 3/4, y: 0, width: self.width * 3/4, height: self.height)
                //self.matchEditorMainView.frame = CGRect(x: 0, y: self.navHeight, width: self.width, height: self.height)
                self.sideNavShadingButton.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
            }, completion: { (value: Bool) in
                self.sideNavOpen = false
                self.matchEditorSideNavView.removeFromSuperview()
                self.sideNavShadingButton.removeFromSuperview()
            })
        }
    }
    
    func save() {
        realm = try! Realm()
        
        let badScores = realm.objects(Score.self).filter("fullPlayerOneName = ''")
        
        try! realm.write {
            realm.delete(badScores)
            realm!.create(MyMatch.self, value: match as Any, update: .modified)
        }
    }
    
    /*@objc func edit() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true);
    }*/
}

