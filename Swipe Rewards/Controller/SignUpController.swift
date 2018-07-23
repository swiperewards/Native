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
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let fullname = firstname.text! + "/" + lastname.text!
        var paramDict = [String: AnyObject]()
        paramDict =  [
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
        RequestManager.getPath(urlString: SwipeRewardsAPI.serverURL, params: paramDict, successBlock:{
                (response) -> () in self.loginparseResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    //MARK: -  Tap SignIn
    @IBAction func SignInTap(_ sender: Any) {
    }
    //MARK: -  Fetching Signup data from server
    func loginparseResponse(response: [String : AnyObject]){
        print(response)
    }
    
    

}
