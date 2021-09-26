//
//  StartingServerSetupViewController.swift
//  My Match Data
//
//  Created by David Grossman on 8/10/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit
import CoreData

class StartingServerSetupViewController: UIViewController {
    
    var match: MyMatch!

    var width: CGFloat!
    var height: CGFloat!
    
    var modalBackgroundView: UIView!
    var startingServerLabel: UILabel!
    var startingServerSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        
        title = "Coin Toss"
        
        let continueButton = UIBarButtonItem()
        continueButton.title = "Start Match"
        continueButton.tintColor = .highlightedColor
        continueButton.target = self
        continueButton.action = #selector(nextView)
        continueButton.isEnabled = false
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = continueButton
        
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        modalBackgroundView.backgroundColor = .black
        self.view.addSubview(modalBackgroundView)
        
        let startingServerLabel = UILabel(frame: CGRect(x: 20, y: height/2 - 90, width: width - 40, height: 30))
        startingServerLabel.textAlignment = .center
        startingServerLabel.textColor = .white
        startingServerLabel.font = UIFont(name: "AvenirNext-Regular", size: 25)
        startingServerLabel.text = "Who is serving first?"
        self.view.addSubview(startingServerLabel)
        
        startingServerSegmentedControl = UISegmentedControl(items: [match.getFullPlayerOneName(), match.getFullPlayerTwoName()])
        startingServerSegmentedControl.frame = CGRect(x: 20, y: height/2 - 50, width: width - 40, height: 50)
        
        if #available(iOS 13.0, *) {
            startingServerSegmentedControl.selectedSegmentTintColor = .white
            startingServerSegmentedControl.backgroundColor = .lightGray
            startingServerSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            startingServerSegmentedControl.tintColor = .white
        }
        
        startingServerSegmentedControl.addTarget(self, action: #selector(updateStartingServer), for: .valueChanged)
        self.view.addSubview(startingServerSegmentedControl)
    }
    
    @objc func nextView() {
        match.startingServer = startingServerSegmentedControl.selectedSegmentIndex == 0 ? 1 : -1
        
        self.view.endEditing(true)
        
        let matchEditorViewController = MatchEditorViewController()
        
        matchEditorViewController.match = match
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(matchEditorViewController, animated: false)
    }
    
    @objc func updateStartingServer() {
        if startingServerSegmentedControl.selectedSegmentIndex == 0 {
            if #available(iOS 13.0, *) {
                startingServerSegmentedControl.selectedSegmentTintColor = .playerOneColor
                startingServerSegmentedControl.backgroundColor = .darkPlayerOneColor
            }
            else {
                startingServerSegmentedControl.tintColor = .playerOneColor
            }
        }
        else if startingServerSegmentedControl.selectedSegmentIndex == 1 {
            if #available(iOS 13.0, *) {
                startingServerSegmentedControl.selectedSegmentTintColor = .playerTwoColor
                startingServerSegmentedControl.backgroundColor = .darkPlayerTwoColor
            }
            else {
                startingServerSegmentedControl.tintColor = .playerTwoColor
            }
        }
        
        checkIfCanContinue()
    }
    
    func checkIfCanContinue() {
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = startingServerSegmentedControl.selectedSegmentIndex != -1
    }
}
