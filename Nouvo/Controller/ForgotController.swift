//
//  ForgotController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift


class ForgotController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var Submitbutton: UIButton!
    @IBOutlet weak var BackIcon: UILabel!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var Email: FloatLabelTextField!
    @IBOutlet weak var SwipeLogo: UILabel!
    var indicator = UIActivityIndicatorView()
    var Input = [String: AnyObject]()
    var getemail = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontswipe = FontSwipe()
        let fontNuovo = FontNuovo()
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Username)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        SwipeLogo.font = fontNuovo.fontOfSize(60)
        SwipeLogo.text = fontNuovo.stringWithName(.Nuovo)
        SwipeLogo.textColor = UIColor.white
        BackIcon.font = fontswipe.fontOfSize(20)
        BackIcon.text = fontswipe.stringWithName(.Backarrow)
        BackIcon.textColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    @IBAction func BackTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitPressed(_ sender: Any) {
        
        
        
        
        Email.resignFirstResponder()
        if !NetworkConnectivity.isConnectedToNetwork() {
            let alert = UIAlertController(title: Constants.NetworkerrorTitle , message: Constants.Networkerror, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let fontswipe = FontSwipe()
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        if (Email.text?.isEmpty)! {
            Email.attributedPlaceholder = NSAttributedString(string: Constants.emptyEmail, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Email.titleTextColour = UIColor.red
            EmailIcon.textColor = UIColor.red
            
        }else if !isAllFieldSet() {
            return
        }else{
        ForgotPasswordApiInputBody() //Calling Input API Body for SignIN
        Submitbutton.isUserInteractionEnabled = false
        Submitbutton.backgroundColor = UIColor.lightGray
        Submitbutton.setTitle("", for: .normal)
        showSpinning()
        let ForgotPasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ForgotPasswordURL
        RequestManager.getPath(urlString: ForgotPasswordServer, params: Input, successBlock:{
            (response) -> () in self.ForgotResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}}
        
    }
    func isAllFieldSet() -> Bool {
        if !isValidEmail(testStr: Email.text!) {
            Email.attributedPlaceholder = NSAttributedString(string: Constants.errInvalidEmail, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Email.titleTextColour = UIColor.red
            EmailIcon.textColor = UIColor.red
            return false
            
        }
        else{
            EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Email.attributedPlaceholder = NSAttributedString(string: Constants.Email, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Email.titleTextColour = UIColor.darkGray
            return true
        }
  }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func ForgotPasswordApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        print("deviceid :", deviceid)
        let jsonObject: [String: AnyObject] = [
             "emailId": Email.text as AnyObject
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
            "device_id": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
    }
    //MARK: -  Fetching Signup data from server
    func ForgotResponse(response: [String : AnyObject]){
        print("SignIn response :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            Submitbutton.isUserInteractionEnabled = true
//            let alert = UIAlertController(title: "Successful" , message: "Sent Password reset link to your mail", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
//            { action -> Void in
            
           // })
           
            //self.present(alert, animated: true, completion: nil)
            
            
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view: SetPasswordController = storyboard.instantiateViewController(withIdentifier: "SetPasswordController") as! SetPasswordController
                    view.getemail = Email.text!
                    self.present(view, animated: true, completion: nil)
            
            
            
        }else if success == "1013"{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Failed" , message: "Failed to send Password reset link to your mail", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Failed" , message: "Invalid email address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
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
    /*
     {
     "platform": "android",
     "deviceId": "some string here",
     "lat": "some description here",
     "long": "some web here",
     "requestData":{
     "emailId": "pavanm@winjit.com"
     }
     }
    */
    //MARK: -  Activity Indicator
    func hideLoading(){
        Submitbutton.setTitle("Submit", for: .normal)
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
}
