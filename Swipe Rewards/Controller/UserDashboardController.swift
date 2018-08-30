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


class UserDashboardController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate,UIScrollViewDelegate,ModernSearchBarDelegate,MXParallaxHeaderDelegate,UISearchDisplayDelegate,TCPickerViewOutput {
    
    
    @IBOutlet var Nodealslabel1: UILabel!
    @IBOutlet var Nodeallabel: UILabel!
    //For Pagination
    @IBOutlet var Bgview: UIView!
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=15
    var citynamesIS : String?
    var picker: TCPickerViewInput = TCPickerView()
    var DealnameArray = [Dealname]()
    var DealLocationArray = [DealLocation]()
    var DealcashbackArray = [Dealcashback]()
    var DealStartDateArray = [DealStartDate]()
    var DealEndDateArray = [DealEndDate]()
    
     var currentDealnameArray = [Dealname]()
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
    var TotalDealnamearray = [String]()
    var TotalDealstartdatearray = [String]()
    var TotalDealenddatearray = [String]()
    var TotalDeallocationarray = [String]()
    var TotalDealcashbackarray = [AnyObject]()
    var pickeridentity = String()
    var Paginationidentity = String()
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
    
    @objc func closebackgroundview() {
        Bgview.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //#selector(YourClass.sayHello)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserDashboardController.closebackgroundview), name: NSNotification.Name(rawValue: "CloseBackgroundview"), object: nil)

        
       // addParallaxToView(vw: DashboardView)
        
        Bgview.isHidden = true
        Nodealslabel1.isHidden = true
        
        Nodealslabel1.layer.cornerRadius = 5
        Nodeallabel.layer.cornerRadius = 5
        Nodeallabel.layer.masksToBounds = true
        Nodealslabel1.layer.masksToBounds = true

        
        Retailshoplist.parallaxHeader.view = headerview // You can set the parallax header view from the floating view
        Retailshoplist.parallaxHeader.height = 180
        Retailshoplist.parallaxHeader.minimumHeight = 0
        Retailshoplist.parallaxHeader.mode = MXParallaxHeaderMode.fill
        Retailshoplist.parallaxHeader.delegate = self
       

//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        button.setTitle("Submit", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        Retailshoplist.tableHeaderView = customView

        
        setUpDashbaordHeaderView()
        InitializeLocationManager()
        ConnectivityNetworkCheck()
        ForceUpdatetoUserAPIWithLogin()
       // self.makingSearchBarAwesome()
        //self.configureSearchBar()
        
      
        Retailshoplist.register(UINib(nibName: "Retailshoplistcell", bundle: nil),
                               forCellReuseIdentifier: "Retailshoplistcell")
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameOfSwipe.text = string2
        //registerForKeyboardNotifications()
    }
    
    

