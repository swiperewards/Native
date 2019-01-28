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
    var suggestionList = Array<String>()
//    var refresh = Refresh
    @IBOutlet var profiletapbutton: UIButton!
    @IBOutlet var Nodealslabel1: UILabel!
    @IBOutlet var Nodeallabel: UILabel!
    //For Pagination
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
    var deallat = Double()
    var deallong = Double()
    var responseArray = NSArray()
    var responseArraycountzero = NSArray()
    var Totalcityarray = [String]()
    var TotalDealnamearray = [AnyObject]()
    var TotalDeallogoarray = [AnyObject]()
    var TotalDealstartdatearray = [String]()
    var TotalDealenddatearray = [String]()
    var TotalDeallocationarray = [String]()
    var TotalDealcashbackarray = [AnyObject]()
    var TotalDeallatarray = [AnyObject]()
    var TotalDeallongarray = [AnyObject]()
    var pickeridentity = String()
    var searchidentity = String()
    var Paginationidentity = String()
    var firsttimecallAPI = String()
    var refreshAPI = String()
    let scrollViewContentHeight = 1200 as CGFloat
    var Test_View = UIView()
    //MARK: -  ViewWillAppear
    
   
    @IBOutlet var Gest: UITapGestureRecognizer!
    
    @IBOutlet var HideBtn: UIButton!
    
    @IBAction func RefApplyTap(_ sender: Any) {
        referralbgviewview.isHidden = true
        //referralview.isHidden = true
        Referraltext.resignFirstResponder()
        
        //ApplyreferralcodeURL
        
        if Referraltext.text == "" || (Referraltext.text?.isEmpty)!{
            
            referralbgviewview.isHidden = false
           // referralview.isHidden = false
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
    func ApplyReferralcodeAPIInputBody() {
        
        
    
        let jsonObject: [String: AnyObject] = [
            "referredBy": textField.text as AnyObject
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
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "device_id": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
        
        
        
       
//        Input =  [
//            "deviceId": deviceid as AnyObject,
//            "lat": "" as AnyObject,
//            "long": "" as AnyObject,
//            "platform": "IOS" as AnyObject,
//            "requestData": [
//                "referredBy": textField.text as AnyObject
//            ]] as [String : AnyObject]
        
        
        
        print(textField.text!)
    }
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
//            let alert = UIAlertController(title: "Referral Code", message: "Invalid Referral code", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            
            
            textField.placeholder = "Invalid Referral code"
            hideLoading()
            referralbgviewview.isHidden = false
           // referralview.isHidden = false
            textField.becomeFirstResponder();
        }
        
//        Constants.Newrecord = 0
//        Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
//        Database.synchronize()
        
    }
    @IBAction func RefCancelTap(_ sender: Any) {
        Constants.Newrecord = 0
        Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
        Database.synchronize()
        referralbgviewview.isHidden = true
        //referralview.isHidden = true
        Referraltext.resignFirstResponder()
    }
    @IBAction func send(_ sender: Any) {
       // print("hi")
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeindex"), object: nil)
    }
    @IBAction func check(_ sender: Any) {
        
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
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        let token = Database.value(forKey: Constants.Tokenkey) as? String
//        if token == nil {
//            let alert = UIAlertController(title: "Your Session has Expired" , message: "Login", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: self.doSomething)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//        }
        
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
       // self.InitializeLocationManager()
            let city: String?
            city = Database.value(forKey: Constants.citynamekey) as? String
            if  city == "" || city == nil{
                //self.AskcitynameAPI()
               CityLocation.text = ""
            }
            else{
                 CityLocation.text = city
                 self.ConnecttoDealsAPISERVER()
               
            }
            
       
//        let Balance:String = (Database.value(forKey: Constants.WalletBalancekey)  as? String)!
//        Cashback.text = Balance
        
        let Balance: String?
        Balance = Database.value(forKey: Constants.WalletBalancekey) as? String
        if  Balance == "" || Balance == nil{
            Cashback.text = "$0.00"
        }else{
            Cashback.text = Balance
        }
        
        // level
        let leveldb: Int?
        leveldb = Database.value(forKey: Constants.levelKey) as? Int
        if  leveldb == nil {
            
        }else{
             Level.text = String(format: "Level %d", leveldb!)
        }
        
        var leveldbmin: Int?
        var leveldbmax: Int?
        leveldbmin = Database.value(forKey: Constants.minlevelKey) as? Int
        leveldbmax = Database.value(forKey: Constants.maxlevelKey) as? Int
        
        if leveldbmin == nil {
            
            leveldbmin = 0
        }
        if leveldbmax == nil {
            
            leveldbmax = 0
        }
        
        
        Levelmode.text = String(format: "%d/%d", leveldbmin!,leveldbmax!)
        
        
        
        
       
        
    }
//    private func makingSearchBarAwesome(){
//        self.modernSearchBar.backgroundImage = UIImage()
//        self.modernSearchBar.layer.borderWidth = 0
//        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
//    }
    
//    private func configureSearchBar(){
//
//        ///Create array of string
//        var suggestionList = Array<String>()
//        suggestionList.append("Onions")
//        suggestionList.append("Celery")
//        suggestionList.append("Very long vegetable to show you that cell is updated and fit all the row")
//        suggestionList.append("Potatoes")
//        suggestionList.append("Carrots")
//        suggestionList.append("Broccoli")
//        suggestionList.append("Asparagus")
//        suggestionList.append("Apples")
//        suggestionList.append("Berries")
//        suggestionList.append("Kiwis")
//        suggestionList.append("Raymond")
//
//        ///Adding delegate
//        self.modernSearchBar.delegateModernSearchBar = self
//
//        ///Set datas to search bar
//        self.modernSearchBar.setDatas(datas: suggestionList)
//
//
//
//
//        ///Custom design with all paramaters if you want to
//        //self.customDesign()
//
//    }
    // MARK: - Parallax header delegate
    
//    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
//        NSLog("progress %f", parallaxHeader.progress)
//    }
    //MARK: -  ViewDidLoa
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
//    @objc func closebackgroundview() {
//        Bgview.isHidden = true
//    }
    override func viewDidAppear(_ animated: Bool) {
        
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }
        else{
            
            
            
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            self.profileimageview.sd_setImage(with: url)
            
            // let data1 = NSData.init(contentsOf: url!)
            // if data1 != nil {
            // profileimageview.image = UIImage(data:data1! as Data)
            self.profileimageview.contentMode = .scaleAspectFill
            self.profileimageview.layer.borderWidth = 1.0
            self.profileimageview.layer.masksToBounds = false
            self.profileimageview.layer.borderColor = UIColor.white.cgColor
            self.profileimageview.layer.cornerRadius = self.profileimageview.frame.size.width / 2
            self.profileimageview.clipsToBounds = true
            //}
        }
    }
