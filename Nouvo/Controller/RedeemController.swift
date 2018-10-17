//
//  RedeemController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import GoogleSignIn

class RedeemController: UIViewController,TCPickerViewOutput,UITextFieldDelegate,UIScrollViewDelegate {
    
    @IBOutlet var Rountingnumber: UITextField!
    @IBOutlet var viewheight: NSLayoutConstraint!
    @IBOutlet var BGview: UIView!
    @IBOutlet var Level: UILabel!
    @IBOutlet weak var profileimageview: UIImageView!
    @IBOutlet weak var contentview: UIView!
   
    @IBOutlet var RountingView: UIView!
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
    
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    @objc func closebackgroundviews() {
        BGview.isHidden = true
    }
    ///Handle click on shadow view
    @objc func onClickShadowViews(){
        BGview.isHidden = true
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.ForceUpdatetoUserAPIWithLoginwallet()
            DispatchQueue.main.async {
                
            }
        }
    }
    func ForceUpdatetoUserAPIWithLoginwallet()  {
        
//        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
//        view.addSubview(indicator)
//        indicator.frame = view.bounds
//        indicator.startAnimating()
        showSpinning()
        ForceUpdatewithLoginApiInputBodywallet()
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.InitSwipeURL
        RequestManager.PostPathwithAUTH(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.ForceUpdateWithLoginResponses(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func ForceUpdateWithLoginResponses(response: [String : AnyObject]) {
        print("ForceUpdateWithLoginResponse :", response)
        
        // Response time
        
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
            var generalsettings = [String : AnyObject]()
            generalsettings =  responses["responseData"]?.value(forKey: "generalSettings") as! [String : AnyObject]
            let playstoreurl = generalsettings["playStoreURL"] as! String
            print("playstoreurl response :", playstoreurl)
            Constants.Privacy = generalsettings["privacySecurityUrl"] as! String
            Constants.Termsofuse = generalsettings["termsOfUseUrl"] as! String
            var userprofilesettings = [String : AnyObject]()
            var userlevelsettings = [String : AnyObject]()
            userprofilesettings =  responses["responseData"]?.value(forKey: "userProfile") as! [String : AnyObject]
            userlevelsettings =  userprofilesettings["level"] as! [String : AnyObject]
            let wallet: NSNumber = userprofilesettings["walletBalance"] as! NSNumber
            if wallet is Double {
                print("Double type")
                if wallet == 0{
                    Cashback.text = ("$\(wallet).00")
                }else{
                    Cashback.text = ("$\(wallet)")
                }
                
            } else if wallet is Int {
                print("Int type")
                Cashback.text = ("$\(wallet).00")
            } else if wallet is Float {
                print("Float type")
                Cashback.text = ("$\(wallet)")
            } else {
                print("Unkown type")
            }
            
            
            Constants.WalletBalance = Cashback.text!
            let profilePicUrl: String?
            profilePicUrl = userprofilesettings["profilePicUrl"] as? String
            if profilePicUrl == nil || profilePicUrl == ""  {
            }
            else{
                Constants.profileimage = profilePicUrl!
                Database.set(Constants.profileimage, forKey: Constants.profileimagekey)
                Database.synchronize()
            }
            Constants.minlevel = userlevelsettings["levelMin"] as! Int
            Constants.maxlevel = userlevelsettings["levelMax"] as! Int
            Constants.userlevel = userlevelsettings["userXP"] as! Float
            Constants.level = userlevelsettings["userLevel"] as! Int
            print(Constants.level)
            print(Constants.maxlevel)
            Progressview.animationDuration = 0.5
            Progressview.minimumValue = Float(Constants.minlevel)
            Progressview.maximumValue = Float(Constants.maxlevel)
            Progressview.setProgress(userlevelsettings["userXP"] as! Float , animated: true)
            
            Level.text = String(format: "Level %d", Constants.level)
            Levelmode.text = String(format: "%d/%d", Constants.minlevel,Constants.maxlevel)
            print(userlevelsettings)
            Database.set(Constants.WalletBalance, forKey: Constants.WalletBalancekey)
            Database.set(Constants.minlevel, forKey: Constants.minlevelKey)
            Database.set(Constants.maxlevel, forKey: Constants.maxlevelKey)
            Database.set(Constants.userlevel, forKey: Constants.userlevelKey)
            Database.set(Constants.level, forKey: Constants.levelKey)
            Database.set(Constants.Privacy, forKey: Constants.Privacykey)
            Database.set(Constants.Termsofuse, forKey: Constants.Termsofusekey)
            Database.synchronize()
            PaytowhereAPI()
            
            // ConnecttoDealsAPISERVER()
            //itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4
            //  UIApplication.shared.openURL(NSURL(string: playstoreurl)! as URL)
        }else if success == "1050"{
            Database.removeObject(forKey: Constants.Tokenkey)
            Database.removeObject(forKey: Constants.profileimagekey)
            Database.removeObject(forKey: Constants.GoogleIdentityforchangepasswordkey)
            //LocalDatabase.ClearallLocalDB()
            Database.synchronize()
            GIDSignIn.sharedInstance().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "SignInController")
            self.present(navigationController, animated: true, completion: nil)
            hideLoading()
        }
    }
    func ForceUpdatewithLoginApiInputBodywallet()  {
        // Version 1.0
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
            "appVersionCode": appVersionString as AnyObject
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
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(RedeemController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(self.refreshControl)
         NotificationCenter.default.addObserver(self, selector: #selector(RedeemController.closebackgroundviews), name: NSNotification.Name(rawValue: "CloseBackgroundview1"), object: nil)
        self.addDoneButtonOnKeyboard()
        BGview.isHidden = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        BGview.addSubview(blurEffectView)
        
        
//        ///Configure the gesture to handle click on shadow and improve focus on searchbar
        let gestureShadow = UITapGestureRecognizer(target: self, action: #selector(RedeemController.onClickShadowViews))
        gestureShadow.delegate = self as? UIGestureRecognizerDelegate
        gestureShadow.numberOfTapsRequired = 1
        gestureShadow.numberOfTouchesRequired = 1
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(gestureShadow)
        BGview.addSubview(blurEffectView)
        
        Progressview.animationDuration = 0.5
        Progressview.minimumValue = Float(Constants.minlevel)
        Progressview.maximumValue = Float(Constants.maxlevel)
        Progressview.setProgress(Float(Constants.userlevel) , animated: true)
        
        Level.text = String(format: "Level %d", Constants.level)
        Levelmode.text = String(format: "%d/%d", Constants.minlevel,Constants.maxlevel)
        
        
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let city: String?
        city = Database.value(forKey: Constants.citynamekey) as? String
        if  city == "" || city == nil{
            
            CityLocation.text = ""
        }
        else{
            let city:String = (Database.value(forKey: Constants.citynamekey)  as? String)!
            CityLocation.text = city
        }
        
        let Balance:String = (Database.value(forKey: Constants.WalletBalancekey)  as? String)!
        Cashback.text = Balance
        
        print("Cashback",Cashback.text!)
        print("Balance",Balance)
        
        
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
        
        self.Rountingnumber.inputAccessoryView = doneToolbar
        self.RedeemAmount.inputAccessoryView = doneToolbar
       // self.textField.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction()
    {
        self.Rountingnumber.resignFirstResponder()
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
       // scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
       // viewheight.constant = scrollview.contentSize.height
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
        RedeemAmount.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        PaytowhereView.layer.cornerRadius = 4.0
        PaytowhereView.layer.borderWidth = 0.4
        PaytowhereView.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        SelectedBankView.layer.cornerRadius = 4.0
        SelectedBankView.layer.borderWidth = 0.4
        SelectedBankView.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        PaymentAccountNoView.layer.cornerRadius = 4.0
        PaymentAccountNoView.layer.borderWidth = 0.4
        PaymentAccountNoView.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        WithdrawalView.layer.cornerRadius = 4.0
        WithdrawalView.layer.borderWidth = 0.4
        WithdrawalView.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        RountingView.layer.cornerRadius = 4.0
        RountingView.layer.borderWidth = 0.4
        RountingView.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
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
            "requestData": ""] as [String : AnyObject]
    }
    func GetRedeemResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
        hideLoading()
        print("GetRedeemResponse :", response)
        // Response time
        
        let encrypted:String = String(format: "%@", response["responseData"] as! String)
        // AES decryption
        let AES = CryptoJS.AES()
        print(AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs"))
        var json = [[String : AnyObject]]()
        let decrypted = AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs")
        if decrypted == "null"{}
        else{
            let objectData = decrypted.data(using: String.Encoding.utf8)
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : AnyObject]]
            print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]

        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            TotalBankTypearray = responses["responseData"]?.value(forKey: "mode") as! [String]
            print("TotalBankTypearray  :", TotalBankTypearray)
            
            TotalBankTypearrayID = responses["responseData"]?.value(forKey: "modeId") as! [NSNumber]
            print("TotalBankTypearrayID  :", TotalBankTypearrayID)
            
            TotalBankNamearray = responses["responseData"]?.value(forKey: "modeOptions") as! [NSArray]
            print("TotalBankNamearray  :", TotalBankNamearray)
            
            TotalBankNamearrayID = responses["responseData"]?.value(forKey: "modeOptions") as! [NSArray]
            print("TotalBankNamearrayID  :", TotalBankNamearrayID)
            
            
            
            
            self.Paytowhere.text = TotalBankTypearray[0]
            self.PaytoWhereID = TotalBankTypearrayID[0]
            
            
            SelectedBankTypearray = TotalBankNamearray[0].value(forKey: "name") as! [String]
            SelectedBankTypearrayID = TotalBankNamearrayID[0].value(forKey: "modeSubId") as! [NSNumber]
            print("SelectedBankTypearrayID  :", SelectedBankTypearrayID)
            
            
            self.SelectedBank.text = SelectedBankTypearray[0]
            self.SelectedBankID = self.SelectedBankTypearrayID[0]
            
            
            if self.Paytowhere.text == "Cheque" {
                self.SelectedBank.text = ""
                self.PaymentAccountNo.text = ""
                self.RountingView.isHidden = true
                self.WithdrawalView.frame.origin.y = 165
                self.ConfirmButton.frame.origin.y = 255
                self.SelectedBankButton.isUserInteractionEnabled = false
                self.SelectedBankDownIcon.isHidden = true
                self.PaymentAccountNo.placeholder = "Address"
                self.SelectedBank.placeholder = "Name"
            }else if self.Paytowhere.text == "Bank Account" {
                self.SelectedBank.text = "Choose Your Bank"
                self.PaymentAccountNo.placeholder = "Account Number"
                self.PaymentAccountNo.text = ""
                self.RountingView.isHidden = false
                self.WithdrawalView.frame.origin.y = 220
                self.ConfirmButton.frame.origin.y = 310
                self.SelectedBankButton.isUserInteractionEnabled = true
                self.SelectedBankDownIcon.isHidden = false
            }else if self.Paytowhere.text == "Cryptocurrencies"{
                self.SelectedBankButton.isUserInteractionEnabled = true
                self.RountingView.isHidden = true
                self.WithdrawalView.frame.origin.y = 165
                self.ConfirmButton.frame.origin.y = 255
                self.SelectedBankDownIcon.isHidden = false
                self.PaymentAccountNo.placeholder = "Wallet Address"
                
            }
            
            
//            if self.Paytowhere.text == "Cheque" {
//                self.SelectedBank.text = ""
//                self.PaymentAccountNo.text = ""
//
//                self.SelectedBankButton.isUserInteractionEnabled = false
//                self.SelectedBankDownIcon.isHidden = true
//            }else if self.Paytowhere.text == "Bank Account" {
//
//
//            }
//                //
//            else if self.Paytowhere.text == "Cryptocurrencies"{
//
//
//                self.SelectedBank.text = SelectedBankTypearray[0]
//                self.SelectedBankID = self.SelectedBankTypearrayID[0]
//            }
            
            
        }else if success == "1050"{
            Database.removeObject(forKey: Constants.Tokenkey)
            Database.removeObject(forKey: Constants.profileimagekey)
            Database.removeObject(forKey: Constants.GoogleIdentityforchangepasswordkey)
            //LocalDatabase.ClearallLocalDB()
            Database.synchronize()
            GIDSignIn.sharedInstance().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "SignInController")
            self.present(navigationController, animated: true, completion: nil)
            hideLoading()
        }
        refreshControl.endRefreshing()
   }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 690)
        
    }
