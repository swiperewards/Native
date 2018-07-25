//
//  SignUpController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 03/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
import AFNetworking

class SignUpController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var confirmpassword: FloatLabelTextField!
    @IBOutlet weak var password: FloatLabelTextField!
    @IBOutlet weak var emailid: FloatLabelTextField!
    @IBOutlet weak var lastname: FloatLabelTextField!
    @IBOutlet weak var firstname: FloatLabelTextField!
    @IBOutlet weak var SignInbutton: UIButton!
    @IBOutlet weak var ConfirmPasswordIcon: UILabel!
    @IBOutlet weak var PasswordIcon: UILabel!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var Lastnameicon: UILabel!
    @IBOutlet weak var Firstnameicon: UILabel!
    @IBOutlet weak var Swipelogoicon: UILabel!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    var attrs = [
        //  kCTFontAttributeName : UIFont.fontNames(forFamilyName: "SF Pro Text Semibold"),
        kCTForegroundColorAttributeName : UIColor.white,
        kCTUnderlineStyleAttributeName : 1] as [CFString : Any]
    var attributedString = NSMutableAttributedString(string:"")
    
    
    //MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTitleStr = NSMutableAttributedString(string:"Sign In", attributes:attrs as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any])
        attributedString.append(buttonTitleStr)
        SignInbutton.setAttributedTitle(attributedString, for: .normal)
        
        
        let fontswipe = FontSwipe()
        let fontswipelogo = FontSwipeLogo()
        Firstnameicon.font = fontswipe.fontOfSize(20)
        Firstnameicon.text = fontswipe.stringWithName(.Username)
        Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        Lastnameicon.font = fontswipe.fontOfSize(20)
        Lastnameicon.text = fontswipe.stringWithName(.Username)
        Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        PasswordIcon.font = fontswipe.fontOfSize(20)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        ConfirmPasswordIcon.font = fontswipe.fontOfSize(20)
        ConfirmPasswordIcon.text = fontswipe.stringWithName(.Password)
        ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        Swipelogoicon.font = fontswipelogo.fontOfSize(60)
        Swipelogoicon.text = fontswipelogo.stringWithName(.Swipelogo)
        Swipelogoicon.textColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // //MARK: -  Textfield Keyboard Hides
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: -  Tap SignUp
    @IBAction func SignUpTap(_ sender: Any){
        
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
        
        SignUpApiInputBody() //Calling Input API Body for SignUp
        
        SubmitButton.isUserInteractionEnabled = false
        SubmitButton.backgroundColor = UIColor.lightGray
        SubmitButton.setTitle("", for: .normal)
        showSpinning()
        let signUpServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signUpURL
        RequestManager.getPath(urlString: signUpServer, params: Input, successBlock:{
                (response) -> () in self.SignupResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    
//MARK: -  Tap SignIn
    @IBAction func SignInTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK: -  SignUp API Input Body
    func SignUpApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let fullname = firstname.text! + "/" + lastname.text!
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
            "emailId": emailid.text as AnyObject,
            "fullName": fullname as AnyObject,
            "isSocialLogin": false as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "password": password.text as AnyObject
            ]] as [String : AnyObject]
    }
    
//MARK: -  Fetching Signup data from server
    func SignupResponse(response: [String : AnyObject]){
        print("SignUp response :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
             hideLoading()
            //Navigating to Home Dashboard Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else{
            SubmitButton.isUserInteractionEnabled = true
            hideLoading()
            // Email Id already Exists Error
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.errEmailexits, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            emailid.titleTextColour = UIColor.red
            EmailIcon.textColor = UIColor.red
        }
        
    }