//    ///Handle click on shadow view
//    @objc func onClickShadowViews(){
//          Bgview.isHidden = true
//    }
    ///Handle click on shadow view
    @objc func closebackgroundviews(){
        self.Retailshoplist.endEditing(true)
        self.mySearchBar.endEditing(true)
        self.mySearchBar.resignFirstResponder()
    }
    
//    @objc func taps(){
//
//    }
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
//    func makeMock() {
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 64)
//        headerView.backgroundColor = UIColor.lightGray
//        self.view.addSubview(headerView)
//
//        let headerLine = UIView()
//        headerLine.frame = CGRect(x: 0, y: 0, width: 120, height: 8)
//        headerLine.layer.cornerRadius = headerLine.frame.height/2
//        headerLine.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        headerLine.center = CGPoint(x: headerView.frame.center.x, y: 20 + 44/2)
//        headerView.addSubview(headerLine)
//    }
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
       // self.showSpinning()
        self.InitializeLocationManager()
        self.ConnectivityNetworkCheck()
            DispatchQueue.main.async {

                refreshControl.endRefreshing()
                refreshControl.isHidden = true
              //  self.hideLoading()
            }
        }
        
        
        //self.Retailshoplist.reloadData()
       
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(UserDashboardController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        return refreshControl
    }()
    func FirebaseApiInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        print("deviceid :", deviceid!)
        
          //Database.set(Constants.fcmToken, forKey: Constants.fcmTokenkey)
        let token:String = (Database.value(forKey: Constants.fcmTokenkey) as? String)!
        let jsonObject: [String: AnyObject] = [
            "token": token as AnyObject
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
    func FirebasenotifyResponse(response: [String : AnyObject]){
        print("FirebasenotifyResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
        }
        
    }
    func checkreferral()  {
        var isnewrecord: Int?
        isnewrecord = Database.value(forKey: Constants.NewrecordKey) as? Int
        //let isnewrecord:Int = (Database.value(forKey: Constants.NewrecordKey)  as! Int)
        
       // isnewrecord = 1
        
        if isnewrecord == 1{
            FirebaseApiInputBody()
            let ForgotPasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.Firebasenotification
            RequestManager.PostPathwithAUTH(urlString: ForgotPasswordServer, params: Input, successBlock:{
                (response) -> () in self.FirebasenotifyResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in}
            
          
            
            let alert = UIAlertController(title: "Referral Code", message: "Have a referral code, apply it here to get the XP points!", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                self.referralbgviewview.isHidden = true
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
           
//            // Add 1 textField and customize it
//            alert.addTextField { textField in
//               // textField.keyboardAppearance = .dark
//              //  textField.keyboardType = .default
//                //textField.autocorrectionType = .default
//                textField.placeholder = "Enter Referral Code"
//               // textField.clearButtonMode = .whileEditing
////
////                textField.layer.masksToBounds = true
////                textField.layer.cornerRadius = 15.0
////                textField.layer.borderWidth = 0.5
//            }
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
        }
        else{
            FirebaseApiInputBody()
            let ForgotPasswordServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.Firebasenotification
            RequestManager.PostPathwithAUTH(urlString: ForgotPasswordServer, params: Input, successBlock:{
                (response) -> () in self.FirebasenotifyResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in}
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
                  //  self.present(alert, animated: true, completion: nil)
                    //Please enter your referral code!
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.ApplyReferralcodeAPIInputBody()
                    let ReferralAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.ApplyreferralcodeURL
                    RequestManager.PostPathwithAUTH(urlString: ReferralAPI, params: self.Input, successBlock:{
                        (response) -> () in self.ApplyReferralcodeResponse(response: response as! [String : AnyObject])})
                    { (error: NSError) ->() in }
                }
                
            })
            
           
            
            
            // Add 1 textField and customize it
            alert.addTextField { textField in
//                textField.keyboardAppearance = .dark
//                textField.keyboardType = .default
//                textField.autocorrectionType = .default
                textField.placeholder = "Enter Referral Code"
                //textField.clearButtonMode = .whileEditing
                
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DashboardView.isUserInteractionEnabled = true
        checkreferral()
        
      //  Database.set(Constants.Newrecord, forKey: Constants.NewrecordKey)
        
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        referralbgviewview.addSubview(blurEffectView)
        
//        referralbgviewview.isUserInteractionEnabled = false
//        referralview.isUserInteractionEnabled = true
//        referralview.layer.cornerRadius = 4.0
//        referralview.layer.borderWidth = 0.4
//        referralview.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        
            
            
//            referralbgviewview.isHidden = false
//            referralview.isHidden = false
//            Referraltext.becomeFirstResponder();
            
            
            

//        }else{
////            referralbgviewview.isHidden = true
////            referralview.isHidden = true
//        }
        
       
       // Retailshoplist.parallaxHeader.view?.addSubview(self.refreshControl)
       
//        gearRefreshControl.addTarget(self, action: #selector(UserDashboardController.refresh), for: UIControlEvents.valueChanged)
//        gearRefreshControl.gearTintColor = .red
//        self.refreshControl = gearRefreshControl
//
//        let bodyView = UIView()
//        bodyView.frame = self.view.frame
//        bodyView.frame.y += 20 + 44
//        self.view.addSubview(bodyView)
//
//        let tableViewWrapper = PullToBounceWrapper(scrollView: Retailshoplist)
//        bodyView.addSubview(tableViewWrapper)
//
//        tableViewWrapper.didPullToRefresh = {
//            _ = Timer.schedule(delay: 2) { timer in
//                tableViewWrapper.stopLoadingAnimation()
//            }
//        }

      //  makeMock()
//        DashboardView.addSubview(profiletapbutton)
//        headerview.addSubview(DashboardView)
//        profiletapbutton.addTarget(self,action:#selector(UserDashboardController.taps),
//                                   for:.touchUpInside)
//
        
       
        
//        // add gesture
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserDashboardController.taps))
//        tapGesture.numberOfTouchesRequired = 1
//        tapGesture.delegate = self
//        profileimageview.addGestureRecognizer(tapGesture)
//
        
        
        
      //#selector(YourClass.sayHello)
     
  
//        NotificationCenter.default.addObserver(self, selector: #selector(UserDashboardController.closebackgroundview), name: NSNotification.Name(rawValue: "CloseBackgroundview"), object: nil)

        
//       // addParallaxToView(vw: DashboardView)
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        Bgview.addSubview(blurEffectView)
        
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserDashboardController.closebackgroundviews))
//        tapGesture.cancelsTouchesInView = true
//        Retailshoplist.addGestureRecognizer(tapGesture)
//
        
       // Bgview.addSubview(HideBtn)
    
        
       // Bgview.isHidden = true
      //  HideBtn.isHidden = true
        Nodealslabel1.isHidden = true
        
        
        
        Nodealslabel1.layer.cornerRadius = 5
