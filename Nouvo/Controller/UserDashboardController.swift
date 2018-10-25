//
//  UserDashboardController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import CoreLocation
import MXParallaxHeader
import SDWebImage
import CRRefresh
import GoogleSignIn

class UserDashboardController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate,UIScrollViewDelegate,ModernSearchBarDelegate,MXParallaxHeaderDelegate,UISearchDisplayDelegate,TCPickerViewOutput,UIGestureRecognizerDelegate {
    
    //MARK: - OUTLETS
    var suggestionList = Array<String>()
    @IBOutlet var profiletapbutton: UIButton!
    @IBOutlet var Nodealslabel1: UILabel!
    @IBOutlet var Nodeallabel: UILabel!
    @IBOutlet var Bgview: UIView!
    @IBOutlet var referralbgviewview: UIView!
    @IBOutlet var referralview: UIView!
    @IBOutlet var Referraltext: UITextField!
    var textField: UITextField!
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=15
    var tags1:Int=0
    var citynamesIS : String?
    var picker: TCPickerViewInput = TCPickerView()
    var DealnameArray = [Dealname]()
    var DeallogoArray = [Deallogo]()
    var DealLocationArray = [DealLocation]()
    var DealcashbackArray = [Dealcashback]()
    var DealStartDateArray = [DealStartDate]()
    var DealEndDateArray = [DealEndDate]()
     var currentDealnameArray = [Dealname]()
     var currentDeallogoArray = [Deallogo]()
     var currentDealLocationArray = [DealLocation]()
     var currentDealcashbackArray = [Dealcashback]()
     var currentDealStartDateArray = [DealStartDate]()
     var currentDealEndDateArray = [DealEndDate]()//update table
     let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    @IBOutlet var headerview: UIView!
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var Strechview: FRStretchView!
    @IBOutlet var myheight: NSLayoutConstraint!
    //MARK: -  Outlets and Instance
    private var mySearchBar: ModernSearchBar!
    var searchController: UISearchController!
    @IBOutlet var Dealalertlabel: UILabel!
    //@IBOutlet var modernSearchBar: ModernSearchBar!
    @IBOutlet var Cashback: UILabel!
    @IBOutlet var Levelmode: UILabel!
    @IBOutlet var Level: UILabel!
    @IBOutlet var Heif: NSLayoutConstraint!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var Scrollview: UIScrollView!
    @IBOutlet weak var profileimageview: UIImageView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var Progressview: LinearProgressView!
    @IBOutlet weak var CityLocation: UILabel!
    @IBOutlet weak var NameOfSwipe: UILabel!
    @IBOutlet weak var DashboardView: UIView!
    @IBOutlet weak var Retailshoplist: UITableView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    var lat = Double()
    var long = Double()
    var responseArray = NSArray()
    var responseArraycountzero = NSArray()
    var Totalcityarray = [String]()
    var TotalDealnamearray = [AnyObject]()
    var TotalDeallogoarray = [AnyObject]()
    var TotalDealstartdatearray = [String]()
    var TotalDealenddatearray = [String]()
    var TotalDeallocationarray = [String]()
    var TotalDealcashbackarray = [AnyObject]()
    var pickeridentity = String()
    var searchidentity = String()
    var Paginationidentity = String()
    var firsttimecallAPI = String()
    var refreshAPI = String()
    let scrollViewContentHeight = 1200 as CGFloat
    var Test_View = UIView()
    @IBOutlet var Gest: UITapGestureRecognizer!
    @IBOutlet var HideBtn: UIButton!
    