//MARK: -  Checking All Textfield is Empty or not !
    func isAllFieldSet() -> Bool {
        let fontswipe = FontSwipe()
        Firstnameicon.font = fontswipe.fontOfSize(20)
        Firstnameicon.text = fontswipe.stringWithName(.Username)
        Lastnameicon.font = fontswipe.fontOfSize(20)
        Lastnameicon.text = fontswipe.stringWithName(.Username)
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        PasswordIcon.font = fontswipe.fontOfSize(20)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        ConfirmPasswordIcon.font = fontswipe.fontOfSize(20)
        ConfirmPasswordIcon.text = fontswipe.stringWithName(.Password)
        
        
        if (firstname.text?.isEmpty)! {
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.emptyFirstname, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            firstname.titleTextColour = UIColor.red
            Firstnameicon.textColor = UIColor.red
            
            Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.Lastname)
            lastname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email)
            emailid.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            password.attributedPlaceholder = NSAttributedString(string: Constants.Password)
            password.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            return false
            
        }else if (lastname.text?.isEmpty)! {
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.emptyLastname, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            lastname.titleTextColour = UIColor.red
            Lastnameicon.textColor = UIColor.red
            Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.Firstname)
            firstname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email)
            emailid.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            password.attributedPlaceholder = NSAttributedString(string: Constants.Password)
            password.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
            
        }else if (emailid.text?.isEmpty)! {
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.emptyEmail, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            emailid.titleTextColour = UIColor.red
            EmailIcon.textColor = UIColor.red
            Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.Firstname)
            firstname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.Lastname)
            lastname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            password.attributedPlaceholder = NSAttributedString(string: Constants.Password)
            password.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            
            return false
            
        }else if (password.text?.isEmpty)! {
            password.attributedPlaceholder = NSAttributedString(string: Constants.emptyPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            password.titleTextColour = UIColor.red
            PasswordIcon.textColor = UIColor.red
            Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.Firstname)
            firstname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.Lastname)
            lastname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email)
            emailid.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            confirmpassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
            
        }else if (confirmpassword.text?.isEmpty)! {
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.emptyConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            confirmpassword.titleTextColour = UIColor.red
            ConfirmPasswordIcon.textColor = UIColor.red
            Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.Firstname)
            firstname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.Lastname)
            lastname.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email)
            emailid.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            password.attributedPlaceholder = NSAttributedString(string: Constants.Password)
            password.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
            
        }else if !isValidEmail(testStr: emailid.text!) {
        emailid.attributedPlaceholder = NSAttributedString(string: Constants.errInvalidEmail, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        emailid.titleTextColour = UIColor.red
        EmailIcon.textColor = UIColor.red
        return false
            
        } else if !isValidPassword(testStr: password.text!) {
            password.attributedPlaceholder = NSAttributedString(string: Constants.errInvalidPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            password.titleTextColour = UIColor.red
            PasswordIcon.textColor = UIColor.red
            return false
            
        }else if password.text != confirmpassword.text{
            password.attributedPlaceholder = NSAttributedString(string: Constants.errPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            password.titleTextColour = UIColor.red
            PasswordIcon.textColor = UIColor.red
            return false
        }else {
            Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            firstname.attributedPlaceholder = NSAttributedString(string: Constants.Firstname, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            firstname.titleTextColour = UIColor.darkGray
            lastname.attributedPlaceholder = NSAttributedString(string: Constants.Lastname, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            lastname.titleTextColour = UIColor.darkGray
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            emailid.titleTextColour = UIColor.darkGray
            password.attributedPlaceholder = NSAttributedString(string: Constants.Password, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            password.titleTextColour = UIColor.darkGray
            confirmpassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            confirmpassword.titleTextColour = UIColor.darkGray
            return true
        }
    
    }
//MARK: -  Validate Email
    ///
    /// - Parameter testStr: email address
    /// - Returns: email valid or not bool
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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

//MARK: -  Activity Indicator
    func hideLoading(){
        SubmitButton.setTitle("Submit", for: .normal)
        SubmitButton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        SubmitButton.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: SubmitButton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        SubmitButton.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: SubmitButton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        SubmitButton.addConstraint(yCenterConstraint)
    }
    

}