//        Nodeallabel.layer.cornerRadius = 5
//        Nodeallabel.layer.masksToBounds = true
        Nodealslabel1.layer.masksToBounds = true
        configureSearchController()
        Retailshoplist.parallaxHeader.view?.isUserInteractionEnabled = true
        Retailshoplist.parallaxHeader.view = headerview // You can set the parallax header view from the floating view
        Retailshoplist.parallaxHeader.height = 180
        Retailshoplist.parallaxHeader.minimumHeight = 0
        Retailshoplist.parallaxHeader.mode = MXParallaxHeaderMode.center
        Retailshoplist.parallaxHeader.delegate = self
        Retailshoplist.parallaxHeader.view = self.refreshControl
        
        
        
        
//        Retailshoplist.cr.addHeadRefresh(animator: refresh.header.commont()) { [weak self] in
//            print("开始刷新")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self?.pageNo = 0
//                self?.Retailshoplist.cr.endHeaderRefresh()
//                self?.Retailshoplist.cr.resetNoMore()
//                self?.Retailshoplist.reloadData()
//            })
//        }
//
      //  Retailshoplist.parallaxHeader.view?.backgroundColor = UIColor.blue
       

//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        button.setTitle("Submit", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        Retailshoplist.tableHeaderView = customView

        
        setUpDashbaordHeaderView()
        InitializeLocationManager()
        ConnectivityNetworkCheck()
        
       // self.makingSearchBarAwesome()
        //self.configureSearchBar()
        
      
        Retailshoplist.register(UINib(nibName: "Retailshoplistcell", bundle: nil),
                               forCellReuseIdentifier: "Retailshoplistcell")
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameOfSwipe.text = string2.capitalized
        //registerForKeyboardNotifications()
    }
    
    

    func configureSearchController() {
        // make UISearchBar instance
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        customView.backgroundColor = UIColor.white
        mySearchBar = ModernSearchBar(frame: CGRect(x: 8, y: 0, width: self.view.frame.size.width-16, height: 40))
        mySearchBar.placeholder = "Search Store/Location"
        mySearchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

       // mySearchBar.searchLabel_textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        mySearchBar.tintColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        mySearchBar.barTintColor = UIColor.white
        mySearchBar.layer.borderWidth = 0.7;
        mySearchBar.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        mySearchBar.layer.cornerRadius = 15.0;
        mySearchBar.delegateModernSearchBar = self as ModernSearchBarDelegate
        customView.addSubview(mySearchBar)
        
        
       // Retailshoplist.style = .grouped
        Retailshoplist.tableHeaderView = customView
       // viewDidLayoutSubviews()
    }
    // MARK: - Parallax header delegate setupParallaxHeaders
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
       // NSLog("progress %f", parallaxHeader.progress)
    }
   
    override func updateViewConstraints() {
        super.updateViewConstraints()
      //  Heif.constant = Retailshoplist.contentSize.height
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        //print("Table Y Value",Retailshoplist.contentOffset.y)
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//       // print("scrollViewWillBeginDragging")
//        isDataLoading = false
//    }
//
//    //Pagination
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        print("scrollViewDidEndDragging")
//
//
//
//
//    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")

        //ConnecttoDealsAPISERVER()
    }