//    func doSomething(action: UIAlertAction) {
//        //Use action.title
//        
//        Database.removeObject(forKey: Constants.Tokenkey)
//        Database.removeObject(forKey: Constants.profileimagekey)
//        Database.removeObject(forKey: Constants.GoogleIdentityforchangepasswordkey)
//        //LocalDatabase.ClearallLocalDB()
//        Database.synchronize()
//        GIDSignIn.sharedInstance().signOut()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let navigationController = storyboard.instantiateViewController(withIdentifier: "SignInController")
//        self.present(navigationController, animated: true, completion: nil)
//    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
//        let token = Database.value(forKey: Constants.Tokenkey) as? String
//        if token == nil {
//            let alert = UIAlertController(title: "Your Session has Expired" , message: "Login", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: self.doSomething)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//        }
        
        
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }
        else{
            
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            self.profileimageview.sd_setImage(with: url)
                self.profileimageview.contentMode = .scaleAspectFill
                self.profileimageview.layer.borderWidth = 1.0
                self.profileimageview.layer.masksToBounds = false
                self.profileimageview.layer.borderColor = UIColor.white.cgColor
                self.profileimageview.layer.cornerRadius = self.profileimageview.frame.size.width / 2
                self.profileimageview.clipsToBounds = true
            
        }
        
        let city: String?
        city = Database.value(forKey: Constants.citynamekey) as? String
        if  city == "" || city == nil{
            
            CityLocation.text = ""
        }
        else{
            let city:String = (Database.value(forKey: Constants.citynamekey)  as? String)!
            CityLocation.text = city
        }
        
        let Balance:String = (Database.value(forKey: Constants.WalletBalancekey)  as? String)!
        Cashback.text = Balance
        
        ConnectivityNetworkCheck()
        PaytowhereAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmTap(_ sender: Any) {
        
       //Fields need to verify must, dont forgot
        
       
        var a:Float? = Float(RedeemAmount.text!)
      //  let cashback:Int? = Int(Cashback.text!)
        
        
        print("Cashback",Cashback.text!)
        
        if a == nil {
            a = 0
        }
        
        let cashwallet = (Cashback.text?.replacingOccurrences(of: "$", with: ""))!
        let b:Float? = Float(cashwallet)
        let amontstring: String = RedeemAmount.text!
       // amontstring.prefix(4)
        print("Redeem Amont : %@",amontstring.prefix(1))
        
        if Paytowhere.text == "" {
            let alert = UIAlertController(title: "Bank Account" , message: "Please Select Your Bank Type", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if SelectedBank.text == ""{
            let alert = UIAlertController(title: "Bank Account Name" , message: "Please Select Your Bank Name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if PaymentAccountNo.text == ""{
            let alert = UIAlertController(title: "Account Number" , message: "Please Enter Your Account Number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }  else if RedeemAmount.text == "0" || amontstring.prefix(1) == "0" {
            let alert = UIAlertController(title: "Invalid Redeem" , message: "Redeem amount should be greater than $0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if a == 0 {
            let alert = UIAlertController(title: "Invalid Redeem" , message: "Redeem amount should be greater than $0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
            //a! >= cashback!
        else if a! > b! {
            let alert = UIAlertController(title: "Invalid Redeem" , message: ("You cannot redeem more than \(self.Cashback.text!)"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            if self.Paytowhere.text == "Bank Account" {
                if Rountingnumber.text == ""{
                    let alert = UIAlertController(title: "Routing Number" , message: "Please Enter Your Routing Number", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    }else{
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
            } else{
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
        
       
        
    }
    func RedeemAPIInputBody(){
        print("PaytoWhereID  :", PaytoWhereID)
       // print("SelectedBankID  :", SelectedBankID)
        
        if self.Paytowhere.text == "Cheque" {
            
            SelectedBankID = 0
        }
        
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
            "redeemModeId": PaytoWhereID as AnyObject,
            "redeemModeOptionId": SelectedBankID as AnyObject,
            "amount": RedeemAmount.text as AnyObject
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
    func RaiseRedeemResponse(response: [String : AnyObject]){
        print("RaiseRedeemResponse :", response)
        
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
            hideLoading()
            ConfirmButton.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Redeem" , message: "Redeem request generated successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            Rountingnumber.text = ""
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
        
        BGview.isHidden = false
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
        
        BGview.isHidden = false
        picker.title = "Choose Your Bank Type"
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
                    self.RountingView.isHidden = true
                    self.WithdrawalView.frame.origin.y = 165
                    self.ConfirmButton.frame.origin.y = 255
                    self.SelectedBankButton.isUserInteractionEnabled = false
                    self.SelectedBankDownIcon.isHidden = true
                }else if self.Paytowhere.text == "Bank Account" {
                    self.SelectedBank.text = "Choose Your Bank"
                    self.PaymentAccountNo.text = ""
                    self.RountingView.isHidden = false
                    self.WithdrawalView.frame.origin.y = 220
                    self.ConfirmButton.frame.origin.y = 310
                    self.SelectedBankButton.isUserInteractionEnabled = true
                    self.SelectedBankDownIcon.isHidden = false
                }else if self.Paytowhere.text == "Cryptocurrencies"{
                    self.SelectedBankButton.isUserInteractionEnabled = true
                    self.RountingView.isHidden = true
                    self.WithdrawalView.frame.origin.y = 165
                    self.ConfirmButton.frame.origin.y = 255
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
                self.PaymentAccountNo.placeholder = "Address"
                self.SelectedBank.placeholder = "Name"
                self.SelectedBankButton.isUserInteractionEnabled = false
                self.SelectedBankDownIcon.isHidden = true
            }else if self.Paytowhere.text == "Bank Account" {
                self.PaymentAccountNo.placeholder = "Account Number"
                self.Rountingnumber.text = ""

            }
                //
            else if self.Paytowhere.text == "Cryptocurrencies"{
                self.PaymentAccountNo.text = ""
                self.PaymentAccountNo.placeholder = "Wallet Address"
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
            //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
            if textField.text?.count == 0 && string == "0" {
                
                return false
            }
            //Have a decimal keypad. Which means user will be able to enter Double values. (Needless to say "." will be limited one)
            if (textField.text?.contains("."))! && string == "." {
                
                return false
            }
           
        }else if textField == Rountingnumber{
            if range.location == 9 {
                return false}
            //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
            //Have a decimal keypad. Which means user will be able to enter Double values. (Needless to say "." will be limited one)
            if (textField.text?.contains("."))! && string == "." {
                return false
            }
        }
        
        else if textField == PaymentAccountNo
        {
            if range.location == 20 {
            return false}
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
            
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
        
         print(scrollview.contentInset.bottom)
        
    var info = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height+100, 0.0)
    
    scrollview.contentInset = contentInsets
    scrollview.scrollIndicatorInsets = contentInsets
        
        print(scrollview.frame.size.height)
        print(scrollview.contentSize.height)
        print("Bottom",scrollview.contentInset.bottom)
        print("TOP",scrollview.contentInset.top)
    
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
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,0.0, 0.0)
    scrollview.contentInset = contentInsets
    scrollview.scrollIndicatorInsets = contentInsets
        
        print(scrollview.frame.size.height)
        print(scrollview.contentSize.height)
        print("Bottom",scrollview.contentInset.bottom)
        print("TOP",scrollview.contentInset.top)
    //scrollview.contentSize = CGSize(width: self.view.frame.size.width, height:655)
   // self.view.endEditing(true)
    scrollview.isScrollEnabled = true
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
    
    @IBAction func Settingstap(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeindex"), object: nil)
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)}
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
//        searchBar.text = ""
//    }
}
