//
//  RedeemController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit


class RedeemController: UIViewController,TCPickerViewOutput,UITextFieldDelegate,UIScrollViewDelegate {
    
    @IBOutlet var Level: UILabel!
    @IBOutlet weak var profileimageview: UIImageView!
    @IBOutlet weak var contentview: UIView!
   
    @IBOutlet var Levelmode: UILabel!
    @IBOutlet var Cashback: UILabel!
    @IBOutlet weak var Progressview: LinearProgressView!
    var picker: TCPickerViewInput = TCPickerView()
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var PaytoWhereButton: UIButton!
    @IBOutlet weak var SelectedBankButton: UIButton!
    @IBOutlet weak var SelectedBankDownIcon: UILabel!
    @IBOutlet weak var PaytowhereDownIcon: UILabel!
    @IBOutlet weak var PaytowhereView: UIView!
    @IBOutlet weak var SelectedBankView: UIView!
    @IBOutlet weak var PaymentAccountNoView: UIView!
    @IBOutlet weak var WithdrawalView: UIView!
    @IBOutlet weak var RedeemAmount: UITextField!
    @IBOutlet weak var PaymentAccountNo: UITextField!
    @IBOutlet weak var SelectedBank: UITextField!
    @IBOutlet weak var Paytowhere: UITextField!
    @IBOutlet weak var RedeemView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var CityLocation: UILabel!
    @IBOutlet weak var NameofSwipe: UILabel!
    var Input = [String: AnyObject]()
    
    
    var TotalBankTypearray = [String]()
    var SelectedBankTypearray = [String]()
    
    var TotalBankTypearrayID = [NSNumber]()
    var SelectedBankTypearrayID = [NSNumber]()
    
    
    
    var TotalBankNamearray = [NSArray]()
    var TotalBankNamearrayID = [NSArray]()
    var BankNamelist = [String]()
    
    var PaytoWhereID = NSNumber()
    var SelectedBankID = NSNumber()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        
        Progressview.animationDuration = 0.5
        Progressview.minimumValue = Float(Constants.minlevel)
        Progressview.maximumValue = Float(Constants.maxlevel)
        Progressview.setProgress(Float(Constants.userlevel) , animated: true)
        
