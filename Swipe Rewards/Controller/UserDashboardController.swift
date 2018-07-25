//
//  UserDashboardController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import CoreLocation

class UserDashboardController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    //MARK: -  Outlets and Instance
    @IBOutlet weak var DashboardView: UIView!
    @IBOutlet weak var Retailshoplist: UITableView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    var lat = String()
    var long = String()
    var responseArray = NSArray()
    //MARK: -  ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    //MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDashbaordHeaderView()
        InitializeLocationManager()
        ConnectivityNetworkCheck()
        ConnecttoDealsAPISERVER()
        Retailshoplist.register(UINib(nibName: "Retailshoplistcell", bundle: nil),
                               forCellReuseIdentifier: "Retailshoplistcell")
    
        
        
        // Do any additional setup after loading the view.
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
        long = String(format : "%@",currentLocation.coordinate.longitude)
        lat =  String(format : "%@",currentLocation.coordinate.latitude)
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
        RequestManager.getPath(urlString: DealsAPI, params: Input, successBlock:{
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
        print("DealsResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            //hideLoading()
            let data1 = (response as NSDictionary).object(forKey: "responseData")
            responseArray = data1 as! NSArray
            print("responseArray1  :", responseArray)
            Retailshoplist.reloadData()
            
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
        cell.Cashback.text = String(format: "%@", ((responseArray[indexPath.row] as AnyObject).value(forKey: "cashBonus") as? NSNumber)!)
        cell.Promotiondate.text = ((responseArray[indexPath.row] as AnyObject).value(forKey: "startDate") as? String)! + ((responseArray[indexPath.row] as AnyObject).value(forKey: "endDate") as? String)!
        
        return cell
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
}
