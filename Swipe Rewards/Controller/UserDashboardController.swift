//
//  UserDashboardController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import CoreLocation

class UserDashboardController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate,UIScrollViewDelegate {
    //MARK: -  Outlets and Instance
    
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
    let scrollViewContentHeight = 1200 as CGFloat
    //MARK: -  ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "HOME"
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
    //MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDashbaordHeaderView()
        InitializeLocationManager()
        ConnectivityNetworkCheck()
        ForceUpdatetoUserAPIWithLogin()
        Retailshoplist.register(UINib(nibName: "Retailshoplistcell", bundle: nil),
                               forCellReuseIdentifier: "Retailshoplistcell")
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameOfSwipe.text = string2
        
 
        
        
        
        
        
//        Progressview.layer.borderWidth = 1.5
//        Progressview.layer.cornerRadius = 5
//        Progressview.layer.borderColor = UIColor.white.cgColor
//        Progressview.clipsToBounds = true
        
        
    
        
        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        Heif.constant = Retailshoplist.contentSize.height
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
   
        
        let maxHeight: CGFloat = self.view.bounds.size.height - 64
        let minHeight:CGFloat = 200
        var height = self.Heif.constant + Scrollview.contentOffset.y
        
        if height > maxHeight {
            height = maxHeight
        }
        else if height < minHeight {
            height = minHeight
        }
        else{
            Scrollview.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        self.Heif.constant = Retailshoplist.contentSize.height
        Retailshoplist.frame.size.height = self.Heif.constant
      //  Scrollview.frame.size.height = self.Heif.constant + DashboardView.frame.size.height
        
        
        Scrollview.contentSize = CGSize(width: self.view.frame.size.width, height:Retailshoplist.frame.size.height + DashboardView.frame.size.height+120)
        
        print("height",height)
        
    }
    func ForceUpdatetoUserAPIWithLogin()  {
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        
        // To remove it, just call removeFromSuperview()
       //
        
        ForceUpdatewithLoginApiInputBody()
        let signInServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.InitSwipeURL
        RequestManager.PostPathwithAUTH(urlString: signInServer, params: Input, successBlock:{
            (response) -> () in self.ForceUpdateWithLoginResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}
    }
    func ForceUpdateWithLoginResponse(response: [String : AnyObject]) {
        print("ForceUpdateWithLoginResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            var generalsettings = [String : AnyObject]()
            generalsettings =  response["responseData"]?.value(forKey: "generalSettings") as! [String : AnyObject]
            let playstoreurl = generalsettings["playStoreURL"] as! String
            print("playstoreurl response :", playstoreurl)
            
            Constants.Privacy = generalsettings["privacySecurityUrl"] as! String
            Constants.Termsofuse = generalsettings["termsOfUseUrl"] as! String
            
            var userprofilesettings = [String : AnyObject]()
            var userlevelsettings = [String : AnyObject]()
         
            
            userprofilesettings =  response["responseData"]?.value(forKey: "userProfile") as! [String : AnyObject]
            userlevelsettings =  userprofilesettings["level"] as! [String : AnyObject]
            
            
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
            
            Database.set(Constants.minlevel, forKey: Constants.minlevelKey)
            Database.set(Constants.maxlevel, forKey: Constants.maxlevelKey)
            Database.set(Constants.userlevel, forKey: Constants.userlevelKey)
            Database.set(Constants.level, forKey: Constants.levelKey)
            
            
            Database.set(Constants.Privacy, forKey: Constants.Privacykey)
            Database.set(Constants.Termsofuse, forKey: Constants.Termsofusekey)
            Database.synchronize()

            ConnecttoDealsAPISERVER()
            //itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4
            //  UIApplication.shared.openURL(NSURL(string: playstoreurl)! as URL)
        }else{
        }
    }
    func ForceUpdatewithLoginApiInputBody()  {
        // Version 1.0
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "device_id": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "appVersionCode": appVersionString as AnyObject
            ]] as [String : AnyObject]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -  Daashboard HeaderView
    func setUpDashbaordHeaderView() {
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:DashboardView.bounds.size.height - (DashboardView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:DashboardView.bounds.size.height - (DashboardView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:DashboardView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        DashboardView.layer.mask = maskLayer
    }
    //MARK: - Initialize Core LocationManager
    func InitializeLocationManager()  {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
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
        showSpinning()
        DealsAPIInputBody()
        let DealsAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.DealsURL
        RequestManager.PostPathwithAUTH(urlString: DealsAPI, params: Input, successBlock:{
            (response) -> () in self.DealsResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
    }
    //MARK: - Deals API Input Body Parameter
    func DealsAPIInputBody(){
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "location": "new york" as AnyObject
            ]] as [String : AnyObject]
    }
    //MARK: -  Fetching Deals data from server
    func DealsResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
        print("DealsResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            let data1 = (response as NSDictionary).object(forKey: "responseData")
            responseArray = data1 as! NSArray
            print("responseArray1  :", responseArray)
            Retailshoplist.reloadData()
            updateViewConstraints()
            print("Tableview height  :", Retailshoplist.frame.size.height)
            
           // contentview.frame.size.height = Retailshoplist.contentSize.height+300
            Scrollview.contentSize.height =  self.view.frame.size.height + Retailshoplist.contentSize.height
            Retailshoplist.contentSize = CGSize(width: self.view.frame.size.width, height: Retailshoplist.contentSize.height)
            Heif.constant = Retailshoplist.contentSize.height
           // contentview.frame.size.height = Retailshoplist.frame.origin.y+Heif.constant
            //self.view.frame.size.height = Retailshoplist.frame.origin.y+Heif.constant
            Scrollview.contentSize = CGSize(width: self.view.frame.size.width, height:Heif.constant+DashboardView.frame.size.height+200)
            
            self.Scrollview.delaysContentTouches = true;
            self.Scrollview.canCancelContentTouches = false;
            print("Height  :",  Heif.constant)
            Scrollview.delegate = self
            Retailshoplist.delegate = self
            Retailshoplist.dataSource = self
            Scrollview.bounces = false
            Retailshoplist.bounces = false
            Retailshoplist.isScrollEnabled = false
            //contentview.addSubview(Retailshoplist)
           // Scrollview.addSubview(contentview)
           // self.view.addSubview(Scrollview)
            self.view.layoutIfNeeded()
            
        }else{
            hideLoading()
        }
        
    }
     //MARK: -  TableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Retailshoplistcell", for: indexPath) as! Retailshoplistcell
        cell.Storename.text = ((responseArray[indexPath.row] as AnyObject).value(forKey: "shortDescription") as? String)!
        cell.Location.text = ((responseArray[indexPath.row] as AnyObject).value(forKey: "location") as? String)!
        cell.Cashback.text = String(format: "%@%@", ((responseArray[indexPath.row] as AnyObject).value(forKey: "cashBonus") as? NSNumber)!,"%")
        
        let currentdatestring : String = String(format: "%@", ((responseArray[indexPath.row] as AnyObject).value(forKey: "startDate") as? String)!)
        print("current date:-",currentdatestring)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: currentdatestring)
        dateFormatter.dateFormat = "dd/MM/YYYY"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date!)
        print("timeStamp current date:-",timeStamp)
        
        let Enddatestring : String = String(format: "%@", ((responseArray[indexPath.row] as AnyObject).value(forKey: "startDate") as? String)!)
        print("end date:-",Enddatestring)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date1 = dateFormatter1.date(from: Enddatestring)
        dateFormatter1.dateFormat = "dd/MM/YYYY"///this is what you want to convert format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp1 = dateFormatter1.string(from: date1!)
        print("timeStamp end date:-",timeStamp1)
        cell.Promotiondate.text = timeStamp + "-" + timeStamp1
        
        
        
        return cell
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
        self.view.endEditing(true)
    }
    // When button "Search" pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("end searching --> Close Keyboard")
        self.searchbar.endEditing(true)
    }
}