//
//
//        let maxHeight: CGFloat = self.view.bounds.size.height - 64
//        let minHeight:CGFloat = 200
//        var height = self.Heif.constant + Scrollview.contentOffset.y
//
//        if height > maxHeight {
//            height = maxHeight
//        }
//        else if height < minHeight {
//            height = minHeight
//        }
//        else{
//
//             print("Y axis of scrollview",Scrollview.frame.origin.y)
//
//           // Scrollview.frame.origin.y
//
//            if scrollView.frame.origin.y == -180{
//                 Scrollview.contentOffset = CGPoint(x: 0, y: -180)
//            }
//            else{
//                 Scrollview.contentOffset = CGPoint(x: 0, y: 0)
//            }
//
//
//        }
//
//        self.Heif.constant = Retailshoplist.contentSize.height
//        Retailshoplist.frame.size.height = self.Heif.constant
//      //  Scrollview.frame.size.height = self.Heif.constant + DashboardView.frame.size.height
//
//
//        Scrollview.contentSize = CGSize(width: self.view.frame.size.width, height:Retailshoplist.frame.size.height + Strechview.frame.size.height+36)
//
//        print("height",height)
//        print("Scrollview  y axis point ",Scrollview.contentOffset.y)
//        print("Scrollview  y axis point ",Scrollview.contentOffset.y)
//        print("DashboardView y axis point",Strechview.frame.origin.y)
//
////        var y = Scrollview.contentOffset.y
////        if  y > 170 {
////
////
////        }else{
////
////            y = 0
////        }
//
//
//        let y = 300 - (Scrollview.contentOffset.y + 300)
//        let heights = min(max(y, 60), 400)
//        Strechview.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: heights)
//      //  lblName.frame = CGRect(x: 20, y: height - 30, width: 200, height: 22)
//
    //}
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
                    let cash: Double?
                    cash = wallet as? Double
                    Cashback.text = String(format:"$%.2f", cash!)
                    
                    print(Cashback.text)

                    //Cashback.text = ("$\(wallet)")
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
                   // print(self.citynamesIS as! String)
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
        }else{
            ForceUpdatetoUserAPIWithLogin()
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
        if self.citynamesIS == "" && self.citynamesIS == "nil" || self.citynamesIS == "nil" || self.citynamesIS == "<null>" ||  self.citynamesIS == nil{
            self.citynamesIS = nil
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
        if self.citynamesIS == "" && self.citynamesIS == "nil" || self.citynamesIS == "nil" || self.citynamesIS == "<null>" ||  self.citynamesIS == nil {
            self.citynamesIS = nil
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
                            if self.citynamesIS == nil{
                                 Nodealslabel1.text = ("Please Enable Your Location Services")
                            }else{
                                 Nodealslabel1.text = ("No stores available for \(self.citynamesIS!) yet. Please change the location/city.")
                            }
                            
                       
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
                TotalDeallatarray = responses["responseData"]?.value(forKey: "latitude") as! [AnyObject]
                TotalDeallongarray = responses["responseData"]?.value(forKey: "longitude") as! [AnyObject]
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
            TotalDeallatarray = responses["responseData"]?.value(forKey: "latitude") as! [AnyObject]
            TotalDeallongarray = responses["responseData"]?.value(forKey: "longitude") as! [AnyObject]
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
//         print(currentDealnameArray)
//
//
//
//        if currentDealnameArray.count == 0 {
//            self.suggestionList.append("No Stores found!")
//            self.mySearchBar?.setDatas(datas: self.suggestionList)
//        }
//        
        
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
        return 90
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
       
        print(currentDeallogoArray)
        let deallogourl =  currentDeallogoArray[indexPath.row].logo

        if deallogourl == "" {
             cell.deallogoimgvw.image = UIImage(named:"nlogo.jpg")
        }else{
            
            let url = URL(string: deallogourl )
            cell.deallogoimgvw.sd_setImage(with: url)
        }
        
        
      //  cell.Cashback.text = "Active"
        
        let pool =  currentDealcashbackArray[indexPath.row].cashback.floatValue
        
        if pool == 0  {
            
            
            let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.green]
            
            let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)]
            let attributedString1 = NSMutableAttributedString(string:"", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:"Upto 25% Cashback", attributes:attrs2)
            attributedString1.append(attributedString2)
            cell.Cashback.attributedText = attributedString1
            cell.Promotiondate.text =  "Available until " + timeStamp1
        }else{
            
            
            let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.green]
            
            let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)]
            
            let attributedString1 = NSMutableAttributedString(string:"", attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:String(format: "$%.2f", currentDealcashbackArray[indexPath.row].cashback.floatValue), attributes:attrs2)
            
            attributedString1.append(attributedString2)
            
            
            cell.Cashback.attributedText = attributedString1
            
            cell.Promotiondate.text =  "Available on " + timeStamp1
            
            //cell.Cashback.text = String(format: "$%.2f", currentDealcashbackArray[indexPath.row].cashback.floatValue)
        }
        
        
        
        tags1 = indexPath.row
        
        
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        
        
        
       
        
        
