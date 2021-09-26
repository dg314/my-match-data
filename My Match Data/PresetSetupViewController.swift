import UIKit

class PresetSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var match: MyMatch!
    
    var defaultPresets: [Preset]!
    var chosenPresets: [Bool]!

    var width: CGFloat!
    var height: CGFloat!
    
    var modalBackgroundView: UIView!
    var disclaimerTextView: UITextView!
    var presetSetupTableView: UITableView!
    
    let id = "presetSetupIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        
        title = "Presets"
        
        defaultPresets = Preset.defaultPresets()
        chosenPresets = Array(repeating: false, count: defaultPresets.count)
        
        let continueButton = UIBarButtonItem()
        continueButton.title = "Continue"
        continueButton.tintColor = .highlightedColor
        continueButton.target = self
        continueButton.action = #selector(nextView)
        continueButton.isEnabled = true
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = continueButton
        
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        modalBackgroundView.backgroundColor = .black
        self.view.addSubview(modalBackgroundView)
        
        disclaimerTextView = UITextView(frame: CGRect(x: 20, y: height - 80, width: width - 40, height: 60))
        disclaimerTextView.backgroundColor = .black
        disclaimerTextView.textColor = .white
        disclaimerTextView.textAlignment = .center
        disclaimerTextView.font = UIFont(name: "AvenirNext-Regular", size: 14)
        disclaimerTextView.text = "Choose which statistics you would like to track for each point of the match. (max of 3 presets)" //Press the + button to create your own custom preset.
        disclaimerTextView.isEditable = false
        self.view.addSubview(disclaimerTextView)
        
        presetSetupTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height - 100), style: .plain)
        presetSetupTableView.backgroundColor = .black
        presetSetupTableView.separatorColor = .white
        presetSetupTableView.showsVerticalScrollIndicator = false
        self.view?.addSubview(presetSetupTableView)
        
        presetSetupTableView.register(PresetSetupTableViewCell.self, forCellReuseIdentifier: id)
        presetSetupTableView.rowHeight = 200
        
        presetSetupTableView.delegate = self
        presetSetupTableView.dataSource = self
    }
    
    @objc func nextView() {
        self.view.endEditing(true)
        
        match.presets.removeAll()
        
        for n in 0..<defaultPresets.count {
            if chosenPresets[n] {
                match.presets.append(defaultPresets[n])
            }
        }
        
        let startingServerSetupViewController = StartingServerSetupViewController()
        
        startingServerSetupViewController.match = match
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.pushViewController(startingServerSetupViewController, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultPresets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PresetSetupTableViewCell! = PresetSetupTableViewCell(style: .default, reuseIdentifier: id, preset: defaultPresets[indexPath.row], width: width)
        
        if chosenPresets[indexPath.row] {
            cell.chosen = true
            cell.updateChosen()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as! PresetSetupTableViewCell? {
            cell.changeChosen(numChosen: numChosen())
            
            chosenPresets[indexPath.row] = cell.chosen
        }
    }
    
    func numChosen() -> Int {
        var num = 0
        
        for preset in chosenPresets {
            if preset {
                num += 1
            }
        }
        
        return num
    }
}