        Level.text = String(format: "Level %d", Constants.level)
        Levelmode.text = String(format: "%d/%d", Constants.minlevel,Constants.maxlevel)
        
        
        
        
        
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameofSwipe.text = string2
        Paytowhere.text = ""
        SelectedBank.text = ""
        PaymentAccountNo.text = ""
        RedeemAmount.text = ""
        setupNavigationBar()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        ConnectivityNetworkCheck()
        PaytowhereAPI()
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
       //
        // Do any additional setup after loading the view.
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackOpaque
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.RedeemAmount.inputAccessoryView = doneToolbar
       // self.textField.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction()
    {
        self.RedeemAmount.resignFirstResponder()
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        PaymentAccountNo.resignFirstResponder()
        RedeemAmount.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentview.endEditing(true)
        self.scrollview.endEditing(true)
    }
    func setupNavigationBar()  {
        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:RedeemView.bounds.size.height - (RedeemView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:RedeemView.bounds.size.height - (RedeemView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:RedeemView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        RedeemView.layer.mask = maskLayer
        let fontswipe = FontSwipe()
        SelectedBankDownIcon.font = fontswipe.fontOfSize(20)
        SelectedBankDownIcon.text = fontswipe.stringWithName(.Downarrow)
        SelectedBankDownIcon.textColor = UIColor.darkGray
        PaytowhereDownIcon.font = fontswipe.fontOfSize(20)
        PaytowhereDownIcon.text = fontswipe.stringWithName(.Downarrow)
        PaytowhereDownIcon.textColor = UIColor.darkGray
        RedeemAmount.layer.cornerRadius = 4.0
        RedeemAmount.layer.borderWidth = 0.4
        RedeemAmount.layer.borderColor = UIColor.darkGray.cgColor
        PaytowhereView.layer.cornerRadius = 4.0
        PaytowhereView.layer.borderWidth = 0.4
        PaytowhereView.layer.borderColor = UIColor.darkGray.cgColor
        SelectedBankView.layer.cornerRadius = 4.0
        SelectedBankView.layer.borderWidth = 0.4
        SelectedBankView.layer.borderColor = UIColor.darkGray.cgColor
        PaymentAccountNoView.layer.cornerRadius = 4.0
        PaymentAccountNoView.layer.borderWidth = 0.4
        PaymentAccountNoView.layer.borderColor = UIColor.darkGray.cgColor
        WithdrawalView.layer.cornerRadius = 4.0
        WithdrawalView.layer.borderWidth = 0.4
        WithdrawalView.layer.borderColor = UIColor.darkGray.cgColor
    }
    func ConnectivityNetworkCheck() {
        //Check Internet Connectivity
        if !NetworkConnectivity.isConnectedToNetwork() {
            let alert = UIAlertController(title: Constants.NetworkerrorTitle , message: Constants.Networkerror, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    func PaytowhereAPI()  {
        PaytowhereAPIInputBody()
        let GetredeemServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.GetRedeemURL
        RequestManager.PostPathwithAUTH(urlString: GetredeemServer, params: Input, successBlock:{
            (response) -> () in self.GetRedeemResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func PaytowhereAPIInputBody()  {
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
            ]] as [String : AnyObject]
    }
    func GetRedeemResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
        print("GetRedeemResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            TotalBankTypearray = response["responseData"]?.value(forKey: "mode") as! [String]
            print("TotalBankTypearray  :", TotalBankTypearray)
            
            TotalBankTypearrayID = response["responseData"]?.value(forKey: "modeId") as! [NSNumber]
            print("TotalBankTypearrayID  :", TotalBankTypearrayID)
            
            TotalBankNamearray = response["responseData"]?.value(forKey: "modeOptions") as! [NSArray]
            print("TotalBankNamearray  :", TotalBankNamearray)
            
            TotalBankNamearrayID = response["responseData"]?.value(forKey: "modeOptions") as! [NSArray]
            print("TotalBankNamearrayID  :", TotalBankNamearrayID)
            
            
            
            
            self.Paytowhere.text = TotalBankTypearray[0]
            self.PaytoWhereID = TotalBankTypearrayID[0]
            
            
            SelectedBankTypearray = TotalBankNamearray[0].value(forKey: "name") as! [String]
            SelectedBankTypearrayID = TotalBankNamearrayID[0].value(forKey: "modeSubId") as! [NSNumber]
            print("SelectedBankTypearrayID  :", SelectedBankTypearrayID)
            
            
            self.SelectedBank.text = SelectedBankTypearray[0]
            self.SelectedBankID = self.SelectedBankTypearrayID[0]
            
            
        }else{
        }
   }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
   
        
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }
        else{
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            let data1 = NSData.init(contentsOf: url!)
            if data1 != nil {
                profileimageview.image = UIImage(data:data1! as Data)
                self.profileimageview.contentMode = .scaleAspectFill
                self.profileimageview.layer.borderWidth = 1.0
                self.profileimageview.layer.masksToBounds = false
                self.profileimageview.layer.borderColor = UIColor.white.cgColor
                self.profileimageview.layer.cornerRadius = self.profileimageview.frame.size.width / 2
                self.profileimageview.clipsToBounds = true
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmTap(_ sender: Any) {
        
       //Fields need to verify must, dont forgot
        
       
        let a:Int? = Int(RedeemAmount.text!)
      //  print("Redeem Amont : ",a)
        
        if Paytowhere.text == "" {
            let alert = UIAlertController(title: "Empty Bank" , message: "Please Select Your Bank Type", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if SelectedBank.text == ""{
            let alert = UIAlertController(title: "Empty Bank Name" , message: "Please Select Your Bank Name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if PaymentAccountNo.text == ""{
            let alert = UIAlertController(title: "Empty Address" , message: "Please enter your address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if RedeemAmount.text == "0"{
            let alert = UIAlertController(title: "Redeem" , message: "Redeem amount should be greater than $0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if a! >= 258 {
            let alert = UIAlertController(title: "Redeem" , message: "You can not redeem more than $258", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
        
        RedeemAPIInputBody()
        ConfirmButton.isUserInteractionEnabled = false
        ConfirmButton.backgroundColor = UIColor.lightGray
        ConfirmButton.setTitle("", for: .normal)
        showSpinning()
        let RaiseredeemServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.RaiseRedeemURL
        RequestManager.PostPathwithAUTH(urlString: RaiseredeemServer, params: Input, successBlock:{
            (response) -> () in self.RaiseRedeemResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
        }
        
    }
    func RedeemAPIInputBody(){
        print("PaytoWhereID  :", PaytoWhereID)
       // print("SelectedBankID  :", SelectedBankID)
        
        if self.Paytowhere.text == "Cheque" {
            
            SelectedBankID = 0
        }
        
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "redeemModeId": PaytoWhereID as AnyObject,
                "redeemModeOptionId": SelectedBankID as AnyObject,
                "amount": RedeemAmount.text as AnyObject
            ]] as [String : AnyObject]
        
    }
    func RaiseRedeemResponse(response: [String : AnyObject]){
        print("RaiseRedeemResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            ConfirmButton.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Redeem" , message: "Redeem request generated successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            Paytowhere.text = ""
            SelectedBank.text = ""
            PaymentAccountNo.text = ""
            RedeemAmount.text = ""
            
        }else{
            ConfirmButton.isUserInteractionEnabled = true
            hideLoading()
        }
    }
    @IBAction func SelectedBankTypePressed(_ sender: Any) {
        
        
        if Paytowhere.text == "" {
            let alert = UIAlertController(title: "Redeem" , message: "Please Select Your Bank!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            picker.title = "Redeem"
            Paytowhere.tag = 1
            let values = SelectedBankTypearray.map { TCPickerView.Value(title: $0) }
            picker.values = values
            picker.delegate = self as? TCPickerViewOutput
            picker.selection = .single
            picker.completion = { (selectedIndexes) in
                for i in selectedIndexes {
                    print(values[i].title)
                    self.SelectedBank.text = values[i].title
                    self.SelectedBankID = self.SelectedBankTypearrayID[i]
                }
            }
            picker.show()
        }
     
       
    }
    @IBAction func PaytowherePressed(_ sender: Any) {
        picker.title = "Redeem"
        Paytowhere.tag = 0
        let values = TotalBankTypearray.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                self.Paytowhere.text = values[i].title
                self.PaytoWhereID = self.TotalBankTypearrayID[i]
                
                
                if self.Paytowhere.text == "Cheque" {
                    self.SelectedBank.text = ""
                    self.PaymentAccountNo.text = ""
                    self.SelectedBankButton.isUserInteractionEnabled = false
                    self.SelectedBankDownIcon.isHidden = true
                }else if self.Paytowhere.text == "Bank Account" {
                    self.SelectedBank.text = "Choose Your Bank"
                    self.PaymentAccountNo.text = ""
                    self.SelectedBankButton.isUserInteractionEnabled = true
                    self.SelectedBankDownIcon.isHidden = false
                }
            }
        }
        picker.show()
        
        
      
        
    }
    
    //MARK: TCPickerViewDelegate methods
    
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
        
        if Paytowhere.tag == 0 {
            SelectedBankTypearray = TotalBankNamearray[index].value(forKey: "name") as! [String]
            print("TotalBankNamearray  :", SelectedBankTypearray)
            SelectedBankTypearrayID = TotalBankNamearrayID[index].value(forKey: "modeSubId") as! [NSNumber]
            print("SelectedBankTypearrayID  :", SelectedBankTypearrayID)
            
            
            
            self.Paytowhere.text = TotalBankTypearray[index]
            self.PaytoWhereID = TotalBankTypearrayID[index]
            
            
            if self.Paytowhere.text == "Cheque" {
                self.SelectedBank.text = ""
                self.PaymentAccountNo.text = ""
                self.SelectedBankButton.isUserInteractionEnabled = false
                self.SelectedBankDownIcon.isHidden = true
            }else if self.Paytowhere.text == "Bank Account" {
//                self.SelectedBank.text = "Choose Your Bank"
//                self.PaymentAccountNo.text = ""
//                self.SelectedBankButton.isUserInteractionEnabled = true
//                self.SelectedBankDownIcon.isHidden = false
            }
            else if self.Paytowhere.text == "Cryptocurrency"{
                
                self.SelectedBank.text = SelectedBankTypearray[0]
                self.SelectedBankID = self.SelectedBankTypearrayID[0]
            }
            
        }
       
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }/**
     * Called when the user click on the view (outside the UITextField).
     */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK: -  Expiry On
        if textField == RedeemAmount{
            if range.location == 8 {
                return false}
           
        }
        
        
        return true
    }
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification){
        
        
    
        
        
    //Need to calculate keyboard exact size due to Apple suggestions
   // scrollview.isScrollEnabled = true
    var info = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
    
    scrollview.contentInset = contentInsets
    scrollview.scrollIndicatorInsets = contentInsets
    
//    var aRect : CGRect = self.view.frame
//    aRect.size.height -= keyboardSize!.height
//    if let PaymentAccountNo = self.PaymentAccountNo {
//        if (!aRect.contains(PaymentAccountNo.frame.origin)){
//            scrollview.scrollRectToVisible(PaymentAccountNo.frame, animated: true)
//        }
//    }
}

    @objc func keyboardWillBeHidden(notification: NSNotification){
    //Once keyboard disappears, restore original positions
    var info = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
    scrollview.contentInset = contentInsets
    scrollview.scrollIndicatorInsets = contentInsets
    //self.view.endEditing(true)
    //scrollview.isScrollEnabled = false
}




    //MARK: -  Activity Indicator
    func hideLoading(){
        ConfirmButton.setTitle("Confirm", for: .normal)
        ConfirmButton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        ConfirmButton.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: ConfirmButton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        ConfirmButton.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: ConfirmButton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        ConfirmButton.addConstraint(yCenterConstraint)
    }
}
