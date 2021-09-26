import UIKit
import RealmSwift

class MatchSetupViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    var match: MyMatch!

    var modalBackgroundView: UIView!
    var scrollView: UIScrollView!
    var scrollBackgroundView: UIView!
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var typeLabel: UILabel!
    var typeSegmentedControl: UISegmentedControl!
    var playerOneLabel: UILabel!
    var playerOneTextField: UITextField!
    var partnerOneTextField: UITextField!
    var playerTwoLabel: UILabel!
    var playerTwoTextField: UITextField!
    var partnerTwoTextField: UITextField!
    var sportLabel: UILabel!
    var sportSelectedTextField: UITextField!
    var sportPickerView: UIPickerView!
    var setsLabel: UILabel!
    var setsSegmentedControl: UISegmentedControl!
    var adsLabel: UILabel!
    var adsSegmentedControl: UISegmentedControl!
    var adsYesNoLabel: UILabel!
    var finalSetLabel: UILabel!
    var finalSetSegmentedControl: UISegmentedControl!
    var disclaimerTextView: UITextView!
    
    let sports = ["Tennis"]
    
    var width: CGFloat!
    var height: CGFloat!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        width = self.view.bounds.width
        height = self.view.bounds.height - ((self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0) + (UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height))
        keyboardHeight = 0
        
        match = MyMatch()
        
        title = "Basic Info"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        cancelButton.tintColor = .white
        self.navigationController?.topViewController?.navigationItem.leftBarButtonItem = cancelButton
        
        let continueButton = UIBarButtonItem()
        continueButton.title = "Continue"
        continueButton.tintColor = .highlightedColor
        continueButton.target = self
        continueButton.action = #selector(nextView)
        continueButton.isEnabled = false
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = continueButton
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .navColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        modalBackgroundView.backgroundColor = .black
        self.view.addSubview(modalBackgroundView)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height - 100))
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewPressed))
        scrollView.addGestureRecognizer(tap)
        self.view.addSubview(scrollView)
        
        scrollBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 530))
        scrollBackgroundView.backgroundColor = .black
        scrollView.addSubview(scrollBackgroundView)

        titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: width - 40, height: 20))
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        titleLabel.text = "Title"
        scrollView.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: 20, y: 40, width: width - 40, height: 30))
        titleTextField.backgroundColor = .white
        titleTextField.textColor = .black
        titleTextField.returnKeyType = .done
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        titleTextField.leftViewMode = .always
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.masksToBounds = true
        scrollView.addSubview(titleTextField)
        
        typeLabel = UILabel(frame: CGRect(x: 20, y: 90, width: width - 40, height: 20))
        typeLabel.textAlignment = .left
        typeLabel.textColor = .white
        typeLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        typeLabel.text = "Type"
        scrollView.addSubview(typeLabel)
        
        typeSegmentedControl = UISegmentedControl(items: ["Singles", "Doubles"])
        typeSegmentedControl.frame = CGRect(x: 20, y: 110, width: width - 40, height: 30)
        
        if #available(iOS 13.0, *) {
            typeSegmentedControl.selectedSegmentTintColor = .white
            typeSegmentedControl.backgroundColor = .lightGray
            typeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            typeSegmentedControl.tintColor = .white
        }
        
        typeSegmentedControl.selectedSegmentIndex = 0
        typeSegmentedControl.addTarget(self, action: #selector(updateType), for: .valueChanged)
        scrollView.addSubview(typeSegmentedControl)
        
        playerOneLabel = UILabel(frame: CGRect(x: 20, y: 160, width: width - 40, height: 20))
        playerOneLabel.textAlignment = .left
        playerOneLabel.textColor = .playerOneColor
        playerOneLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        playerOneLabel.text = "Player #1"
        scrollView.addSubview(playerOneLabel)
        
        playerOneTextField = UITextField(frame: CGRect(x: 20, y: 180, width: width - 40, height: 30))
        playerOneTextField.backgroundColor = .white
        playerOneTextField.textColor = .black
        playerOneTextField.returnKeyType = .done
        playerOneTextField.layer.cornerRadius = 5
        playerOneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        playerOneTextField.leftViewMode = .always
        scrollView.addSubview(playerOneTextField)
        
        partnerOneTextField = UITextField(frame: CGRect(x: width/2 + 10, y: 180, width: width/2 - 30, height: 30))
        partnerOneTextField.backgroundColor = .white
        partnerOneTextField.textColor = .black
        partnerOneTextField.returnKeyType = .done
        partnerOneTextField.layer.cornerRadius = 5
        partnerOneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        partnerOneTextField.leftViewMode = .always
        //self.view.addSubview(partnerOneTextField)
        
        playerTwoLabel = UILabel(frame: CGRect(x: 20, y: 230, width: width - 40, height: 20))
        playerTwoLabel.textAlignment = .left
        playerTwoLabel.textColor = .playerTwoColor
        playerTwoLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        playerTwoLabel.text = "Player #2"
        scrollView.addSubview(playerTwoLabel)
        
        playerTwoTextField = UITextField(frame: CGRect(x: 20, y: 250, width: width - 40, height: 30))
        playerTwoTextField.backgroundColor = .white
        playerTwoTextField.textColor = .black
        playerTwoTextField.returnKeyType = .done
        playerTwoTextField.layer.cornerRadius = 5
        playerTwoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        playerTwoTextField.leftViewMode = .always
        scrollView.addSubview(playerTwoTextField)
        
        partnerTwoTextField = UITextField(frame: CGRect(x: width/2 + 10, y: 250, width: width/2 - 30, height: 30))
        partnerTwoTextField.backgroundColor = .white
        partnerTwoTextField.textColor = .black
        partnerTwoTextField.returnKeyType = .done
        partnerTwoTextField.layer.cornerRadius = 5
        partnerTwoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        partnerTwoTextField.leftViewMode = .always
        //self.view.addSubview(partnerTwoTextField)
        
        sportLabel = UILabel(frame: CGRect(x: 20, y: 300, width: width - 40, height: 20))
        sportLabel.textAlignment = .left
        sportLabel.textColor = .white
        sportLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        sportLabel.text = "Sport"
        scrollView.addSubview(sportLabel)
        
        sportSelectedTextField = UITextField(frame: CGRect(x: 20, y: 320, width: width - 40, height: 30))
        sportSelectedTextField.backgroundColor = .white
        sportSelectedTextField.textColor = .black
        sportSelectedTextField.tintColor = .clear
        sportSelectedTextField.layer.cornerRadius = 5
        sportSelectedTextField.text = sports[0]
        sportSelectedTextField.textAlignment = .center
        sportSelectedTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        sportSelectedTextField.leftViewMode = .always
        sportSelectedTextField.rightView = UIImageView(image: UIImage(named: "drop_down_arrow"))
        sportSelectedTextField.rightViewMode = .always
        scrollView.addSubview(sportSelectedTextField)
        
        sportPickerView = UIPickerView(frame: CGRect(x: 0, y: height - 200, width: width, height: 200))
        sportPickerView.backgroundColor = .white
        sportPickerView.tintColor = .black
        sportPickerView.setValue(UIColor.black, forKey: "textColor")
        sportPickerView.setValue(UIColor.black, forKey: "tintColor")
        
        setsLabel = UILabel(frame: CGRect(x: 20, y: 370, width: width * 2/3 - 40, height: 20))
        setsLabel.textAlignment = .left
        setsLabel.textColor = .white
        setsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        setsLabel.text = "Sets"
        scrollView.addSubview(setsLabel)
        
        setsSegmentedControl = UISegmentedControl(items: ["1", "Best 2/3", "Best 3/5"])
        setsSegmentedControl.frame = CGRect(x: 20, y: 390, width: width * 2/3 - 40, height: 30)
        
        if #available(iOS 13.0, *) {
            setsSegmentedControl.selectedSegmentTintColor = .white
            setsSegmentedControl.backgroundColor = .lightGray
            setsSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            setsSegmentedControl.tintColor = .white
        }
        
        setsSegmentedControl.selectedSegmentIndex = 1
        scrollView.addSubview(setsSegmentedControl)
        
        adsLabel = UILabel(frame: CGRect(x: width * 2/3, y: 370, width: width/3 - 20, height: 20))
        adsLabel.textAlignment = .left
        adsLabel.textColor = .white
        adsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        adsLabel.text = "Ads"
        scrollView.addSubview(adsLabel)
        
        adsSegmentedControl = UISegmentedControl(items: ["Yes", "No"])
        adsSegmentedControl.frame = CGRect(x: width * 2/3, y: 390, width: width/3 - 20, height: 30)
        
        if #available(iOS 13.0, *) {
            adsSegmentedControl.selectedSegmentTintColor = .white
            adsSegmentedControl.backgroundColor = .lightGray
            adsSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            adsSegmentedControl.tintColor = .white
        }
        
        adsSegmentedControl.selectedSegmentIndex = 0
        scrollView.addSubview(adsSegmentedControl)
        
        finalSetLabel = UILabel(frame: CGRect(x: 20, y: 440, width: width - 40, height: 20))
        finalSetLabel.textAlignment = .left
        finalSetLabel.textColor = .white
        finalSetLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        finalSetLabel.text = "Final Set"
        scrollView.addSubview(finalSetLabel)
        
        finalSetSegmentedControl = UISegmentedControl(items: ["Superbreaker", "Regular Set", "Extended"])
        finalSetSegmentedControl.frame = CGRect(x: 20, y: 460, width: width - 40, height: 30)
        
        if #available(iOS 13.0, *) {
            finalSetSegmentedControl.selectedSegmentTintColor = .white
            finalSetSegmentedControl.backgroundColor = .lightGray
            finalSetSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            finalSetSegmentedControl.tintColor = .white
        }
        
        finalSetSegmentedControl.selectedSegmentIndex = 1
        scrollView.addSubview(finalSetSegmentedControl)
        
        disclaimerTextView = UITextView(frame: CGRect(x: 20, y: height - 80, width: width - 40, height: 80))
        disclaimerTextView.backgroundColor = .black
        disclaimerTextView.textColor = .white
        disclaimerTextView.textAlignment = .center
        disclaimerTextView.font = UIFont(name: "AvenirNext-Regular", size: 14)
        disclaimerTextView.text = "All of the information is required to continue." //Press the + button to create your own custom preset.
        disclaimerTextView.isEditable = false
        self.view.addSubview(disclaimerTextView)
        
        titleTextField.addTarget(self, action: #selector(checkIfCanContinue), for: .allEditingEvents)
        playerOneTextField.addTarget(self, action: #selector(checkIfCanContinue), for: .allEditingEvents)
        partnerOneTextField.addTarget(self, action: #selector(checkIfCanContinue), for: .allEditingEvents)
        playerTwoTextField.addTarget(self, action: #selector(checkIfCanContinue), for: .allEditingEvents)
        partnerTwoTextField.addTarget(self, action: #selector(checkIfCanContinue), for: .allEditingEvents)
        
        typeSegmentedControl.addTarget(self, action: #selector(checkIfCanContinue), for: .valueChanged)
        
        titleTextField.delegate = self
        playerOneTextField.delegate = self
        partnerOneTextField.delegate = self
        playerTwoTextField.delegate = self
        partnerTwoTextField.delegate = self
        
        sportPickerView.delegate = self
        sportPickerView.dataSource = self
        
        sportSelectedTextField.inputView = sportPickerView
        
        scrollView.contentSize = CGSize(width: width, height: 530)
    }
    
    @objc func cancel() {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextView() {
        match.title = titleTextField.text!
        match.sport = sportSelectedTextField.text!
        match.doubles = typeSegmentedControl.selectedSegmentIndex == 1
        match.playerOneName = playerOneTextField.text!
        match.playerTwoName = playerTwoTextField.text!
        
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            match.partnerOneName = partnerOneTextField.text!
            match.partnerTwoName = partnerTwoTextField.text!
        }
        
        match.scoringType?.sport = sportSelectedTextField.text!
        match.scoringType?.pointsToWinGame = 4
        match.scoringType?.pointLeadToWinGame = 2 - adsSegmentedControl.selectedSegmentIndex
        match.scoringType?.setsToWinMatch = setsSegmentedControl.selectedSegmentIndex + 1
        match.scoringType?.gamesToWinDefaultSet = 6
        match.scoringType?.gameLeadToWinDefaultSet = 2
        match.scoringType?.gamesUntilTiebreakerDefaultSet = 6
        match.scoringType?.pointsToWinTiebreakerDefaultSet = 7
        match.scoringType?.pointLeadToWinTiebreakerDefaultSet = 2

        if finalSetSegmentedControl.selectedSegmentIndex == 0 {
            match.scoringType?.gamesToWinFinalSet = 1
            match.scoringType?.gameLeadToWinFinalSet = 1
            match.scoringType?.gamesUntilTiebreakerFinalSet = 0
            match.scoringType?.pointsToWinTiebreakerFinalSet = 10
            match.scoringType?.pointLeadToWinTiebreakerFinalSet = 2
        }
        else if finalSetSegmentedControl.selectedSegmentIndex == 1 {
            match.scoringType?.gamesToWinFinalSet = 6
            match.scoringType?.gameLeadToWinFinalSet = 2
            match.scoringType?.gamesUntilTiebreakerFinalSet = 6
            match.scoringType?.pointsToWinTiebreakerFinalSet = 7
            match.scoringType?.pointLeadToWinTiebreakerFinalSet = 2
        }
        else {
            match.scoringType?.gamesToWinFinalSet = 6
            match.scoringType?.gameLeadToWinFinalSet = 2
            match.scoringType?.gamesUntilTiebreakerFinalSet = -1
            match.scoringType?.pointsToWinTiebreakerFinalSet = 999
            match.scoringType?.pointLeadToWinTiebreakerFinalSet = 999
        }
        
        self.view.endEditing(true)
        
        let presetSetupViewController = PresetSetupViewController()
        
        presetSetupViewController.match = match
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.pushViewController(presetSetupViewController, animated: false)
    }
    
    @objc func updateType() {
        self.view.endEditing(true)
        
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            playerOneLabel.text = "Player #1"
            playerOneTextField.frame = CGRect(x: 20, y: 180, width: width - 40, height: 30)
            partnerOneTextField.removeFromSuperview()
            
            playerTwoLabel.text = "Player #2"
            playerTwoTextField.frame = CGRect(x: 20, y: 250, width: width - 40, height: 30)
            partnerTwoTextField.removeFromSuperview()
        }
        else {
            playerOneLabel.text = "Team #1"
            playerOneTextField.frame = CGRect(x: 20, y: 180, width: width/2 - 30, height: 30)
            scrollView.addSubview(partnerOneTextField)
            
            playerTwoLabel.text = "Team #2"
            playerTwoTextField.frame = CGRect(x: 20, y: 250, width: width/2 - 30, height: 30)
            scrollView.addSubview(partnerTwoTextField)
        }
    }
    
    @objc func checkIfCanContinue() {
        let couldContinue = self.navigationController!.topViewController!.navigationItem.rightBarButtonItem!.isEnabled
        let canContinue = titleTextField.text! != "" && playerOneTextField.text! != "" && playerTwoTextField.text! != "" && (typeSegmentedControl.selectedSegmentIndex == 0 || (partnerOneTextField.text! != "" && partnerTwoTextField.text! != ""))
        
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = canContinue
        
        if couldContinue && !canContinue {
            self.view.addSubview(disclaimerTextView)
        }
        else if !couldContinue && canContinue {
            disclaimerTextView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func scrollViewPressed() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newScrollY = textField.frame.maxY - height + keyboardHeight! + 80
        
        if newScrollY > scrollView.contentOffset.y {
            scrollView.setContentOffset(CGPoint(x: 0, y: newScrollY), animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sportPickerView {
            return sports.count
        }
        /*else if pickerView == scoringRulesPickerView {
            return scoringRulesOptions.count
        }*/
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        for subview in pickerView.subviews {

            if subview.frame.height <= 5 {
                subview.backgroundColor = .lightGray
                subview.tintColor = .lightGray
            }
        }
        
        
        if pickerView == sportPickerView {
            return sports[row]
        }
        /*else if pickerView == scoringRulesPickerView {
            return scoringRulesOptions[row]
        }*/
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sportPickerView {
            sportSelectedTextField.text = sports[row]
        }
        /*else if pickerView == scoringRulesPickerView {
            scoringRulesSelectedTextField.text = scoringRulesOptions[row]
        }*/
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 24
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
           let rawFrame = (infoKey as AnyObject).cgRectValue {
           let keyboardFrame = view.convert(rawFrame, from: nil)
           keyboardHeight = keyboardFrame.size.height
       }
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
