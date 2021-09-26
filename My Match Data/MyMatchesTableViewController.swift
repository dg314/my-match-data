import UIKit
import RealmSwift

class MyMatchesTableViewController: UITableViewController, UISearchBarDelegate {
    var matches: [MyMatch]!
    var filteredMatches: [MyMatch]!
    var disclaimerTextView: UITextView!
    var timer: Timer!
    
    var realm: Realm!
    
    let id = "matchIdentifier"
    
    var width: CGFloat!
    var height: CGFloat!
    
    var matchSearchBar: UISearchBar!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        width = self.view.bounds.width
        
        title = "My Matches"
        
        self.tableView.backgroundColor = .black
        self.tableView.separatorColor = .lightGray
        
        tableView.register(MyMatchesTableViewCell.self, forCellReuseIdentifier: id)
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
        
        //Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true

        realm = try! Realm()
        
        matches = Array(realm.objects(MyMatch.self)).reversed()
        filteredMatches = matches
        
        matchSearchBar = UISearchBar()
        matchSearchBar.searchBarStyle = .prominent
        matchSearchBar.placeholder = " Search..."
        matchSearchBar.sizeToFit()
        matchSearchBar.isTranslucent = false
        matchSearchBar.backgroundImage = UIImage()
        matchSearchBar.delegate = self
        matchSearchBar.layer.cornerRadius = 15
        matchSearchBar.barStyle = .black
        (matchSearchBar.value(forKey: "searchField") as! UITextField).textColor = .lightGray
        (matchSearchBar.value(forKey: "searchField") as! UITextField).tintColor = .lightGray
        tableView.tableHeaderView = matchSearchBar
        
        disclaimerTextView = UITextView(frame: CGRect(x: 0, y: height - 110, width: width, height: 110))
        disclaimerTextView.backgroundColor = .black
        disclaimerTextView.textColor = .white
        disclaimerTextView.textAlignment = .center
        disclaimerTextView.font = UIFont(name: "AvenirNext-Regular", size: 20)
        disclaimerTextView.text = "Create your first match\n↓"
        disclaimerTextView.isEditable = false
        disclaimerTextView.layer.zPosition = 999
        disclaimerTextView.isHidden = matches.count > 0
        self.view.addSubview(disclaimerTextView)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMatches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyMatchesTableViewCell! = MyMatchesTableViewCell(style: .default, reuseIdentifier: id, match: filteredMatches[indexPath.row], width: width)
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMatches = []
        let substringArray = searchText.split(separator: " ")
        
        for match in matches {
            if substringArray.count == 0 {
                filteredMatches.append(match)
            }
            else {
                var shouldAppend = true
                
                for substring in substringArray {
                    let word = String(substring).lowercased()
                    let bothNames = match.getFullPlayerOneName() + " " + match.getFullPlayerTwoName()
                    
                    if !match.date.lowercased().contains(word) && !match.title.lowercased().contains(word) && !match.sport.lowercased().contains(word) && !bothNames.lowercased().contains(word) {
                        shouldAppend = false
                        break
                    }
                }
                
                if shouldAppend {
                    filteredMatches.append(match)
                }
            }
        }
        
        tableView.reloadData()
        
        disclaimerTextView.isHidden = matches.count > 0
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        disclaimerTextView.frame = CGRect(x: 0, y: height - 110 + scrollView.contentOffset.y, width: width, height: 110)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let matchEditorViewController = MatchEditorViewController()
        
        matchEditorViewController.match = filteredMatches[indexPath.row]
        
        matchEditorViewController.hidesBottomBarWhenPushed = true
        
        //matchEditorViewController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: matchEditorViewController)
        //self.navigationController?.navigationBar.barStyle = .black
        //self.navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
            navigationController.modalPresentationStyle = .fullScreen
        }
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete \(filteredMatches[indexPath.row].title)?", message: "", preferredStyle: .alert)
            areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            areYouSureAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self.filteredMatches[indexPath.row].delete()
                
                self.matches = Array(self.realm.objects(MyMatch.self)).reversed()
                self.filteredMatches.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            self.present(areYouSureAlert, animated: true, completion: nil)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    @objc func update() {
        matches = Array(realm.objects(MyMatch.self)).reversed()
        
        if self != self.topMostViewController() {
            searchBar(matchSearchBar, textDidChange: matchSearchBar.text!)
        }
        
        disclaimerTextView.isHidden = matches.count > 0
    }
}
