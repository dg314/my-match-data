//
//  TabBarController.swift
//  My Match Data
//
//  Created by David Grossman on 8/8/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var myMatchesTableViewController: MyMatchesTableViewController!
    var matchSetupViewController: MatchSetupViewController!
    var profilesViewController: ProfilesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        myMatchesTableViewController = MyMatchesTableViewController()
        myMatchesTableViewController.tabBarItem = UITabBarItem(title: "My Matches", image: UIImage(named: "home_icon"), selectedImage: UIImage(named: "home_icon"))
        myMatchesTableViewController.navigationController?.title = "My Matches"
        
        //search
        
        matchSetupViewController = MatchSetupViewController()
        matchSetupViewController.tabBarItem = UITabBarItem(title: "New Match", image: UIImage(named: "new_match_icon"), selectedImage: UIImage(named: "new_match_icon"))
        matchSetupViewController.hidesBottomBarWhenPushed = true
        
        //activity
        
        profilesViewController = ProfilesViewController()
        profilesViewController.tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "about_icon"), selectedImage: UIImage(named: "about_icon"))
        
        self.tabBar.isTranslucent = false
        
        viewControllers = [UINavigationController(rootViewController: myMatchesTableViewController), matchSetupViewController, UINavigationController(rootViewController: profilesViewController)]
        
        //self.navigationController?.navigationBar.barStyle = .black
        //self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.tabBar.barTintColor = .navColor
        self.tabBar.tintColor = .yellow
        self.tabBar.unselectedItemTintColor = .white
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: MatchSetupViewController.self) {
            let matchSetupViewController =  MatchSetupViewController()
            matchSetupViewController.modalPresentationStyle = .fullScreen
            let navigationController = UINavigationController(rootViewController: matchSetupViewController)
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.barTintColor = .navColor
            self.navigationController?.navigationBar.isTranslucent = false
            
            if #available(iOS 13.0, *) {
                navigationController.isModalInPresentation = true
                navigationController.modalPresentationStyle = .fullScreen
            }
            
            self.present(navigationController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
