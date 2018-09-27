//
//  ViewController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 27/06/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//  Facebook Login is Integrated
//  Google SignIn is Integrated

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Fontello_Swift

class SignInController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate  {
    var indicator = UIActivityIndicatorView()
    var Input = [String: AnyObject]()
    var fullName = String()
    var getemail = String()
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet var ForgotPasswordButton: TKTransitionSubmitButton!
    @IBOutlet var Signinbutton: TKTransitionSubmitButton!
    @IBOutlet weak var Email: FloatLabelTextField! //Email Textfield
    @IBOutlet weak var Password: FloatLabelTextField! //Password Textfiled
    var dict : [String : AnyObject]!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var PasswordIcon: UILabel!
    @IBOutlet weak var SwipelogoIcon: UILabel!
     var responseArray = NSArray()
    var attrs = [
      //  kCTFontAttributeName : UIFont.fontNames(forFamilyName: "SF Pro Text Semibold"),
        kCTForegroundColorAttributeName : UIColor.white,
        kCTUnderlineStyleAttributeName : 1] as [CFString : Any]
   var attributedString = NSMutableAttributedString(string:"")
    
    @IBOutlet var Signup: TKTransitionSubmitButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        Signinbutton.setTitle("Sign In",for: .normal)
        Signup.setTitle("Sign Up",for: .normal)
        Signup.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
        
