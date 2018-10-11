//
//  ChangePasswordController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 25/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var confirmpasswordICON: UILabel!
    @IBOutlet weak var newpasswordICON: UILabel!
    @IBOutlet weak var oldpasswordICON: UILabel!
    @IBOutlet weak var OldPassword: FloatLabelTextField!
    @IBOutlet weak var NewPassword: FloatLabelTextField!
    @IBOutlet weak var ConfirmPassword: FloatLabelTextField!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpNavBar()
        let fontswipe = FontSwipe()
        oldpasswordICON.font = fontswipe.fontOfSize(20)
        oldpasswordICON.text = fontswipe.stringWithName(.Password)
        oldpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        newpasswordICON.font = fontswipe.fontOfSize(20)
        newpasswordICON.text = fontswipe.stringWithName(.Password)
        newpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        confirmpasswordICON.font = fontswipe.fontOfSize(20)
        confirmpasswordICON.text = fontswipe.stringWithName(.Password)
        confirmpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
      // Do any additional setup after loading the view.
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "CHANGE PASSWORD"
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        ChangePasswordApiInputBody() //Calling Input API Body for SignUp
        SubmitButton.isUserInteractionEnabled = false
        SubmitButton.backgroundColor = UIColor.lightGray
        SubmitButton.setTitle("", for: .normal)
        showSpinning()
        let ChangePasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ChangePasswordURL
        RequestManager.PostPathwithAUTH(urlString: ChangePasswordServer, params: Input, successBlock:{
        (response) -> () in self.ChangePasswordResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    //MARK: -  SignUp API Input Body
    func ChangePasswordApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
            "oldPassword": OldPassword.text as AnyObject,
            "password": NewPassword.text as AnyObject
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
    //MARK: -  Fetching Signup data from server
    func ChangePasswordResponse(response: [String : AnyObject]){
        print("ChangePassword response :", response)
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
        

        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            SubmitButton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Change Password" , message: "Successfully created a new password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: dosomething)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            
            
            //
         }else{
            SubmitButton.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Change Password" , message: "Invalid password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            hideLoading()
        }
        
    }
    func dosomething(action: UIAlertAction)   {
        self.navigationController?.popViewController(animated: true)
    }
    func isAllFieldSet() -> Bool {
        let fontswipe = FontSwipe()
        oldpasswordICON.font = fontswipe.fontOfSize(20)
        oldpasswordICON.text = fontswipe.stringWithName(.Password)
        newpasswordICON.font = fontswipe.fontOfSize(20)
        newpasswordICON.text = fontswipe.stringWithName(.Password)
        confirmpasswordICON.font = fontswipe.fontOfSize(20)
        confirmpasswordICON.text = fontswipe.stringWithName(.Password)
        
        if (OldPassword.text?.isEmpty)! {
            OldPassword.attributedPlaceholder = NSAttributedString(string: Constants.emptyOldPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            OldPassword.titleTextColour = UIColor.red
            oldpasswordICON.textColor = UIColor.red
            
            newpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NewPassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword)
            NewPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            ConfirmPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            return false
        }else if (NewPassword.text?.isEmpty)! {
            NewPassword.attributedPlaceholder = NSAttributedString(string: Constants.emptynewPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            NewPassword.titleTextColour = UIColor.red
            newpasswordICON.textColor = UIColor.red
            
            oldpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            OldPassword.attributedPlaceholder = NSAttributedString(string: Constants.OldPassword)
            OldPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            confirmpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword)
            ConfirmPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if (ConfirmPassword.text?.isEmpty)! {
            ConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.emptyConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            ConfirmPassword.titleTextColour = UIColor.red
            confirmpasswordICON.textColor = UIColor.red
            
            oldpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            OldPassword.attributedPlaceholder = NSAttributedString(string: Constants.OldPassword)
            OldPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            newpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NewPassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword)
            NewPassword.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if !isValidPassword(testStr: NewPassword.text!) {
            NewPassword.attributedPlaceholder = NSAttributedString(string: Constants.errInvalidPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            NewPassword.titleTextColour = UIColor.red
            NewPassword.textColor = UIColor.red
            return false
            
        }else {
            oldpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            newpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            OldPassword.attributedPlaceholder = NSAttributedString(string: Constants.OldPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            OldPassword.titleTextColour = UIColor.darkGray
            NewPassword.attributedPlaceholder = NSAttributedString(string: Constants.NewPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            NewPassword.titleTextColour = UIColor.darkGray
            confirmpasswordICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.ConfirmPassword, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            ConfirmPassword.titleTextColour = UIColor.darkGray
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
        SubmitButton.setTitle("Sumbit", for: .normal)
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
