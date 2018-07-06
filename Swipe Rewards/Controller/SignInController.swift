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

class SignInController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate  {
    
    @IBOutlet weak var ForgotPasswordButton: UIButton!
    @IBOutlet weak var Email: FloatLabelTextField! //Email Textfield
    @IBOutlet weak var Password: FloatLabelTextField! //Password Textfiled
    var dict : [String : AnyObject]!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var PasswordIcon: UILabel!
    @IBOutlet weak var SwipelogoIcon: UILabel!
    
    
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
        
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot Password", attributes:attrs as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any])
        attributedString.append(buttonTitleStr)
        ForgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
        
        let fontswipe = FontSwipe()
        let fontswipelogo = FontSwipeLogo()
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Username)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PasswordIcon.font = fontswipe.fontOfSize(20)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        SwipelogoIcon.font = fontswipelogo.fontOfSize(60)
        SwipelogoIcon.text = fontswipelogo.stringWithName(.Swipelogo)
        SwipelogoIcon.textColor = UIColor.white
        
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
                   // let getemail = self.dict["email"]
                   // print(getemail!)
                    let geteprofilepicture =   ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                   // self.emailtext.text = getemail as? String
                    let url = NSURL(string: geteprofilepicture!)
                    let data = NSData.init(contentsOf: url! as URL)
                    if data != nil
                    {
                        //self.Editimagebtn.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
                    }
                    
                }
            })
        }
    }
         //MARK: -  Tap Google SignIn
    @IBAction func GoogleSignin(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK: - Google SignIn Delegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error.localizedDescription)")} else{
            //
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            // let getemail = user.profile.email
            // self.emailtext.text = getemail
            var imageURL = ""
            if user.profile.hasImage {
                imageURL = user.profile.imageURL(withDimension: 100).absoluteString
            }
            let url = NSURL(string: imageURL)
            let data = NSData.init(contentsOf: url! as URL)
            if data != nil{//self.editbtnimage.setImage(UIImage(data:data! as Data) , for: UIControlState.normal)
            }}
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!){
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

