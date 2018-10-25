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
import FBSDKLoginKit
import GoogleSignIn

class SignUpController: UIViewController,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate,UIScrollViewDelegate {

    @IBOutlet weak var FieldsView: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet var referralIcon: UILabel!
    @IBOutlet var Referralcode: FloatLabelTextField!
    @IBOutlet var SubmitButton: TKTransitionSubmitButton!
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
    var dict : [String : AnyObject]!
    var fullName = String()
    var getemail = String()
    
    
    //MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sv)
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
       self.hideKeyboardWhenTappedAround()
       let fontswipe = FontSwipe()
       let fontNuovo = FontNuovo()
        Firstnameicon.font = fontswipe.fontOfSize(22)
        Firstnameicon.text = fontswipe.stringWithName(.Username)
        Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        Lastnameicon.font = fontswipe.fontOfSize(22)
        Lastnameicon.text = fontswipe.stringWithName(.Username)
        Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        EmailIcon.font = fontswipe.fontOfSize(22)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        PasswordIcon.font = fontswipe.fontOfSize(22)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        ConfirmPasswordIcon.font = fontswipe.fontOfSize(22)
        ConfirmPasswordIcon.text = fontswipe.stringWithName(.Password)
        ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        referralIcon.font = fontswipe.fontOfSize(22)
        referralIcon.text = fontswipe.stringWithName(.Password)
        referralIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        Swipelogoicon.font = fontNuovo.fontOfSize(60)
        Swipelogoicon.text = fontNuovo.stringWithName(.Nuovo)
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
        sv.endEditing(true)
        contentview.endEditing(true)
        FieldsView.endEditing(true)
        
    }
    
     //MARK: - Signup Button Tap
    @IBAction func SignUpp(_ sender: TKTransitionSubmitButton) {
        confirmpassword.resignFirstResponder()
        password.resignFirstResponder()
        emailid.resignFirstResponder()
        firstname.resignFirstResponder()
        lastname.resignFirstResponder()
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
        sender.isUserInteractionEnabled = false
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
        let jsonObject: [String: AnyObject] = [
            "emailId": emailid.text as AnyObject,
            "fullName": fullname as AnyObject,
            "isSocialLogin": false as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "password": password.text as AnyObject,
            "referredBy": Referralcode.text as AnyObject
        ]
        var encrypted  = String()
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str = String(data: data, encoding: .utf8) {
            print(str)
            // Load only what's necessary
            let AES = CryptoJS.AES()
            // AES encryption
            encrypted = AES.encrypt(str, password: "nn534oj90156fsd584sfs")
            print(encrypted)
        }
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
    }
    func doSomething(action: UIAlertAction) {
    self.dismiss(animated: true, completion: nil)
    }
