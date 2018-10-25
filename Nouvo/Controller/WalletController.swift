//
//  WalletController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
import MXParallaxHeader
import ImageIO
import GoogleSignIn
class WalletController: UIViewController,UITableViewDelegate,UITableViewDataSource,MXParallaxHeaderDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var Cashback: UILabel!
    @IBOutlet var Level: UILabel!
    @IBOutlet var Levelmode: UILabel!
    @IBOutlet var HeaderView: UIView!
    var creditCardValidator: CreditCardValidator!
    @IBOutlet weak var profileimageview: UIImageView!
    @IBOutlet weak var Progressview: LinearProgressView!
    @IBOutlet weak var NameofSwipe: UILabel!
    @IBOutlet weak var CityLocation: UILabel!
    @IBOutlet weak var WalletView: UIView!
    @IBOutlet weak var CreditorDebitHeader: UILabel!
    @IBOutlet weak var BankCardNumberTV: UITableView!
    let fontswipe = FontSwipe()
    var fontData = [[:]]
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    var lat = String()
    var long = String()
    var DeleteCardID = String()
    var TotalCardNumberarray = [String]()
    var TotalCardNamearray = [String]()
    var CardID = [NSNumber]()
    var responseArray = [String]()
    var selectedArray = [[String: AnyObject]]()
    var image = UIImage()
//MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "WALLET"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let city: String?
        city = Database.value(forKey: Constants.citynamekey) as? String
        if  city == "" || city == nil{
            CityLocation.text = ""
        }else{
            let city:String = (Database.value(forKey: Constants.citynamekey)  as? String)!
            CityLocation.text = city
        }
        
        let Balance:String = (Database.value(forKey: Constants.WalletBalancekey)  as? String)!
        Cashback.text = Balance
        ConnecttoWalletCARD()
    }
    //MARK: - VIEWDIDAPPEAR
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
         
        }
        ConnectivityNetworkCheck()
        ConnecttoWalletCARD()
    }
    //MARK: - SETUP UI
    func configureHeader() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        customView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 200, height: 46))
        label.textAlignment = .left
        label.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        let string = "Credit/Debit Cards"
        let fontNuovo = CardIconFont()
        label.font = fontNuovo.fontOfSize(18)
        label.text = "\(fontNuovo.stringWithName(.Cardicon))\(" ")\(string)"
        label.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        let label1 = UILabel(frame: CGRect(x: 5, y: 48, width: self.view.frame.size.width-10, height: 0.7))
        label1.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        customView.addSubview(label1)
        customView.addSubview(label)
        BankCardNumberTV.tableHeaderView = customView
    }
    //MARK: - REFRESH ACTION
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.ForceUpdatetoUserAPIWithLoginwallet()
            DispatchQueue.main.async {
                
            }
        }
    }
    //MARK: - SETUP REFRESH
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(WalletController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        return refreshControl
    }()
    //MARK: - SERVER REQUEST FOR REFRESH ACTION
    func ForceUpdatetoUserAPIWithLoginwallet()  {
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        ForceUpdatewithLoginApiInputBodywallet()
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.InitSwipeURL
        RequestManager.PostPathwithAUTH(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.ForceUpdateWithLoginResponses(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func ForceUpdateWithLoginResponses(response: [String : AnyObject]) {
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
            ConnecttoWalletCARD()
            
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
           // hideLoading()
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
   //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let city: String?
        city = Database.value(forKey: Constants.citynamekey) as? String
        if  city == "" || city == nil{
            CityLocation.text = ""
        }else{
            let city:String = (Database.value(forKey: Constants.citynamekey)  as? String)!
            CityLocation.text = city
        }
        let Balance:String = (Database.value(forKey: Constants.WalletBalancekey)  as? String)!
        Cashback.text = Balance
        self.navigationController?.navigationBar.topItem?.title = "WALLET"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        BankCardNumberTV.parallaxHeader.view = HeaderView // You can set the parallax header view from the floating view
        BankCardNumberTV.parallaxHeader.height = 180
        BankCardNumberTV.parallaxHeader.minimumHeight = 0
        BankCardNumberTV.parallaxHeader.mode = MXParallaxHeaderMode.fill
        BankCardNumberTV.parallaxHeader.delegate = self
        BankCardNumberTV.parallaxHeader.view = self.refreshControl
        configureHeader()
        creditCardValidator = CreditCardValidator()
        Progressview.animationDuration = 0.5
        Progressview.minimumValue = Float(Constants.minlevel)
        Progressview.maximumValue = Float(Constants.maxlevel)
        Progressview.setProgress(Float(Constants.userlevel) , animated: true)
        Level.text = String(format: "Level %d", Constants.level)
        Levelmode.text = String(format: "%d/%d", Constants.minlevel,Constants.maxlevel)
        BankCardNumberTV.register(UINib(nibName: "WalletCardsCell", bundle: nil),
                           forCellReuseIdentifier: "WalletCardsCell")
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameofSwipe.text = string2
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        setUpNavBar()
        ConnectivityNetworkCheck()
        ConnecttoWalletCARD()
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
    // MARK: - Parallax header delegate setupParallaxHeaders
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
    }
    //MARK: - WALLET SERVER REQUEST
    func ConnecttoWalletCARD(){
        
        WalletCARDAPIInputBody()
        let WalletCARDAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.GetCardURL
        RequestManager.PostPathwithAUTH(urlString: WalletCARDAPI, params: Input, successBlock:{
            (response) -> () in self.WalletCARDResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
    }
    func WalletCARDAPIInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": ""] as [String : AnyObject]
    }
    //MARK: -  Fetching WALLET data from server
    func WalletCARDResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
      ///  print("WalletCARDResponse  :", response)
        //Encryption value from response
        let encrypted:String = String(format: "%@", response["responseData"] as! String)
        // AES decryption
        let AES = CryptoJS.AES()
       // print(AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs"))
        var json = [[String : AnyObject]]()
        let decrypted = AES.decrypt(encrypted, password: "nn534oj90156fsd584sfs")
        if decrypted == "null"{}
        else{
            let objectData = decrypted.data(using: String.Encoding.utf8)
            json = try! JSONSerialization.jsonObject(with: objectData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : AnyObject]]
            //print(json)
        }
        var responses = [String : AnyObject]()
        responses = ["responseData" : json] as [String : AnyObject]
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
        TotalCardNumberarray = responses["responseData"]?.value(forKey: "cardNumber") as! [String]
        TotalCardNumberarray.append("Add New Card")
        CardID  = responses["responseData"]?.value(forKey: "id") as! [NSNumber]
        TotalCardNamearray = responses["responseData"]?.value(forKey: "nameOnCard") as! [String]
        TotalCardNamearray.append("Add New Card")
        BankCardNumberTV.reloadData()
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
           // hideLoading()
        }
        refreshControl.endRefreshing()
        
    }
    //MARK: - SETUP UI
    func setUpNavBar(){
            self.navigationController?.navigationBar.topItem?.title = "WALLET"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            let maskLayer = CAShapeLayer(layer: self.view.layer)
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint(x:0, y:0))
            arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
            arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:HeaderView.bounds.size.height - (HeaderView.bounds.size.height*0.2)))
            arrowPath.addQuadCurve(to: CGPoint(x:0, y:HeaderView.bounds.size.height - (HeaderView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:HeaderView.bounds.size.height))
            arrowPath.addLine(to: CGPoint(x:0, y:0))
            arrowPath.close()
            maskLayer.path = arrowPath.cgPath
            maskLayer.frame = self.view.bounds
            maskLayer.masksToBounds = true
            HeaderView.layer.mask = maskLayer
    }
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - TABLEVIEW DELEGATES
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TotalCardNumberarray.count
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsCell", for: indexPath) as! WalletCardsCell
        
        let a = ((TotalCardNumberarray[indexPath.row] as AnyObject) as? String)!
        let last4 = a.suffix(4)
        let b = ((TotalCardNamearray[indexPath.row] as AnyObject) as? String)!
        if a == "Add New Card"{
            cell.CardNumber.text = a
        }else{
           cell.CardNumber.text = b + " " + last4
        }
        if cell.CardNumber.text == "Add New Card" {
            //add_blue
            let yourImage: UIImage = UIImage(named: "add_blue")!
            cell.CardIcon.image = yourImage
            cell.CardIcon.frame.size.height = 28
        }else{
            detectCardNumberType(number: a)
            cell.CardIcon.image = image
            cell.CardIcon.frame.size.height = 20
        }
        
    return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedCell = tableView.cellForRow(at: indexPath) as! WalletCardsCell
        if selectedCell.CardNumber.text == "Add New Card" {
            
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view: AddCardController = storyboard.instantiateViewController(withIdentifier: "AddCardController") as! AddCardController
                self.navigationController?.pushViewController(view, animated: true)
            
            
           
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
                //TODO: Delete the row at indexPath here
                let alert = UIAlertController(title: "Delete Wallet Card" , message: "Are you sure you want to delete this card from your wallet?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
                { action -> Void in
                    // Put your code here
                    print("Index :",indexPath.row)
                    self.TotalCardNumberarray.remove(at: indexPath.row)
                    print("My ID :",self.CardID[indexPath.row])
                    self.DeleteCardID = String(format: "%@", self.CardID[indexPath.row] )
                    print("My CardID :",self.DeleteCardID )
                    self.BankCardNumberTV.deleteRows(at: [indexPath], with: .automatic)
                    self.DeleteCardAPI()
                })
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
                { action -> Void in })
                
                self.present(alert, animated: true, completion: nil)
                
               
               
                
            }
            deleteAction.backgroundColor = .red
            
            return [deleteAction]
        
        
       
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
       let name = ((TotalCardNumberarray[indexPath.row] as AnyObject) as? String)!
        if name == "Add New Card" {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let name = ((TotalCardNumberarray[indexPath.row] as AnyObject) as? String)!
        if name == "Add New Card" {
            return false
        } else {
            return true
        }
       
    }
    //MARK: - DETECT CARD TYPE
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            print(type.name)
            if type.name == "Visa"{
                image = UIImage(named: "Visa")!
                
            }else if type.name == "Amex"{
                image = UIImage(named: "Amex")!
                
            }else if type.name == "MasterCard"{
                image = UIImage(named: "MasterCard")!
                
            }else if type.name == "Maestro"{
                image = UIImage(named: "Maestro")!
                
            }else if type.name == "Diners Club"{
                image = UIImage(named: "DinersClub")!
                
            }else if type.name == "JCB"{
                image = UIImage(named: "JCB")!
                
            }else if type.name == "Discover"{
                image = UIImage(named: "Discover")!
                
            }else if type.name == "UnionPay"{
                image = UIImage(named: "UnionPay")!
                
            }else if type.name == "RuPay"{
                image = UIImage(named: "RuPay")!
                
            }
        }
    }
     //MARK: - DELETE CARD SERVER REQUEST
    func DeleteCardAPI()  {
        DeleteCARDAPIInputBody()
        let DeleteCARDAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.DeleteCardURL
        RequestManager.PostPathwithAUTH(urlString: DeleteCARDAPI, params: Input, successBlock:{
            (response) -> () in self.DeleteCARDResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
        
    }
    func DeleteCARDAPIInputBody()  {
        print("Deleted Card ID is :",self.DeleteCardID)
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
           "cardId": self.DeleteCardID as AnyObject
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
     //MARK: - DELETE CARD SERVER RESPONSE
    func DeleteCARDResponse(response: [String : AnyObject]){
        print("DeleteCARDResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            BankCardNumberTV.reloadData()
        }
        
    }

    @IBAction func SettingTap(_ sender: Any) {
       self.tabBarController?.selectedIndex = 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeindex"), object: nil)
       // self.RAMAnimatedTabBarController?.selectedIndex = 4
    }
    
}
