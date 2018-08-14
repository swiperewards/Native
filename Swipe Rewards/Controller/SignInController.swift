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


class SignInController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate  {
    var indicator = UIActivityIndicatorView()
    var Input = [String: AnyObject]()
    var fullName = String()
    var getemail = String()
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var ForgotPasswordButton: UIButton!
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
        
        setupUIImages()
        ForceUpdatetoUserAPIWithoutLogin()
    }
    func setupUIImages()  {
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot Password", attributes:attrs as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any])
        attributedString.append(buttonTitleStr)
        ForgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
        
        let fontswipe = FontSwipe()
        let fontswipelogo = FontSwipeLogo()
        EmailIcon.font = fontswipe.fontOfSize(22)
        EmailIcon.text = fontswipe.stringWithName(.Username)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        PasswordIcon.font = fontswipe.fontOfSize(22)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        SwipelogoIcon.font = fontswipelogo.fontOfSize(60)
        SwipelogoIcon.text = fontswipelogo.stringWithName(.Swipelogo)
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
                self.hideLoading()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        
                        self.SignInButton.isUserInteractionEnabled = false
                        self.SignInButton.backgroundColor = UIColor.lightGray
                        self.SignInButton.setTitle("", for: .normal)
                        self.showSpinning()
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
        
        SignInButton.isUserInteractionEnabled = true
        hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Username = fullName
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            //Navigating to Home Dashboard Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
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
        SignInButton.isUserInteractionEnabled = false
        SignInButton.backgroundColor = UIColor.lightGray
        SignInButton.setTitle("", for: .normal)
        showSpinning()
        if let error = error{
            print("\(error.localizedDescription)")} else{
            //
            
            /*
             {
             "deviceId": "268eded3c05cf50e",
             "lat": "",
             "long": "",
             "platform": "Android",
             "requestData":
             {
             "emailId": "vishalb@winjit.com",
             "fullName": "vishal bharati",
             "isSocialLogin": 0,
             "lat": "",
             "long": "",
             "password": "winjit@123"
             }
             }
             */
            
            // let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
             fullName = user.profile.name
            // let givenName = user.profile.givenName
            // let familyName = user.profile.familyName
             getemail = user.profile.email
             //self.emailtext.text = getemail
            var imageURL = ""
            if user.profile.hasImage {
                imageURL = user.profile.imageURL(withDimension: 100).absoluteString
            }
            let url = NSURL(string: imageURL)
            let data = NSData.init(contentsOf: url! as URL)
            if data != nil{//self.editbtnimage.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
            }}
        
        GoogleApiInputBody()
        let signUpServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.signUpURL
        RequestManager.getPath(urlString: signUpServer, params: Input, successBlock:{
            (response) -> () in self.GoogleResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
        
        
        
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
        SignInButton.isUserInteractionEnabled = true
        hideLoading()
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Username = fullName
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            //Navigating to Home Dashboard Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else{}
 }
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!){
       
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!){
       
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: -  Tap Normal  SignIn
    @IBAction func SignInTap(_ sender: Any) {
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
        SignInButton.isUserInteractionEnabled = false
        SignInButton.backgroundColor = UIColor.lightGray
        SignInButton.setTitle("", for: .normal)
        showSpinning()
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
    }
    //MARK: -  Fetching Signup data from server
    func SignInResponse(response: [String : AnyObject]){
        print("SignIn response :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            SignInButton.isUserInteractionEnabled = true
            Constants.Token = response["responseData"]?.value(forKey: "token") as! String
            Constants.Username = response["responseData"]?.value(forKey: "fullName") as! String
            Database.set(Constants.Token, forKey: Constants.Tokenkey)
            Database.set(Constants.Username, forKey: Constants.UsernameKey)
            Database.synchronize()
            
            //Navigating to Home Dashboard Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else{
            SignInButton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Invalid Credentials" , message: "Please check username or password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

            
//            // Email Id already Exists Error
//            Email.attributedPlaceholder = NSAttributedString(string: Constants.errEmailexits, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
//            Email.titleTextColour = UIColor.red
//            EmailIcon.textColor = UIColor.red
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
    
    //MARK: -  Activity Indicator
    func hideLoading(){
        SignInButton.setTitle("Sign In", for: .normal)
        SignInButton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        SignInButton.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: SignInButton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        SignInButton.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: SignInButton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        SignInButton.addConstraint(yCenterConstraint)
    }
    @IBAction func ForgotTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ForgotController = storyboard.instantiateViewController(withIdentifier: "ForgotController")
        self.present(ForgotController, animated: true, completion: nil)
    }
    
}

