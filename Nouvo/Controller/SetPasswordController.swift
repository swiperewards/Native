//
//  SetPasswordController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 10/08/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Firebase
class SetPasswordController: UIViewController {

    @IBOutlet weak var confirmpassword: FloatLabelTextField!
    @IBOutlet weak var Newpassword: FloatLabelTextField!
    @IBOutlet weak var Passcode: FloatLabelTextField!
    @IBOutlet weak var confirmpasswordicon: UILabel!
    @IBOutlet weak var newpasswordIcon: UILabel!
    @IBOutlet weak var PasscodeIcon: UILabel!
    @IBOutlet weak var backicon: UILabel!
    @IBOutlet weak var swipelogo: UILabel!
    @IBOutlet weak var Submitbutton: UIButton!
    var indicator = UIActivityIndicatorView()
    var Input = [String: AnyObject]()
    var getemail = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontswipe = FontSwipe()
        confirmpasswordicon.font = fontswipe.fontOfSize(20)
        confirmpasswordicon.text = fontswipe.stringWithName(.Password)
        confirmpasswordicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        newpasswordIcon.font = fontswipe.fontOfSize(20)
        newpasswordIcon.text = fontswipe.stringWithName(.Password)
        newpasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        PasscodeIcon.font = fontswipe.fontOfSize(20)
        PasscodeIcon.text = fontswipe.stringWithName(.Password)
        PasscodeIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        let fontNuovo = FontNuovo()
        swipelogo.font = fontNuovo.fontOfSize(60)
        swipelogo.text = fontNuovo.stringWithName(.Nuovo)
        swipelogo.textColor = UIColor.white
        backicon.font = fontswipe.fontOfSize(20)
        backicon.text = fontswipe.stringWithName(.Backarrow)
        backicon.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BackTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SubmitTap(_ sender: Any) {
        //Check Internet Connectivity
        if !NetworkConnectivity.isConnectedToNetwork() {
            let alert = UIAlertController(title: Constants.NetworkerrorTitle , message: Constants.Networkerror, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Check All Input Fields are empty ot not
        if !isAllFieldSet() {
            return
        }
        ResetPasswordApiInputBody() //Calling Input API Body for SignUp
        Submitbutton.isUserInteractionEnabled = false
        Submitbutton.backgroundColor = UIColor.lightGray
        Submitbutton.setTitle("", for: .normal)
        showSpinning()
        let ResetPasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ResetPasswordURL
        RequestManager.PostPathwithAUTH(urlString: ResetPasswordServer, params: Input, successBlock:{
            (response) -> () in self.ResetPasswordResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    //MARK: -  SignUp API Input Body
    func ResetPasswordApiInputBody(){
        print("Email :", getemail)
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "emailId": getemail as AnyObject,
                "resetToken": Passcode.text as AnyObject,
                "password": Newpassword.text as AnyObject
            ]] as [String : AnyObject]
    }
    //MARK: -  Fetching Signup data from server
    func ResetPasswordResponse(response: [String : AnyObject]){
        print("ResetPasswordResponse response :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Success" , message: "Password Created Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            { action -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view: SignInController = storyboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
                self.present(view, animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        }else if success == "1010"{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Failed!" , message: "You are not authorized to reset", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if success == "1011"{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Failed" , message: "Your Token got expired", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if success == "1012"{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Failed" , message: "Invalid Email Address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
//    func dosomething(action: UIAlertAction)   {
//        self.navigationController?.popViewController(animated: true)
//    }
    func isAllFieldSet() -> Bool {
        let fontswipe = FontSwipe()
        PasscodeIcon.font = fontswipe.fontOfSize(20)
        PasscodeIcon.text = fontswipe.stringWithName(.Password)
        newpasswordIcon.font = fontswipe.fontOfSize(20)
        newpasswordIcon.text = fontswipe.stringWithName(.Password)
        confirmpasswordicon.font = fontswipe.fontOfSize(20)
        confirmpasswordicon.text = fontswipe.stringWithName(.Password)
        
        if (Passcode.text?.isEmpty)! {
            Passcode.attributedPlaceholder = NSAttributedString(string: "Passcode is required", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Passcode.titleTextColour = UIColor.red
            PasscodeIcon.textColor = UIColor.red
            
            newpasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Newpassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword)
            Newpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpasswordicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            return false
        }else if (Newpassword.text?.isEmpty)! {
            Newpassword.attributedPlaceholder = NSAttributedString(string: Constants.emptynewPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Newpassword.titleTextColour = UIColor.red
            newpasswordIcon.textColor = UIColor.red
            
            PasscodeIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Passcode.attributedPlaceholder = NSAttributedString(string: "Passcode")
            Passcode.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpasswordicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if (confirmpassword.text?.isEmpty)! {
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.emptyConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            confirmpassword.titleTextColour = UIColor.red
            confirmpasswordicon.textColor = UIColor.red
            
            PasscodeIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Passcode.attributedPlaceholder = NSAttributedString(string: "Passcode")
            Passcode.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            newpasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Newpassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword)
            Newpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if !isValidPassword(testStr: Newpassword.text!) {
            Newpassword.attributedPlaceholder = NSAttributedString(string: Constants.errInvalidPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Newpassword.titleTextColour = UIColor.red
            Newpassword.textColor = UIColor.red
            return false
            
        }else {
            PasscodeIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            newpasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Passcode.attributedPlaceholder = NSAttributedString(string: "Passcode", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Passcode.titleTextColour = UIColor.darkGray
            Newpassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Newpassword.titleTextColour = UIColor.darkGray
            confirmpasswordicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            confirmpassword.titleTextColour = UIColor.darkGray
            return true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }/**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -  Activity Indicator
    func hideLoading(){
        Submitbutton.setTitle("Sumbit", for: .normal)
        Submitbutton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        Submitbutton.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: Submitbutton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        Submitbutton.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: Submitbutton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        Submitbutton.addConstraint(yCenterConstraint)
    }
    //MARK: -  Validate Password
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    
}