    func configureSearchController() {
        // make UISearchBar instance
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        customView.backgroundColor = UIColor.white
        mySearchBar = ModernSearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        mySearchBar.placeholder = " Search Deals/ Location"
        mySearchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

        mySearchBar.tintColor = UIColor.white
        mySearchBar.barTintColor = UIColor.white
        mySearchBar.layer.borderWidth = 2.0;
        mySearchBar.layer.borderColor = UIColor.white.cgColor
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
//        if ((Retailshoplist.contentOffset.y + Retailshoplist.frame.size.height) >= Retailshoplist.contentSize.height)
//        {
//
//
//
//        }
//
//
//    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
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
            
            AskcitynameAPI()

           // ConnecttoDealsAPISERVER()
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
            "requestData": [
            ]] as [String : AnyObject]
    }
    func GetcityResponse(response: [String : AnyObject]) {
       // print("GetcityResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
        Totalcityarray = response["responseData"]?.value(forKey: "name") as! [String]
            
           var suggestionList = Array<String>()
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
                
                self.citynamesIS = city
                print(self.citynamesIS as! String)
                Constants.cityname = self.citynamesIS!
                Database.set(Constants.cityname, forKey: Constants.citynamekey)
                Database.synchronize()
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
            
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
        
        DealsAPIInputBody()
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
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "location": self.citynamesIS as AnyObject,
                "pageNumber": self.pageNo as AnyObject,
                "pageSize": self.limit as AnyObject
            ]] as [String : AnyObject]
        
        print(Input)
    }
    //MARK: -  Fetching Deals data from server
    func DealsResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        print("DealsResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            hideLoading()
            let data1 = (response as NSDictionary).object(forKey: "responseData")
            responseArraycountzero = data1 as! NSArray
            if responseArraycountzero.count == 0{
                
                if Paginationidentity == "YES"{
                    
                    self.pageNo = self.pageNo - 1
                    print("pageNo afterr",self.pageNo)
                    
                }else{
                    if pickeridentity == "YES"  {
                        Nodeallabel.isHidden = false
                        Nodealslabel1.isHidden = false
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
                        Retailshoplist.reloadData()
                        
                        hideLoading()
                    }else{
                        Bgview.isHidden = false
                        Nodeallabel.isHidden = true
                        Nodealslabel1.isHidden = true
                        picker.title = "Stores Not Available,Please Change Your City"
                        let values = Totalcityarray.map { TCPickerView.Value(title: $0) }
                        picker.values = values
                        picker.delegate = self as? TCPickerViewOutput
                        picker.selection = .single
                        picker.completion = { (selectedIndexes) in
                            for i in selectedIndexes {
                                print(values[i].title)
                                self.citynamesIS = values[i].title
                            }}
                        picker.show()
                    }
                    
                }
                
            }else{
                Nodeallabel.isHidden = true
                Nodealslabel1.isHidden = true
                hideLoading()
                pickeridentity = "NO"
                //Dealalertlabel.text = "Load More"
                responseArray = data1 as! NSArray
                print("responseArray1  :", responseArray)
                TotalDealnamearray = response["responseData"]?.value(forKey: "shortDescription") as! [String]
                TotalDealstartdatearray = response["responseData"]?.value(forKey: "startDate") as! [String]
                TotalDealenddatearray = response["responseData"]?.value(forKey: "endDate") as! [String]
                TotalDeallocationarray = response["responseData"]?.value(forKey: "location") as! [String]
                TotalDealcashbackarray = response["responseData"]?.value(forKey: "cashBonus") as! [AnyObject]
                
                for names in TotalDealnamearray {
                    DealnameArray.append(Dealname(name: names))
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
                
                
                currentDealnameArray = DealnameArray
                currentDealLocationArray = DealLocationArray
                currentDealcashbackArray = DealcashbackArray
                currentDealStartDateArray = DealStartDateArray
                currentDealEndDateArray = DealEndDateArray
                
                
                Retailshoplist.reloadData()
            }
            
        }else{
            
            hideLoading()
        }
        
    }
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
        
        pickeridentity = "YES"
        Paginationidentity = "NO"
        
        self.citynamesIS = Totalcityarray[index]
        mySearchBar.text =  self.citynamesIS
        Constants.cityname = self.citynamesIS!
        Database.set(Constants.cityname, forKey: Constants.citynamekey)
        Database.synchronize()
        
      //  Bgview.isHidden = true
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
        
        ConnecttoDealsAPISERVER()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentDealnameArray = DealnameArray.filter({ Dealname -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
              
                return Dealname.name.lowercased().contains(searchText.lowercased())
            default:
                
                return false
            }
        })
        
        
        mySearchBar.suggestionsShadow.isHidden = true
        Retailshoplist.reloadData()
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Retailshoplistcell", for: indexPath) as! Retailshoplistcell
        cell.Storename.text = currentDealnameArray[indexPath.row].name
        cell.Location.text = currentDealLocationArray[indexPath.row].location
        cell.Cashback.text = String(format: "%@%@", currentDealcashbackArray[indexPath.row].cashback as! CVarArg,"%")
        
        let currentdatestring : String = String(format: "%@", currentDealStartDateArray[indexPath.row].promotionstartdate)
      //  print("current date:-",currentdatestring)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: currentdatestring)
        dateFormatter.dateFormat = "dd/MM/YYYY"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date!)
        //print("timeStamp current date:-",timeStamp)
        
        let Enddatestring : String = String(format: "%@", currentDealEndDateArray[indexPath.row].promotionenddate)
       // print("end date:-",Enddatestring)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date1 = dateFormatter1.date(from: Enddatestring)
        dateFormatter1.dateFormat = "dd/MM/YYYY"///this is what you want to convert format
        dateFormatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp1 = dateFormatter1.string(from: date1!)
        //print("timeStamp end date:-",timeStamp1)
        cell.Promotiondate.text = timeStamp + "-" + timeStamp1
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            
          
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.Retailshoplist.tableFooterView = spinner
            self.Retailshoplist.tableFooterView?.isHidden = false
            if responseArray.count != 0{
                
                
                    //Dealalertlabel.text = "Loading"
                    print("pageNo Before",self.pageNo)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    //self.limit=self.limit
                    print("pageNo After",self.pageNo)
                    Paginationidentity = "YES"
                    spinner.startAnimating()
                    ConnecttoDealsAPISERVER()
                    
                
            }
            
           
            
            
            
            
        }
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
        self.mySearchBar.endEditing(true)
        
    }
    
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
        pickeridentity = "NO"
        Paginationidentity = "NO"
        mySearchBar.text = item
        Constants.cityname = item
        Database.set(Constants.cityname, forKey: Constants.citynamekey)
        Database.synchronize()
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
        ConnecttoDealsAPISERVER()
        
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