//MARK: -  Fetching Signup data from server
    func SignupResponse(response: [String : AnyObject]){
        print("SignUp response :", response)
        let encrypted:String = String(format: "%@", response["responseData"] as! String)
        // AES decryption
        let AES = CryptoJS.AES()
        print(AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs"))
        var json = [String : AnyObject]()
        let decrypted = AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs")
        if decrypted == "null"{}
        else{
            let objectData = decrypted.data(using: String.Encoding.utf8)
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]
        SubmitButton.isUserInteractionEnabled = true
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            firstname.text = ""
            lastname.text = ""
            emailid.text = ""
            password.text = ""
            confirmpassword.text = ""
            SubmitButton.layer.cornerRadius  = 0.0
            SubmitButton.layer.masksToBounds = false
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            emailid.attributedPlaceholder = NSAttributedString(string: Constants.Email, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            emailid.titleTextColour = UIColor.darkGray
            SubmitButton.animate(1, CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault), completion: { () -> () in
                let alert = UIAlertController(title: "Success" , message: "Please click on the verification link you received in registered email", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: self.doSomething)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            })
           }else if success == "1096"{
            SubmitButton.layer.cornerRadius  = 0.0
            SubmitButton.layer.masksToBounds = false
            let alert = UIAlertController(title: "Failure" , message: "Invalid referral code", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if success == "1004"{
            SubmitButton.layer.cornerRadius  = 0.0
            SubmitButton.layer.masksToBounds = false
            let alert = UIAlertController(title: "Failure" , message: "Email Already Exists", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            SubmitButton.layer.cornerRadius  = 0.0
            SubmitButton.layer.masksToBounds = false
            let alert = UIAlertController(title: "Failure" , message: "Invalid Credentials", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
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
    
     //MARK: - Tap Google SignIn
    @IBAction func GoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK: - Google SignIn Delegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error.localizedDescription)")} else{
            fullName = user.profile.name
            getemail = user.profile.email
            var imageURL = ""
            if user.profile.hasImage {
                imageURL = user.profile.imageURL(withDimension: 100).absoluteString
            }
            let url = NSURL(string: imageURL)
            let data = NSData.init(contentsOf: url! as URL)
            GoogleApiInputBody()
            let signUpServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signUpURL
            RequestManager.getPath(urlString: signUpServer, params: Input, successBlock:{
                (response) -> () in self.GoogleResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in}
            if data != nil{//self.editbtnimage.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
            }}
    }
    
    //MARK: -  Google API Input Body
    func GoogleApiInputBody(){
        
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
            "emailId": getemail as AnyObject,
            "fullName": fullName as AnyObject,
            "isSocialLogin": "1" as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "password": "" as AnyObject
        ]
        var encrypted  = String()
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str = String(data: data, encoding: .utf8) {
            print(str)
            // Load only what's necessary
            let AES = CryptoJS.AES()
            // AES encryption
            encrypted = AES.encrypt(str, password: "nn534oj90156fsd584sfs")
            print(encrypted)
        }
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
    }
    //MARK: -  Google SignIn Response
    func GoogleResponse(response: [String : AnyObject]){
        print("SignUp response :", response)
        let encrypted:String = String(format: "%@", response["responseData"] as! String)
        // AES decryption
        let AES = CryptoJS.AES()
        print(AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs"))
        var json = [String : AnyObject]()
        let decrypted = AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs")
        if decrypted == "null"{}
        else{
            let objectData = decrypted.data(using: String.Encoding.utf8)
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]
        //  SubmitButton.isUserInteractionEnabled = true
        //  hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            Constants.Token = responses["responseData"]?.value(forKey: "token") as! String
            Constants.Username = fullName
            Constants.GoogleIdentityforchangepassword = "G"
            Constants.Newrecord = responses["responseData"]?.value(forKey: "isNewRecord") as! Int
            Database.set( Constants.GoogleIdentityforchangepassword, forKey:  Constants.GoogleIdentityforchangepasswordkey)
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.synchronize()
            SubmitButton.animates(1, CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), completion: { () -> () in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
                UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                
            })
        }
    }
    //MARK: -  Google Sign Delegates
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!){
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!){
        self.dismiss(animated: true, completion: nil)
    }
     //MARK: - Tap Facebook SignIn
    @IBAction func Facebook(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    //MARK: -  Facebook Data from server
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    self.dict = result as! [String : AnyObject]
                    guard let userInfo = result as? [String: Any]
                    else { return }
                    self.getemail = self.dict["email"] as! String
                    self.fullName = self.dict["name"] as! String
                    print(self.getemail)
                    print(self.fullName)
                    let geteprofilepicture =   ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                    let url = NSURL(string: geteprofilepicture!)
                    let data = NSData.init(contentsOf: url! as URL)
                    if data != nil
                    {
                        //self.Editimagebtn.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
                    }
                    self.FacebookMethod()
                }
            })
        }
    }
    func FacebookMethod()  {
        FacebookApiInputBody()
        let signUpServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signUpURL
        RequestManager.getPath(urlString: signUpServer, params: self.Input, successBlock:{
            (response) -> () in self.FacebookResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    //MARK: -  Facebook API Input Body
    func FacebookApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        // let fullname = firstname.text! + "/" + lastname.text!
        let jsonObject: [String: AnyObject] = [
            "emailId": self.getemail as AnyObject,
            "fullName": self.fullName as AnyObject,
            "isSocialLogin": "1" as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "password": "" as AnyObject
        ]
        var encrypted  = String()
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str = String(data: data, encoding: .utf8) {
            print(str)
            // Load only what's necessary
            let AES = CryptoJS.AES()
            // AES encryption
            encrypted = AES.encrypt(str, password: "nn534oj90156fsd584sfs")
            print(encrypted)
        }
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
    }
     //MARK: - Facebook Server response
    func FacebookResponse(response: [String : AnyObject]){
        print("SignUp response :", response)
        let encrypted:String = String(format: "%@", response["responseData"] as! String)
        // AES decryption
        let AES = CryptoJS.AES()
        print(AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs"))
        var json = [String : AnyObject]()
        let decrypted = AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs")
        if decrypted == "null"{}
        else{
            let objectData = decrypted.data(using: String.Encoding.utf8)
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]
//        SubmitButton.isUserInteractionEnabled = true
//        hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            Constants.Token = responses["responseData"]?.value(forKey: "token") as! String
            Constants.Newrecord = responses["responseData"]?.value(forKey: "isNewRecord") as! Int
            Constants.Username = fullName
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Constants.GoogleIdentityforchangepassword = "G"
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.set( Constants.GoogleIdentityforchangepassword, forKey:  Constants.GoogleIdentityforchangepasswordkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            SubmitButton.animates(1, CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), completion: { () -> () in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
                UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.superview?.layer.cornerRadius  = 0.0
        self.view.superview?.layer.masksToBounds = false
        sv.contentSize = CGSize(width: self.view.frame.size.width, height: 690)
        sv.clipsToBounds = false
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }}
