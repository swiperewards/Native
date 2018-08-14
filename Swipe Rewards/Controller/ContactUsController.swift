//
//  ContactUsController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import  Fontello_Swift
class ContactUsController: UIViewController,TCPickerViewOutput,UITextFieldDelegate,UITextViewDelegate{
    @IBOutlet weak var downIcon: UILabel!
    var indicator = UIActivityIndicatorView()
    var Input = [String: AnyObject]()
    var picker: TCPickerViewInput = TCPickerView()
    @IBOutlet weak var Submitbutton: UIButton!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var TicketType: UITextField!
   var TotalTicketTypearray = [String]()
   var TotalTicketTypearrayID = [NSNumber]()
   var TicketID = NSNumber()
    @IBAction func TicketButotn(_ sender: Any) {
        
        picker.title = "Contact Us"
        let values = TotalTicketTypearray.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                self.TicketType.text = values[i].title
                self.TicketID = self.TotalTicketTypearrayID[i]
            }
        }
        picker.show()
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        if TicketType.text == "" {
            let alert = UIAlertController(title: "Empty Ticket" , message: "Please Select Your Ticket Type", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if Description.text == "Description" || Description.text == ""{
            let alert = UIAlertController(title: "Empty Description" , message: "Please Enter Your Comments", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
        TicketAPIInputBody()
        Submitbutton.isUserInteractionEnabled = false
        Submitbutton.backgroundColor = UIColor.lightGray
        Submitbutton.setTitle("", for: .normal)
        showSpinning()
        let SendTicketServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.SendTicketsURL
        RequestManager.PostPathwithAUTH(urlString: SendTicketServer, params: Input, successBlock:{
            (response) -> () in self.SendTicketServerResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
        }
        
    }
    func TicketAPIInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "ticketTypeId": TicketID as AnyObject,
                "feedback": Description.text as AnyObject,
                "userCategory": "Customer" as AnyObject
            ]] as [String : AnyObject]
        
    }
    func SendTicketServerResponse(response: [String : AnyObject]){
        print("TicketResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            
            let alert = UIAlertController(title: "Contact Us" , message: "Enquiry request generated successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            Submitbutton.isUserInteractionEnabled = true
            TicketType.text = ""
            Description.text = ""
           
            
        }else{
            Submitbutton.isUserInteractionEnabled = true
            hideLoading()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        Description.text = "Description"
        Description.textColor = UIColor.lightGray
        
        Description.clipsToBounds = true;
        Description.layer.cornerRadius = 10.0
        Description.layer.borderWidth = 1.0
        Description.layer.borderColor = UIColor.gray.cgColor
        
        TicketType.layer.cornerRadius = 10.0
        TicketType.layer.borderWidth = 1.0
        TicketType.layer.borderColor = UIColor.gray.cgColor
        
        
        let fontswipe = FontSwipe()
        downIcon.font = fontswipe.fontOfSize(20)
        downIcon.text = fontswipe.stringWithName(.Downarrow)
        downIcon.textColor = UIColor.darkGray
        
        ConnectivityNetworkCheck()
        GetTicketTypesAPI()
        

        // Do any additional setup after loading the view.
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
    func GetTicketTypesAPI()  {
       GetTicketTypesAPIInputBody()
        let GetTicketsServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.GetTicketsURL
        RequestManager.PostPathwithAUTH(urlString: GetTicketsServer, params: Input, successBlock:{
            (response) -> () in self.GetTicketResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func GetTicketTypesAPIInputBody()  {
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
            ]] as [String : AnyObject]
    }
    func GetTicketResponse(response: [String : AnyObject]){
        print("GetRedeemResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            TotalTicketTypearray = response["responseData"]?.value(forKey: "ticketTypeName") as! [String]
            print("TotalTicketTypearray  :", TotalTicketTypearray)
            TotalTicketTypearrayID = response["responseData"]?.value(forKey: "id") as! [NSNumber]
            print("TotalTicketTypearrayID  :", TotalTicketTypearrayID)
            

            
        }else{
        }
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "CONTACT US"
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
 }
    /**
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return textView.text.count + (text.count - range.length) <= 500
    }
    
}