    //MARK: -  REFERRAL APPLY TAP
    @IBAction func RefApplyTap(_ sender: Any) {
        referralbgviewview.isHidden = true
        Referraltext.resignFirstResponder()
        if Referraltext.text == "" || (Referraltext.text?.isEmpty)!{
            referralbgviewview.isHidden = false
            Referraltext.becomeFirstResponder();
            let alert = UIAlertController(title: "Referral Code" , message: "Please enter your referral code!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
             ApplyReferralcodeAPIInputBody()
             let ReferralAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ApplyreferralcodeURL
            RequestManager.PostPathwithAUTH(urlString: ReferralAPI, params: Input, successBlock:{
                (response) -> () in self.ApplyReferralcodeResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in }
        }
        
    }
    //MARK: -  REFERRAL SERVER REQUEST
    func ApplyReferralcodeAPIInputBody() {
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "referredBy": textField.text as AnyObject
            ]] as [String : AnyObject]
    }
    //MARK: -  REFERRAL SERVER RESPONSE
    func ApplyReferralcodeResponse(response: [String : AnyObject]){
        print("Referral Code :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            referralbgviewview.isHidden = true
            self.referralbgviewview.isHidden = true
            Constants.Newrecord = 0
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.synchronize()
            let alert = UIAlertController(title: "Referral Code", message: "Successfully applied your referral code", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            checkreferral1()
            textField.placeholder = "Invalid Referral code"
            hideLoading()
            referralbgviewview.isHidden = false
            textField.becomeFirstResponder();
        }
        
    }
    //MARK: -  REFERRAL CANCEL TAP
    @IBAction func RefCancelTap(_ sender: Any) {
        Constants.Newrecord = 0
        Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
        Database.synchronize()
        referralbgviewview.isHidden = true
        Referraltext.resignFirstResponder()
    }
    @IBAction func send(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeindex"), object: nil)
    }
    @IBAction func check(_ sender: Any) {
        
    }
    //MARK: -  VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }else{
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            self.profileimageview.sd_setImage(with: url)
            self.profileimageview.contentMode = .scaleAspectFill
            self.profileimageview.layer.borderWidth = 1.0
            self.profileimageview.layer.masksToBounds = false
            self.profileimageview.layer.borderColor = UIColor.white.cgColor
            self.profileimageview.layer.cornerRadius = self.profileimageview.frame.size.width / 2
            self.profileimageview.clipsToBounds = true
            //}
        }
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        pickeridentity = "NO"
        Paginationidentity = "NO"
        searchidentity = ""
        DealnameArray = [Dealname]()
        DealLocationArray = [DealLocation]()
        DealcashbackArray = [Dealcashback]()
        DealStartDateArray = [DealStartDate]()
        DealEndDateArray = [DealEndDate]()
        self.pageNo = 0
        self.limit = 15
        refreshAPI = ""
            let city: String?
            city = Database.value(forKey: Constants.citynamekey) as? String
            if  city == "" || city == nil{
               CityLocation.text = ""
            }else{
                 CityLocation.text = city
                 self.ConnecttoDealsAPISERVER()}
    }

    
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
 
    //MARK: -  VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }else{
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            self.profileimageview.sd_setImage(with: url)
            self.profileimageview.contentMode = .scaleAspectFill
            self.profileimageview.layer.borderWidth = 1.0
            self.profileimageview.layer.masksToBounds = false
            self.profileimageview.layer.borderColor = UIColor.white.cgColor
            self.profileimageview.layer.cornerRadius = self.profileimageview.frame.size.width / 2
            self.profileimageview.clipsToBounds = true
            //}
        }
    }

    ///Handle click on shadow view
    @objc func closebackgroundviews(){
        self.Retailshoplist.endEditing(true)
        self.mySearchBar.endEditing(true)
        self.mySearchBar.resignFirstResponder()
    }
    //MARK: -  REFRESH SETUP
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(UserDashboardController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        return refreshControl
    }()

    //MARK: -  REFRESH ACTION
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        

        
        pickeridentity = "NO"
        Paginationidentity = "NO"
        searchidentity = ""
        DealnameArray = [Dealname]()
        DealLocationArray = [DealLocation]()
        DealcashbackArray = [Dealcashback]()
        DealStartDateArray = [DealStartDate]()
        DealEndDateArray = [DealEndDate]()
        self.pageNo = 0
        self.limit = 15
        refreshAPI = "R"
        
        DispatchQueue.global(qos: .background).async {
        self.ForceUpdatetoUserAPIWithLogin()
            DispatchQueue.main.async {
            }
        }
    }
    
    //MARK: -  FIREBASE SERVER REQUEST
    func FirebaseApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let token:String = (Database.value(forKey: Constants.fcmTokenkey) as? String)!
        let jsonObject: [String: AnyObject] = [
            "token": token as AnyObject
        ]
        var encrypted  = String()
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str = String(data: data, encoding: .utf8) {
            print(str)
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
    //MARK: -  FIREBASE SERVER RESPONSE
    func FirebasenotifyResponse(response: [String : AnyObject]){
        print("FirebasenotifyResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
        }
        
    }
    
    //MARK: -  REFERRAL METH0DS
    func checkreferral()  {
        var isnewrecord: Int?
        isnewrecord = Database.value(forKey: Constants.NewrecordKey) as? Int
        //let isnewrecord:Int = (Database.value(forKey: Constants.NewrecordKey)  as! Int)
       // isnewrecord = 1
        if isnewrecord == 1{
            FirebaseApiInputBody()
            let ForgotPasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.Firebasenotification
            RequestManager.getPath(urlString: ForgotPasswordServer, params: Input, successBlock:{
                (response) -> () in self.FirebasenotifyResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in}
            let alert = UIAlertController(title: "Referral Code", message: "Have a referral code, apply it here to get the XP points!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                self.referralbgviewview.isHidden = true
                self.dismiss(animated: true, completion: nil)
                Constants.Newrecord = 0
                Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
                Database.synchronize()
                
            })
            let submitAction = UIAlertAction(title: "Apply", style: .default, handler: { (action) -> Void in
                self.textField = alert.textFields![0]
                print(self.textField.text!)
                if self.textField.text == "" || (self.textField.text?.isEmpty)!{
                    self.referralbgviewview.isHidden = false
                    self.present(alert, animated: true, completion: nil)
                   //Please enter your referral code!
                }else{
                    self.ApplyReferralcodeAPIInputBody()
                    let ReferralAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ApplyreferralcodeURL
                    RequestManager.PostPathwithAUTH(urlString: ReferralAPI, params: self.Input, successBlock:{
                        (response) -> () in self.ApplyReferralcodeResponse(response: response as! [String : AnyObject])})
                    { (error: NSError) ->() in }
                }
                
            })
            
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Referral Code"
                textField.superview?.backgroundColor = UIColor.gray
                
            }
           
            // Add action buttons and present the Alert
            alert.addAction(cancel)
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            for textField in alert.textFields! {
                if let container = textField.superview, let effectView = container.superview?.subviews.first, effectView is UIVisualEffectView {
                    container.backgroundColor = UIColor.lightText
                    container.layer.masksToBounds = true
                    container.layer.cornerRadius = 5.0
                    container.layer.borderWidth = 0.5
                    container.layer.borderColor = UIColor.lightGray.cgColor
                    effectView.removeFromSuperview()
                }
            }
        }else{
            self.referralbgviewview.isHidden = true
            Constants.Newrecord = 0
            Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
            Database.synchronize()
        }
    }
    func checkreferral1()  {
        let isnewrecord: Int?
        isnewrecord = Database.value(forKey: Constants.NewrecordKey) as? Int
        //let isnewrecord:Int = (Database.value(forKey: Constants.NewrecordKey)  as! Int)
        if isnewrecord == 1{
            let alert = UIAlertController(title: "Invalid Referral Code!", message: "Have a referral code, apply it here to get the XP points!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                self.referralbgviewview.isHidden = true
                Constants.Newrecord = 0
                Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
                Database.synchronize()
            })
            let submitAction = UIAlertAction(title: "APPLY", style: .default, handler: { (action) -> Void in
                self.textField = alert.textFields![0]
                print(self.textField.text!)
                if self.textField.text == "" || (self.textField.text?.isEmpty)!{
                    self.referralbgviewview.isHidden = false
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.ApplyReferralcodeAPIInputBody()
                    let ReferralAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ApplyreferralcodeURL
                    RequestManager.PostPathwithAUTH(urlString: ReferralAPI, params: self.Input, successBlock:{
                        (response) -> () in self.ApplyReferralcodeResponse(response: response as! [String : AnyObject])})
                    { (error: NSError) ->() in }
                }
                
            })
            alert.addTextField { textField in
                textField.placeholder = "Enter Referral Code"
                textField.superview?.backgroundColor = UIColor.gray
            }
            // Add action buttons and present the Alert
            alert.addAction(cancel)
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            for textField in alert.textFields! {
                if let container = textField.superview, let effectView = container.superview?.subviews.first, effectView is UIVisualEffectView {
                    container.backgroundColor = UIColor.lightText
                    container.layer.masksToBounds = true
                    container.layer.cornerRadius = 5.0
                    container.layer.borderWidth = 0.5
                    container.layer.borderColor = UIColor.lightGray.cgColor
                    effectView.removeFromSuperview()
                }
            }
        }else{
                self.referralbgviewview.isHidden = true
                Constants.Newrecord = 0
                Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
                Database.synchronize()
            
        }
    }
    //MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        DashboardView.isUserInteractionEnabled = true
        self.checkreferral()
        Nodealslabel1.isHidden = true
        Nodealslabel1.layer.cornerRadius = 5
        Nodealslabel1.layer.masksToBounds = true
        setUpDashbaordHeaderView()
        Retailshoplist.parallaxHeader.view?.isUserInteractionEnabled = true
        Retailshoplist.parallaxHeader.view = headerview // You can set the parallax header view from the floating view
        Retailshoplist.parallaxHeader.height = 180
        Retailshoplist.parallaxHeader.minimumHeight = 0
        Retailshoplist.parallaxHeader.mode = MXParallaxHeaderMode.center
        Retailshoplist.parallaxHeader.delegate = self
        Retailshoplist.parallaxHeader.view = self.refreshControl
        InitializeLocationManager()
        ConnectivityNetworkCheck()
        ForceUpdatetoUserAPIWithLogin()
        Retailshoplist.register(UINib(nibName: "Retailshoplistcell", bundle: nil),
                               forCellReuseIdentifier: "Retailshoplistcell")
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameOfSwipe.text = string2
    }
    
    
  //MARK: -  SEARCHBAR UI SETUP
    func configureSearchController() {
        // make UISearchBar instance
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        customView.backgroundColor = UIColor.white
        mySearchBar = ModernSearchBar(frame: CGRect(x: 8, y: 0, width: self.view.frame.size.width-16, height: 40))
        mySearchBar.placeholder = "Search Store/Location"
        mySearchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        mySearchBar.tintColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        mySearchBar.barTintColor = UIColor.white
        mySearchBar.layer.borderWidth = 0.7;
        mySearchBar.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        mySearchBar.layer.cornerRadius = 15.0;
        mySearchBar.delegateModernSearchBar = self as ModernSearchBarDelegate
        customView.addSubview(mySearchBar)
        Retailshoplist.tableHeaderView = customView
       // viewDidLayoutSubviews()
    }
    // MARK: - Parallax header delegate setupParallaxHeader
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
       // NSLog("progress %f", parallaxHeader.progress)
    }
   
    override func updateViewConstraints() {
        super.updateViewConstraints()
      //  Heif.constant = Retailshoplist.contentSize.height
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")

    }

      //MARK: -  SERVER REQUEST FOR INITSWIPE
    func ForceUpdatetoUserAPIWithLogin()  {
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        ForceUpdatewithLoginApiInputBody()
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.InitSwipeURL
        RequestManager.PostPathwithAUTH(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.ForceUpdateWithLoginResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
      //MARK: -  SERVER RESONSE
    func ForceUpdateWithLoginResponse(response: [String : AnyObject]) {
        print("ForceUpdateWithLoginResponse :", response)
        //Encryption value from response
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
           // let wallet
            let invitecode: String?
            let wallet: NSNumber = userprofilesettings["walletBalance"] as! NSNumber
            invitecode = userprofilesettings["userReferralCode"] as? String
            Constants.mycode = invitecode!
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
            Database.set(Constants.mycode, forKey: Constants.mycodeKey)
            Database.set(Constants.userlevel, forKey: Constants.userlevelKey)
            Database.set(Constants.level, forKey: Constants.levelKey)
            Database.set(Constants.Privacy, forKey: Constants.Privacykey)
            Database.set(Constants.Termsofuse, forKey: Constants.Termsofusekey)
            Database.synchronize()
            if refreshAPI == "R"{
                ConnecttoDealsAPISERVER()
            }else{
                 AskcitynameAPI()
                
            }

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
    func ForceUpdatewithLoginApiInputBody()  {
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
    
      //MARK: -  CITY SERVER REQUEST
    func AskcitynameAPI() {
        GetcityApiInputBody()
        let GetcityServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.GetcityURL
        RequestManager.PostPathwithAUTH(urlString: GetcityServer, params: Input, successBlock:{
            (response) -> () in self.GetcityResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
        
    }
    func GetcityApiInputBody()  {
        // Version 1.0
        //let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": ""] as [String : AnyObject]
    }
    //MARK: -  CITY SERVER RESPONSE
    func GetcityResponse(response: [String : AnyObject]) {
        print("GetcityResponse :", response)
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
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as!  [[String : AnyObject]]
            print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]

        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
        Totalcityarray = responses["responseData"]?.value(forKey: "name") as! [String]
            
           suggestionList = Array<String>()
            for name in Totalcityarray {
                suggestionList.append(name)
                
            }
            print(suggestionList)
            configureSearchController()
            
            ///Adding delegate
            self.mySearchBar?.delegateModernSearchBar = self as ModernSearchBarDelegate
            ///Set datas to search bar
            self.mySearchBar?.setDatas(datas: suggestionList)
            ConvertLatandLongtoCityName()
            showSpinning()
        }
 }
    
    //MARK: -  GETTING CITY NAME FROM GEOLOCATION
    func ConvertLatandLongtoCityName()  {
        
        print(lat)
        print(long)
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                
                if self.refreshAPI == "R"{
                    let city:String = (Database.value(forKey: Constants.citynamekey)  as? String)!
                    self.citynamesIS = city
                    self.CityLocation.text = city
                }else{
                    self.citynamesIS = city
                    print(self.citynamesIS as! String)
                    Constants.cityname = self.citynamesIS!
                    self.CityLocation.text = Constants.cityname
                    Database.set(Constants.cityname, forKey: Constants.citynamekey)
                    Database.synchronize()
                }
                
                
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
            self.firsttimecallAPI = "firsttimeonly"
            self.ConnecttoDealsAPISERVER()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: -  Daashboard HeaderView
    func setUpDashbaordHeaderView() {
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        headerview.frame.size.height = 180;
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:headerview.bounds.size.height - (headerview.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:headerview.bounds.size.height - (headerview.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:headerview.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        headerview.layer.mask = maskLayer
        headerview.isUserInteractionEnabled = true;
        
        
    }
    //MARK: - Initialize Core LocationManager
    func InitializeLocationManager()  {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    //MARK: -  CLLocationManager Delegate Methods to fetch Latitude and Longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations[0]
        
        long = currentLocation.coordinate.longitude
        lat = currentLocation.coordinate.latitude
        
//        long = String(format : "%@",currentLocation.coordinate.longitude)
//        lat =  String(format : "%@",currentLocation.coordinate.latitude)
    }
    //MARK: - Checking Internet Connectivity
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
    //MARK: - Connecting to Deals API SERVER
    func ConnecttoDealsAPISERVER() {
        //refreshControl.endRefreshing()
        DealsAPIInputBody()
        let DealsAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.DealsURL
        RequestManager.PostPathwithAUTH(urlString: DealsAPI, params: Input, successBlock:{
            (response) -> () in self.DealsResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
    }
    //MARK: - Connecting to Deals API SERVER
    func ConnecttoDealsAPISERVER1() {
        //refreshControl.endRefreshing()
        DealsAPIInputBody1()
        let DealsAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.DealsURL
        RequestManager.PostPathwithAUTH(urlString: DealsAPI, params: Input, successBlock:{
            (response) -> () in self.DealsResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
    }
    //MARK: - Deals API Input Body Parameter
    func DealsAPIInputBody(){
        print("City Names is :",self.citynamesIS as AnyObject)
        
        self.citynamesIS = (Database.value(forKey: Constants.citynamekey) as? String)
        if self.citynamesIS == "" && self.citynamesIS == "nil" {
            self.citynamesIS = "Los Angeles"
        }
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        
        
        let jsonObject: [String: AnyObject] = [
            "location": self.citynamesIS as AnyObject,
            "pageNumber": self.pageNo as AnyObject,
            "pageSize": self.limit as AnyObject
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
        
        print(Input)
    }
    //MARK: - Deals API Input Body Parameter
    func DealsAPIInputBody1(){
        print("City Names is :",self.citynamesIS as AnyObject)
        
       //  Database.set(Constants.searchcityname, forKey: Constants.searchcitynamekey)
        self.citynamesIS = (Database.value(forKey: Constants.searchcitynamekey) as? String)
        if self.citynamesIS == "" && self.citynamesIS == "nil" {
            self.citynamesIS = "Los Angeles"
        }
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        
        
        let jsonObject: [String: AnyObject] = [
            "location": self.citynamesIS as AnyObject,
            "pageNumber": self.pageNo as AnyObject,
            "pageSize": self.limit as AnyObject
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
        
        print(Input)
    }
    //MARK: -  Fetching Deals data from server
    func DealsResponse(response: [String : AnyObject]){
   
        print("DealsResponse  :", response)
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
            hideLoading()
            let data1 = (responses as NSDictionary).object(forKey: "responseData")
            responseArraycountzero = data1 as! NSArray
            if responseArraycountzero.count == 0{
                
                if Paginationidentity == "YES"{
                    self.pageNo = self.pageNo - 1
                    print("pageNo afterr",self.pageNo)
                    }else{
                        if pickeridentity == "YES"  {
                        Nodealslabel1.isHidden = false
                        Nodealslabel1.text = ("No stores available for \(self.CityLocation.text!) yet. Please change the location/city.")
                        currentDealnameArray = [Dealname]()
                        currentDeallogoArray = [Deallogo]()
                        currentDealLocationArray = [DealLocation]()
                        currentDealcashbackArray = [Dealcashback]()
                        currentDealStartDateArray = [DealStartDate]()
                        currentDealEndDateArray = [DealEndDate]()//update table
                        DealnameArray = [Dealname]()
                             DeallogoArray = [Deallogo]()
                        DealLocationArray = [DealLocation]()
                        DealcashbackArray = [Dealcashback]()
                        DealStartDateArray = [DealStartDate]()
                        DealEndDateArray = [DealEndDate]()
                        Retailshoplist.reloadData()
                        hideLoading()
                        }else{
                       // Nodeallabel.isHidden = false
                        Nodealslabel1.isHidden = false
                        Nodealslabel1.text = ("No stores available for \(self.citynamesIS!) yet. Please change the location/city.")
                        currentDealnameArray = [Dealname]()
                        currentDeallogoArray = [Deallogo]()
                        currentDealLocationArray = [DealLocation]()
                        currentDealcashbackArray = [Dealcashback]()
                        currentDealStartDateArray = [DealStartDate]()
                        currentDealEndDateArray = [DealEndDate]()//update table
                        DealnameArray = [Dealname]()
                        DeallogoArray = [Deallogo]()
                        DealLocationArray = [DealLocation]()
                        DealcashbackArray = [Dealcashback]()
                        DealStartDateArray = [DealStartDate]()
                        DealEndDateArray = [DealEndDate]()
                        Retailshoplist.reloadData()
                    }
                }
                
            } else if searchidentity == "Seaching store names"{
                searchidentity = ""
                Nodealslabel1.isHidden = true
                hideLoading()
                pickeridentity = "NO"
                //Dealalertlabel.text = "Load More"
                responseArray = data1 as! NSArray
                print("responseArray1  :", responseArray)
                TotalDealnamearray = responses["responseData"]?.value(forKey: "entityName") as! [AnyObject]
                TotalDealstartdatearray = responses["responseData"]?.value(forKey: "startDate") as! [String]
                TotalDealenddatearray = responses["responseData"]?.value(forKey: "endDate") as! [String]
                TotalDeallocationarray = responses["responseData"]?.value(forKey: "location") as! [String]
                TotalDealcashbackarray = responses["responseData"]?.value(forKey: "cashBonus") as! [AnyObject]
                TotalDeallogoarray = responses["responseData"]?.value(forKey: "icon") as! [AnyObject]
                
                for var names in TotalDealnamearray {
                    
                    if names is NSNull{
                        names = "" as AnyObject
                        DealnameArray.append(Dealname(name: names as! String))
                    }else{
                        DealnameArray.append(Dealname(name: (names ) as! String))
                    }
                    
                }
                for var logos in TotalDeallogoarray {
                    
                    if logos is NSNull || logos as! String == "some url"{
                        logos = "" as AnyObject
                        DeallogoArray.append(Deallogo(logo: logos as! String))
                    }else{
                        DeallogoArray.append(Deallogo(logo: (logos ) as! String))
                    }
                    
                }
                for loc in TotalDeallocationarray {
                    DealLocationArray.append(DealLocation(location: loc))
                }
                for cash in TotalDealcashbackarray {
                    DealcashbackArray.append(Dealcashback(cashback: cash))
                }
                for start in TotalDealstartdatearray {
                    DealStartDateArray.append(DealStartDate(promotionstartdate: start))
                }
                for end in TotalDealenddatearray {
                    DealEndDateArray.append(DealEndDate(promotionenddate: end))
                }
                
                
                
                print("Deal total",DealnameArray.count)
               // print(currentDeallogoArray)
                
                
                currentDealnameArray = DealnameArray
                currentDeallogoArray = DeallogoArray
                currentDealLocationArray = DealLocationArray
                currentDealcashbackArray = DealcashbackArray
                currentDealStartDateArray = DealStartDateArray
                currentDealEndDateArray = DealEndDateArray
            }
            
            else{
                
                
                    
                    //searchidentity = ""
                    // Nodeallabel.isHidden = true
                    Nodealslabel1.isHidden = true
                    hideLoading()
                    pickeridentity = "NO"
                    //Dealalertlabel.text = "Load More"
                    responseArray = data1 as! NSArray
                    print("responseArray1  :", responseArray)
                    TotalDealnamearray = responses["responseData"]?.value(forKey: "entityName") as! [AnyObject]
                    TotalDealstartdatearray = responses["responseData"]?.value(forKey: "startDate") as! [String]
                    TotalDealenddatearray = responses["responseData"]?.value(forKey: "endDate") as! [String]
                    TotalDeallocationarray = responses["responseData"]?.value(forKey: "location") as! [String]
                    TotalDealcashbackarray = responses["responseData"]?.value(forKey: "cashBonus") as! [AnyObject]
                    TotalDeallogoarray = responses["responseData"]?.value(forKey: "icon") as! [AnyObject]
                    for var names in TotalDealnamearray {
                        
                        if names is NSNull{
                            names = "" as AnyObject
                            DealnameArray.append(Dealname(name: names as! String))
                        }else{
                            DealnameArray.append(Dealname(name: (names ) as! String))
                        }
                        
                    }
                for var logos in TotalDeallogoarray {
                    
                    if logos is NSNull || logos as! String == "some url"{
                        logos = "" as AnyObject
                        DeallogoArray.append(Deallogo(logo: logos as! String))
                    }else{
                        DeallogoArray.append(Deallogo(logo: (logos ) as! String))
                    }
                    
                }
                    for loc in TotalDeallocationarray {
                        DealLocationArray.append(DealLocation(location: loc))
                    }
                    for cash in TotalDealcashbackarray {
                        DealcashbackArray.append(Dealcashback(cashback: cash))
                    }
                    for start in TotalDealstartdatearray {
                        DealStartDateArray.append(DealStartDate(promotionstartdate: start))
                    }
                    for end in TotalDealenddatearray {
                        DealEndDateArray.append(DealEndDate(promotionenddate: end))
                    }
                    print("Deal total",DealnameArray.count)
                    //print(currentDeallogoArray)
                    currentDealnameArray = DealnameArray
                    currentDeallogoArray = DeallogoArray
                    currentDealLocationArray = DealLocationArray
                    currentDealcashbackArray = DealcashbackArray
                    currentDealStartDateArray = DealStartDateArray
                    currentDealEndDateArray = DealEndDateArray
                    Retailshoplist.reloadData()
                
               
            }
            
        }
        else if success == "1050"{
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
       // hideLoading()
//        indicator.stopAnimating()
//        indicator.isHidden = true
//        indicator.removeFromSuperview()
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        refreshControl.endRefreshing()
    }
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
        
        pickeridentity = "YES"
        Paginationidentity = "NO"
        searchidentity = ""
        
        self.citynamesIS = Totalcityarray[index]
        mySearchBar.text =  self.citynamesIS
        Constants.cityname = self.citynamesIS!
        
        self.CityLocation.text = Constants.cityname
        
        Database.set(Constants.cityname, forKey: Constants.citynamekey)
        Database.synchronize()
        
      //  Bgview.isHidden = true
        currentDealnameArray = [Dealname]()
        currentDeallogoArray = [Deallogo]()
        currentDealLocationArray = [DealLocation]()
        currentDealcashbackArray = [Dealcashback]()
        currentDealStartDateArray = [DealStartDate]()
        currentDealEndDateArray = [DealEndDate]()//update table
        
        DealnameArray = [Dealname]()
        DeallogoArray =  [Deallogo]()
        DealLocationArray = [DealLocation]()
        DealcashbackArray = [Dealcashback]()
        DealStartDateArray = [DealStartDate]()
        DealEndDateArray = [DealEndDate]()
        
        ConnecttoDealsAPISERVER()
    }
    
     //MARK: - SEARCH BAR DELEGATES
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentDealnameArray = DealnameArray.filter({ Dealname -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty {
                    return true
                    
                }
                let deal = Dealname.name.lowercased().contains(searchText.lowercased())
                
                if deal == true{
                    Constants.DealnameSearch = 1
                    Database.set(Constants.DealnameSearch, forKey: Constants.DealnameSearchKey)
                    Database.synchronize()
                }else{
                    Constants.DealnameSearch = 0
                    Database.set(Constants.DealnameSearch, forKey: Constants.DealnameSearchKey)
                    Database.synchronize()
                }
                print(deal)
                return deal
            default:
                
                return false
            }
        })
        
        print(currentDealnameArray.count)
        mySearchBar.suggestionsShadow.isHidden = true
        searchidentity = "Seaching store names"
        Retailshoplist.reloadData()
    }
    // When button "Search" pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("end searching --> Close Keyboard")
        self.mySearchBar.endEditing(true)
        print("Value",searchBar.text!)
        searchidentity = ""
        let searchtext: String = searchBar.text!
        self.citynamesIS = searchtext
        Constants.searchcityname = self.citynamesIS!
        Database.set(Constants.searchcityname, forKey: Constants.searchcitynamekey)
        Database.synchronize()
        
        currentDealnameArray = [Dealname]()
        currentDeallogoArray = [Deallogo]()
        currentDealLocationArray = [DealLocation]()
        currentDealcashbackArray = [Dealcashback]()
        currentDealStartDateArray = [DealStartDate]()
        currentDealEndDateArray = [DealEndDate]()//update table
        
        DealnameArray = [Dealname]()
        DeallogoArray =  [Deallogo]()
        DealLocationArray = [DealLocation]()
        DealcashbackArray = [Dealcashback]()
        DealStartDateArray = [DealStartDate]()
        DealEndDateArray = [DealEndDate]()
        
        ConnecttoDealsAPISERVER1()
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentDealnameArray = DealnameArray
        default:
            break
        }
        Retailshoplist.reloadData()
    }
     //MARK: -  TableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDealnameArray.count
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((Retailshoplist.contentOffset.y + Retailshoplist.frame.size.height) >= Retailshoplist.contentSize.height)
        {
            let lastSectionIndex = Retailshoplist.numberOfSections - 1
            let lastRowIndex = Retailshoplist.numberOfRows(inSection: lastSectionIndex) - 1
            if 0 ==  lastSectionIndex && tags1 == lastRowIndex {
                let totalRow =  Retailshoplist.numberOfRows(inSection: 0)//first get total rows in that section by current indexPath.
                if(tags1 == totalRow - 1)
                {
                    
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: Retailshoplist.bounds.width, height: CGFloat(44))
                    self.Retailshoplist.tableFooterView = spinner
                    self.Retailshoplist.tableFooterView?.isHidden = false
                    if responseArray.count != 0{
                        print("pageNo Before",self.pageNo)
                        isDataLoading = true
                        self.pageNo=self.pageNo+1
                        print("pageNo After",self.pageNo)
                        Paginationidentity = "YES"
                        spinner.startAnimating()
                        ConnecttoDealsAPISERVER()
                    }
                }
                
            }
        }
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Retailshoplistcell", for: indexPath) as! Retailshoplistcell
        cell.Storename.text = currentDealnameArray[indexPath.row].name
        let Enddatestring : String = String(format: "%@", currentDealEndDateArray[indexPath.row].promotionenddate)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date1 = dateFormatter1.date(from: Enddatestring)
        dateFormatter1.dateFormat = "MM-dd-yy"///this is what you want to convert format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp1 = dateFormatter1.string(from: date1!)
        cell.Location.text =  timeStamp1
        print(currentDeallogoArray)
        let deallogourl = currentDeallogoArray[indexPath.row].logo

        if deallogourl == "" {
             cell.deallogoimgvw.image = UIImage(named:"nlogo.jpg")
        }else{
            
            let url = URL(string: deallogourl )
            cell.deallogoimgvw.sd_setImage(with: url)
        }
        cell.Cashback.text = "Active"
        cell.Promotiondate.text = String(format: "up to $%.2f", currentDealcashbackArray[indexPath.row].cashback.floatValue)
        tags1 = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let alert = UIAlertController(title: "Confirm" , message: "Are you sure you want to navigate to this deal location?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
           
        })
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            // if GoogleMap installed
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=\(self.lat),\(self.long)&daddr=\(40.7128),\(74.0060)&directionsmode=driving")! as URL)
                
            } else {
                // if GoogleMap App is not installed
                UIApplication.shared.openURL(NSURL(string:
                    "https://www.google.co.in/maps/dir/?saddr=\(self.lat),\(self.long)&daddr=\(40.7128),\(74.0060)&directionsmode=driving")! as URL)
            }
        })
        
        self.present(alert, animated: true, completion: nil)
     
        
        
 }
    //MARK: -  Activity Indicator
    func hideLoading(){
         indicator.removeFromSuperview()
         indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.blue
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self.view, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(yCenterConstraint)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isnewrecord:Int = (Database.value(forKey: Constants.NewrecordKey)  as? Int)!
        if isnewrecord != 1{
            self.view.endEditing(true)
            self.Retailshoplist.endEditing(true)
            self.mySearchBar.endEditing(true)
            self.searchbar?.resignFirstResponder()
            searchidentity = ""
        }
    }
  
    @IBAction func Settingss(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 4
    }
    @IBAction func GotoSettings(_ sender: Any) {
        
        
    }
    
    //MARK: - LOCATION PICKER ACTION
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
        pickeridentity = "NO"
        Paginationidentity = "NO"
        searchidentity = ""
        currentDealnameArray = [Dealname]()
        currentDealLocationArray = [DealLocation]()
        currentDealcashbackArray = [Dealcashback]()
        currentDealStartDateArray = [DealStartDate]()
        currentDealEndDateArray = [DealEndDate]()//update table
        DealnameArray = [Dealname]()
        DealLocationArray = [DealLocation]()
        DealcashbackArray = [Dealcashback]()
        DealStartDateArray = [DealStartDate]()
        DealEndDateArray = [DealEndDate]()
        self.pageNo = 0
        self.limit = 15
        
        if item == "No search results found!" {
             Nodealslabel1.isHidden = false
             Nodealslabel1.text = ("No search results found!")
        }else{
            mySearchBar.text = item
            Constants.cityname = item
            self.CityLocation.text = Constants.cityname
            Database.set(Constants.cityname, forKey: Constants.citynamekey)
            Database.synchronize()
            ConnecttoDealsAPISERVER()
        }
    }
}

//MARK: - DEALS LIST NAME,LOGO,LOACTION,DATE INSTANCE
class Dealname {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class Deallogo {
    let logo: String
    init(logo: String) {
        self.logo = logo
    }
}
class DealLocation {
    let location: String
    init(location: String){
        self.location = location
    }
}
class Dealcashback {
    let cashback: AnyObject
    init(cashback: AnyObject){
        self.cashback = cashback
    }
}
class DealStartDate {
    let promotionstartdate: String
    init(promotionstartdate: String){
        self.promotionstartdate = promotionstartdate
    }
}
class DealEndDate {
    let promotionenddate: String
    init(promotionenddate: String){
        self.promotionenddate = promotionenddate
    }
}
class Test_View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        let color:UIColor = UIColor.yellow
        let drect = CGRect(x: 0,y: 0,width: 320,height: 100)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        color.set()
        bpath.stroke()
        NSLog("drawRect has updated the view")
        
    }
    
}