        setupUIImages()
        ForceUpdatetoUserAPIWithoutLogin()
    }
    override func viewWillAppear(_ animated: Bool) {
        Signup.layer.cornerRadius  = 0.0
        Signup.layer.masksToBounds = false
        Signinbutton.layer.cornerRadius  = 0.0
        Signinbutton.layer.masksToBounds = false
        Signinbutton.setTitle("Sign In",for: .normal)
        Signup.setTitle("Sign Up",for: .normal)
        Signup.isUserInteractionEnabled = true
       
    }
    func setupUIImages()  {
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot Password", attributes:attrs as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any])
        attributedString.append(buttonTitleStr)
        ForgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
        
        let fontswipe = FontSwipe()
        let fontNuovo = FontNuovo()
        EmailIcon.font = fontswipe.fontOfSize(22)
        EmailIcon.text = fontswipe.stringWithName(.Username)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        PasswordIcon.font = fontswipe.fontOfSize(22)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        SwipelogoIcon.font = fontNuovo.fontOfSize(60)
        SwipelogoIcon.text = fontNuovo.stringWithName(.Nuovo)
        SwipelogoIcon.textColor = UIColor.white
    }
    func ForceUpdatetoUserAPIWithoutLogin()  {
        ForceUpdateApiInputBody()
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.InitSwipeURL
        RequestManager.getPath(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.ForceUpdateResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func ForceUpdateResponse(response: [String : AnyObject]) {
        print("SignIn response :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
        var generalsettings = [String : AnyObject]()
        generalsettings =  response["responseData"]?.value(forKey: "generalSettings") as! [String : AnyObject]
        let playstoreurl = generalsettings["playStoreURL"] as! String
        print("playstoreurl response :", playstoreurl)
        //itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4
      //  UIApplication.shared.openURL(NSURL(string: playstoreurl)! as URL)
        }else{
        }
    }
    func ForceUpdateApiInputBody()  {
        // Version 1.0
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "device_id": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "appVersionCode": appVersionString as AnyObject
            ]] as [String : AnyObject]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Tap Facebook SignIn
    @IBAction func Facebook(_ sender: Any) {
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
              //  self.hideLoading()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
//
//                        self.SignInButton.isUserInteractionEnabled = false
//                        self.SignInButton.backgroundColor = UIColor.lightGray
//                        self.SignInButton.setTitle("", for: .normal)
                       // self.showSpinning()
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
                   // self.emailtext.text = getemail as? String
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
    
    
    //MARK: -  SignUp API Input Body
    func FacebookApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        // let fullname = firstname.text! + "/" + lastname.text!
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "emailId": self.getemail as AnyObject,
                "fullName": self.fullName as AnyObject,
                "isSocialLogin": "1" as AnyObject,
                "lat": "" as AnyObject,
                "long": "" as AnyObject,
                "password": "" as AnyObject
            ]] as [String : AnyObject]
    }
    func FacebookResponse(response: [String : AnyObject]){
        print("SignUp response :", response)
        
        //SignInButton.isUserInteractionEnabled = true
    //    hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Newrecord = response["responseData"]?.value(forKey: "isNewRecord") as! Int
  
            Constants.Username = fullName
            Constants.GoogleIdentityforchangepassword = "G"
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.set( Constants.GoogleIdentityforchangepassword, forKey:  Constants.GoogleIdentityforchangepasswordkey)
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            Signinbutton.animates(0.5, CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), completion: { () -> () in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
               // self.present(window.rootViewController!, animated: true, completion: nil)
               //  UIView.transition(with: window, duration: 0.1, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                self.navigationController?.pushViewController(window.rootViewController!, animated: true)
                
                
            })
            
        }else{}
    }
    
         //MARK: -  Tap Google SignIn
    @IBAction func GoogleSignin(_ sender: Any) {
        
        
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK: - Google SignIn Delegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if let error = error{
            print("\(error.localizedDescription)")}
        else{
             fullName = user.profile.name
             getemail = user.profile.email
            var imageURL = ""
            if user.profile.hasImage {
                imageURL = user.profile.imageURL(withDimension: 100).absoluteString
            }
            let url = NSURL(string: imageURL)
            let data = NSData.init(contentsOf: url! as URL)
//            SignInButton.isUserInteractionEnabled = false
//            SignInButton.backgroundColor = UIColor.lightGray
//            SignInButton.setTitle("", for: .normal)
//            showSpinning()
            GoogleApiInputBody()
            let signUpServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signUpURL
            RequestManager.getPath(urlString: signUpServer, params: Input, successBlock:{
                (response) -> () in self.GoogleResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in}
            if data != nil{//self.editbtnimage.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
                
                
            }}
        
      
        
        
        
    }
    
    
    //MARK: -  SignUp API Input Body
    func GoogleApiInputBody(){
        
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
       // let fullname = firstname.text! + "/" + lastname.text!
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "emailId": getemail as AnyObject,
                "fullName": fullName as AnyObject,
                "isSocialLogin": "1" as AnyObject,
                "lat": "" as AnyObject,
                "long": "" as AnyObject,
                "password": "" as AnyObject
            ]] as [String : AnyObject]
    }
    func GoogleResponse(response: [String : AnyObject]){
        
        
        
        print("SignUp response :", response)
//        SignInButton.isUserInteractionEnabled = true
//        hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Newrecord = response["responseData"]?.value(forKey: "isNewRecord") as! Int
            Constants.Username = fullName
            Constants.GoogleIdentityforchangepassword = "G"
            Database.set( Constants.GoogleIdentityforchangepassword, forKey:  Constants.GoogleIdentityforchangepasswordkey)
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            
            Signinbutton.animates(0.5, CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), completion: { () -> () in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
                self.navigationController?.pushViewController(window.rootViewController!, animated: true)
              
                
            })
            
           
        }else{
            
        }
 }
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!){
       
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!){
       
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SigninTap(_ sender: TKTransitionSubmitButton) {
        //Check Internet Connectivity
        
        Email.resignFirstResponder()
        Password.resignFirstResponder()
        
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
        SignInApiInputBody() //Calling Input API Body for SignIN
        Signinbutton.isUserInteractionEnabled = false
        
        
        
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signInURL
        RequestManager.getPath(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.SignInResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    
    //MARK: -  SignUp API Input Body
    func SignInApiInputBody(){
         let deviceid = UIDevice.current.identifierForVendor?.uuidString
         print("deviceid :", deviceid)
        Input =  [
            "device_id": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "emailId": Email.text as AnyObject,
                "password": Password.text as AnyObject
            ]] as [String : AnyObject]
        
        print(Input)
//        print(Password.text!)
//        print(Email.text!)
//
//        let script = EncryptionDecryption()
//
//        let constraint1 = script.encryptString(key: "abcdefghijklmnopqrstuvwxyz123456", strInput: "Bharath")
//        print("Encryption :",constraint1)
//
//        let constraint = script.decryptString(key: "abcdefghijklmnopqrstuvwxyz123456", strInput: constraint1)
//        print("Decryption :",constraint)
//        
      
        
        
    }
    //MARK: -  Fetching Signup data from server
    func SignInResponse(response: [String : AnyObject]){
        print("SignIn response :", response)
        print(Input)
        
        
        
        
        
        
        
        Signinbutton.isUserInteractionEnabled = true
        self.Signinbutton.setTitle("Sign In",for: .normal)
        self.Signinbutton.layer.cornerRadius  = 0.0
        self.Signinbutton.layer.masksToBounds = false
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
           
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Username = response["responseData"]?.value(forKey: "fullName") as! String
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            Signinbutton.animates(0.2, CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), completion: { () -> () in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
               self.navigationController?.pushViewController(window.rootViewController!, animated: true)
                
                
            })
            
            
            //Navigating to Home Dashboard Screen
          
        }else{
            Signinbutton.animate(1, CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault), completion: { () -> () in
                let alert = UIAlertController(title: "Invalid Credentials" , message: "Please check username or password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.Signinbutton.setTitle("Sign In",for: .normal)
                self.Signinbutton.layer.cornerRadius  = 0.0
                self.Signinbutton.layer.masksToBounds = false
                
            })
    
        }
        
    }
    func isAllFieldSet() -> Bool {
        let fontswipe = FontSwipe()
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        PasswordIcon.font = fontswipe.fontOfSize(20)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        if (Email.text?.isEmpty)! {
            Email.attributedPlaceholder = NSAttributedString(string: Constants.emptyEmail, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Email.titleTextColour = UIColor.red
            EmailIcon.textColor = UIColor.red
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Password.attributedPlaceholder = NSAttributedString(string: Constants.Password)
            Password.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            return false
        }else if (Password.text?.isEmpty)! {
            Password.attributedPlaceholder = NSAttributedString(string: Constants.emptyPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Password.titleTextColour = UIColor.red
            PasswordIcon.textColor = UIColor.red
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Email.attributedPlaceholder = NSAttributedString(string: Constants.Email)
            Email.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
            
        }else {
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Email.attributedPlaceholder = NSAttributedString(string: Constants.Email, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Email.titleTextColour = UIColor.darkGray
            Password.attributedPlaceholder = NSAttributedString(string: Constants.Password, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Password.titleTextColour = UIColor.darkGray
            return true
        }
        
    }
    //MARK: -  Tap Normal  SignUp
    @IBAction func SignUpTap(_ sender: Any) {
        
        Signinbutton.animates(1, CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), completion: { () -> () in
            
             self.Signup.setTitle("Sign Up",for: .normal)
 })
    }/**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }/**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        }
    
//    //MARK: -  Activity Indicator
//    func hideLoading(){
//        SignInButton.setTitle("Sign In", for: .normal)
//        SignInButton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
//        indicator.stopAnimating()
//    }
//    private func createActivityIndicator() -> UIActivityIndicatorView {
//        indicator.hidesWhenStopped = true
//        indicator.color = UIColor.white
//        return indicator
//    }
//    private func showSpinning() {
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        SignInButton.addSubview(indicator)
//        centerActivityIndicatorInButton()
//        indicator.startAnimating()
//    }
//
//    private func centerActivityIndicatorInButton() {
//        let xCenterConstraint = NSLayoutConstraint(item: SignInButton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
//        SignInButton.addConstraint(xCenterConstraint)
//        let yCenterConstraint = NSLayoutConstraint(item: SignInButton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
//        SignInButton.addConstraint(yCenterConstraint)
//    }
    @IBAction func ForgotTap(_ sender: Any) {
        
       
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ForgotController = storyboard.instantiateViewController(withIdentifier: "ForgotController")
            self.present(ForgotController, animated: true, completion: nil)
        
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.superview?.layer.cornerRadius  = 0.0
        self.view.superview?.layer.masksToBounds = false
    }
    
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        return nil
    }
    
    @IBAction func SignUp(_ sender: TKTransitionSubmitButton) {
        
        Signup.isUserInteractionEnabled = false
        
        sender.animates(0.3, CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), completion: { () -> () in
             self.Signup.setTitle("Sign Up",for: .normal)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ForgotController = storyboard.instantiateViewController(withIdentifier: "SignUpController")
            ForgotController.transitioningDelegate = self
            self.present(ForgotController, animated: true, completion: nil) })
        
    }
}

