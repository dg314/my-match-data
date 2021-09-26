//
//  ProfilesViewController.swift
//  My Match Data
//
//  Created by David Grossman on 8/8/19.
//  Copyright © 2019 Diagrix. All rights reserved.
//

import UIKit

class ProfilesViewController: UIViewController, UIScrollViewDelegate {
    
    var modalBackgroundView: UIView!
    var scrollView: UIScrollView!
    var madeWithLoveLabel: UILabel!
    var creditLabel: UILabel!
    var portraitButton: UIButton!
    var sponsorsLabel: UILabel!
    var netaButton: UIButton!
    var footerLabel: UILabel!
    
    let creditLabelText = "by David Grossman from Diagrix™"
    let sponsorsLabelText = "and in partnership with the NETA."
    let footerLabelText = "Privacy Policy | Support"
    
    var width: CGFloat!
    var height: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        title = "About"
        
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        modalBackgroundView.backgroundColor = .black
        self.view.addSubview(modalBackgroundView)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        madeWithLoveLabel = UILabel(frame: CGRect(x: width/2 - 180, y: 20, width: 360, height: 100))
        madeWithLoveLabel.textAlignment = .center
        madeWithLoveLabel.textColor = .white
        madeWithLoveLabel.font = UIFont.regular(size: 27)
        madeWithLoveLabel.text = "My Match Data\nwas made with ❤️"
        madeWithLoveLabel.numberOfLines = 0
        scrollView.addSubview(madeWithLoveLabel)
        
        let formattedCreditText = String.format(strings: ["Diagrix™"], boldFont: UIFont.medium(size: 19), boldColor: .highlightedColor, inString: creditLabelText, font: UIFont.regular(size: 19), color: .lightGray)
        
        creditLabel = UILabel(frame: CGRect(x: width/2 - 170, y: 150 + width * 2/5, width: 340, height: 25))
        creditLabel.textAlignment = .center
        creditLabel.textColor = .white
        creditLabel.attributedText = formattedCreditText
        let tap = UITapGestureRecognizer(target: self, action: #selector(creditLabelPressed))
        creditLabel.addGestureRecognizer(tap)
        creditLabel.isUserInteractionEnabled = true
        scrollView.addSubview(creditLabel)
        
        portraitButton = UIButton(frame: CGRect(x: width * 3/10, y: 140, width: width * 2/5, height: width * 2/5))
        portraitButton.setImage(UIImage(named: "portrait"), for: .normal)
        portraitButton.addTarget(self, action: #selector(portraitButtonPressed), for: .touchUpInside)
        scrollView.addSubview(portraitButton)
        
        let formattedSponsorsText = String.format(strings: ["NETA"], boldFont: UIFont.medium(size: 19), boldColor: .highlightedColor, inString: sponsorsLabelText, font: UIFont.regular(size: 19), color: .lightGray)
        
        sponsorsLabel = UILabel(frame: CGRect(x: width/2 - 170, y: 230 + width * 4/5, width: 340, height: 25))
        sponsorsLabel.textAlignment = .center
        sponsorsLabel.textColor = .white
        sponsorsLabel.attributedText = formattedSponsorsText
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(sponsorsLabelPressed))
        sponsorsLabel.addGestureRecognizer(tapTwo)
        sponsorsLabel.isUserInteractionEnabled = true
        scrollView.addSubview(sponsorsLabel)
        
        netaButton = UIButton(frame: CGRect(x: width * 3/10, y: 220 + width * 2/5, width: width * 2/5, height: width * 2/5))
        netaButton.setImage(UIImage(named: "neta_logo"), for: .normal)
        netaButton.addTarget(self, action: #selector(netaButtonPressed), for: .touchUpInside)
        scrollView.addSubview(netaButton)
        
        let formattedFooterText = String.format(strings: ["Privacy Policy", "Support"], boldFont: UIFont.regular(size: 15), boldColor: .highlightedColor, inString: footerLabelText, font: UIFont.regular(size: 15), color: .white)
        
        footerLabel = UILabel(frame: CGRect(x: width/2 - 90, y: 300 + width * 4/5, width: 180, height: 20))
        footerLabel.textAlignment = .center
        footerLabel.textColor = .white
        footerLabel.attributedText = formattedFooterText
        let tapThree = UITapGestureRecognizer(target: self, action: #selector(footerLabelPressed))
        footerLabel.addGestureRecognizer(tapThree)
        footerLabel.isUserInteractionEnabled = true
        scrollView.addSubview(footerLabel)
        
        scrollView.contentSize = CGSize(width: width, height: 400 + width * 4/5)
    }
    
    @objc func creditLabelPressed(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: creditLabel)
        let index = creditLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if index >= 24 {
            if let url = URL(string: "http://diagrix.com/") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func portraitButtonPressed() {
        if let url = URL(string: "http://diagrix.com/about") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func sponsorsLabelPressed(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: sponsorsLabel)
        let index = creditLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if index >= 26 {
            if let url = URL(string: "https://neta.teamapp.com/") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func netaButtonPressed() {
        if let url = URL(string: "https://neta.teamapp.com/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func footerLabelPressed(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: footerLabel)
        let index = footerLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if index <= 16 {
            if let url = URL(string: "http://diagrix.com/privacy-policy") {
                UIApplication.shared.open(url)
            }
        }
        else if index >= 18 {
            if let url = URL(string: "http://diagrix.com/my-match-data") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = UIColor.white
        verticalIndicator?.layer.cornerRadius = (verticalIndicator?.frame.width)!
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