//        if indexPath.row == lastRowIndex { // last cell
//             // more items to fetch
//                loadItem() // increment `fromIndex` by 20 before server call
//            }
//        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
        //  print(TotalDeallatarray[indexPath.row])
        
        
        
        
        let lat: Double?
        lat = TotalDeallatarray[indexPath.row] as? Double
        if  lat == 0 || lat == nil{
            self.deallat = 0
            self.deallong = 0
            
             self.showToast(message: "Sorry, we are unable to navigate you to this store location.")
            
            
        }else{
                    self.deallat = TotalDeallatarray[indexPath.row]  as! Double
                    self.deallong = TotalDeallongarray[indexPath.row]  as! Double
            
            
            let alert = UIAlertController(title: "Confirm" , message: "Are you sure you want to navigate to this deal location?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
            { action -> Void in
                
            })
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
            { action -> Void in
                // if GoogleMap installed
                
                // self.ConvertLatandLongtoCityName()
                
                print(self.deallat,self.deallong)
                
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=\(self.lat),\(self.long)&daddr=\(self.deallat),\(self.deallong)&directionsmode=driving")! as URL)
                    
                } else {
                    // if GoogleMap App is not installed
                    UIApplication.shared.openURL(NSURL(string:
                        "https://www.google.co.in/maps/dir/?saddr=\(self.lat),\(self.long)&daddr=\(self.deallat),\(self.deallong)&directionsmode=driving")! as URL)
                }
            })
            
            self.present(alert, animated: true, completion: nil)
        }
        

        
       
       
        
        
 }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-140, y: self.view.frame.size.height-150, width: 270, height: 60))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 1.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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
        if isnewrecord == 1{
            
        }else{
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
    
    ///Called if you use String suggestion list
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
    
    
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.modernSearchBar.delegateModernSearchBar?.searchBarTextDidBeginEditing!(searchBar)
//    }
    
//
//    func registerForKeyboardNotifications(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    @objc func keyboardWasShown(notification: NSNotification){
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 180, 0.0)
////       Scrollview.contentInset = contentInsets
////       Scrollview.scrollIndicatorInsets = contentInsets
////
////
////        print("Scrollview Top serachbar :",-Strechview.frame.size.height)
////
////        Scrollview.frame.origin.y = -Strechview.frame.size.height
////
//      //   print("Scrollview  :",Scrollview.frame.origin.y)
//
//      //  modernSearchBar.frame.origin.y = -DashboardView.frame.size.height+20
//
//    }
//
//    @objc func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -180, 0.0)
////        Scrollview.contentInset = contentInsets
////        Scrollview.scrollIndicatorInsets = contentInsets
////
//         Retailshoplist.frame.origin.y = -130
//          Retailshoplist.contentSize = CGSize(width: self.view.frame.size.width, height:Retailshoplist.frame.size.height + headerview.frame.size.height+36)
//
//
//    }
//
//
    
}
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
        let h = rect.height
        let w = rect.width
        let color:UIColor = UIColor.yellow
        
        let drect = CGRect(x: 0,y: 0,width: 320,height: 100)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
        NSLog("drawRect has updated the view")
        
    }
    
}
//struct Refresh {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    var header: Style
//    var footer: Style
//    enum Style {
//        // 普通刷新类
//        case nomalHead
//        case nomalFoot
//        // slackLoading刷新控件
//        case slackLoading
//        // ramotion动画
//        case ramotion
//        // fast动画
//        case fast
//
//        func commont() -> CRRefreshProtocol {
//            switch self {
//            case .nomalHead:
//                return NormalHeaderAnimator()
//            case .nomalFoot:
//                return NormalFooterAnimator()
//            case .slackLoading:
//                return SlackLoadingAnimator()
//            case .ramotion:
//                return RamotionAnimator()
//            case .fast:
//                return FastAnimator()
//            }
//        }
//    }
//}
//
