//
//  HistoryController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import GoogleSignIn
class HistoryController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var toastlabel: UILabel!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var HistoryTV: UITableView!
    let fontswipe = FontSwipe()
    var fontData = [[:]]
    var fontData1 = [[:]]
     var notifydatearray = [String]()
     var notifyamountarray = [AnyObject]()
     var notifytitlearray = [String]()
     var CheckICONTypearray = [AnyObject]()
     var isCreditarray = [AnyObject]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "HISTORY"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
     
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryTV.addSubview(self.refreshControl)
        toastlabel.isHidden = true
        HistoryTV.isHidden = false
        setUpUI()
        ConnectHistoryAPI()
        
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.ConnectHistoryAPI()
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                refreshControl.isHidden = true
            }
        }
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
    func setUpUI() {
        self.navigationController?.navigationBar.topItem?.title = "HISTORY"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        fontData = [
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Awardcup) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Redeem) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Notification) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Transfer) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Awardcup) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Transfer) ]
        ]
        fontData1 = [
            ["font":fontswipe.fontOfSize(17), "text": fontswipe.stringWithName(.Arrowupword) ],
            ["font":fontswipe.fontOfSize(17), "text": fontswipe.stringWithName(.Arrowdown) ]]
        HistoryTV.register(UINib(nibName: "HistorylistCell", bundle: nil),
                           forCellReuseIdentifier: "HistorylistCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ConnectHistoryAPI()  {
        //Check Internet Connectivity
        if !NetworkConnectivity.isConnectedToNetwork() {
           // refreshControl.endRefreshing()
            let alert = UIAlertController(title: Constants.NetworkerrorTitle , message: Constants.Networkerror, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            view.addSubview(indicator)
            indicator.frame = view.bounds
            indicator.startAnimating()
            HistoryInputBody()
            let HistoryAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.EventHistoryURL
            RequestManager.PostPathwithAUTH(urlString: HistoryAPI, params: Input, successBlock:{
                (response) -> () in self.EventHistoryResponse(response: response as! [String : AnyObject])})
            { (error: NSError) ->() in }
        }
        
    }
   
    func HistoryInputBody() {
        /*
         {
         "platform": "android",
         "deviceId": "some string here",
         "lat": "some description here",
         "long": "some web here",
         "requestData":{
         }
         }*/
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": ""] as [String : AnyObject]
        
    }
    func EventHistoryResponse(response: [String : AnyObject]) {
        indicator.removeFromSuperview()
        indicator.stopAnimating()
        print("EventHistoryResponse :", response)
        refreshControl.endRefreshing()
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
        
        if responses["responseData"]?.count == 0 {
            
            toastlabel.isHidden = false
            HistoryTV.isHidden = false
            
        }else{
        
            toastlabel.isHidden = true
            HistoryTV.isHidden = false
            
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            notifytitlearray = responses["responseData"]?.value(forKey: "notificationDetails") as! [String]
            notifydatearray = responses["responseData"]?.value(forKey: "notificationDate") as! [String]
            notifyamountarray = responses["responseData"]?.value(forKey: "transactionAmount") as! [AnyObject]
            CheckICONTypearray = responses["responseData"]?.value(forKey: "eventType") as! [AnyObject]
            isCreditarray = responses["responseData"]?.value(forKey: "isCredit") as! [AnyObject]
            print("notifytitlearray  :", notifytitlearray)
            HistoryTV.reloadData()
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
          //  hideLoading()
        }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifytitlearray.count
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistorylistCell", for: indexPath) as! HistorylistCell
        
        cell.Noitifytitle?.text = notifytitlearray[indexPath.row]
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: notifydatearray[indexPath.row])
        dateFormatter.dateFormat = "dd MMM YYYY"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date!)
        print("timeStamp current date:-",timeStamp)
        
        
        cell.Notifydate?.text = timeStamp
        let amountstring = notifyamountarray[indexPath.row]
        let credit = isCreditarray[indexPath.row]
        let creditstring:String = String(format: "%@", credit as! CVarArg)
        let eventtypestring = CheckICONTypearray[indexPath.row]
        let transamount:String = String(format: "%@", amountstring as! CVarArg)
        let eventtypestr:String = String(format: "%@", eventtypestring as! CVarArg)
        if transamount == "<null>" {
             cell.Notifyamount?.text = ""
            
        }else{
            print("AMount : %@",amountstring)
            cell.Notifyamount?.text = String(format: "$%@", amountstring as! CVarArg)
        }
        
       
       
        cell.NotifyIcon?.text =  fontData[0]["text"] as? String
        cell.NotifyIcon?.font =  fontData[0]["font"] as! UIFont
        cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        if eventtypestr  == "0" && creditstring.isEmpty == true {
            cell.NotifyIcon?.text =  fontData[0]["text"] as? String
            cell.NotifyIcon?.font =  fontData[0]["font"] as! UIFont
            cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
        }else  if eventtypestr == "1" && creditstring == "true"{
            cell.NotifyIcon?.text =  fontData[1]["text"] as? String
            cell.NotifyIcon?.font =  fontData[1]["font"] as! UIFont
            cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            cell.NotifyArrowIcon?.text =  fontData1[0]["text"] as? String
            cell.NotifyArrowIcon?.font =  fontData1[0]["font"] as! UIFont
            cell.NotifyArrowIcon?.textColor =  UIColor.green
            
            cell.Notifyamount?.text = String(format: "+$%@", amountstring as! CVarArg)
            
        }else  if eventtypestr == "3"  && creditstring == "false"  {
            cell.NotifyIcon?.text =  fontData[1]["text"] as? String
            cell.NotifyIcon?.font =  fontData[1]["font"] as! UIFont
            cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            cell.NotifyArrowIcon?.text =  fontData1[1]["text"] as? String
            cell.NotifyArrowIcon?.font =  fontData1[1]["font"] as! UIFont
            cell.NotifyArrowIcon?.textColor =  UIColor.red
            
            cell.Notifyamount?.text = String(format: "-$%@", amountstring as! CVarArg)
            
        }else if eventtypestr == "2" ||  eventtypestr == "0" {
            cell.NotifyIcon?.text =  fontData[2]["text"] as? String
            cell.NotifyIcon?.font =  fontData[2]["font"] as! UIFont
            cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        }else if eventtypestr == "3" {
            cell.NotifyIcon?.text =  fontData[3]["text"] as? String
            cell.NotifyIcon?.font =  fontData[3]["font"] as! UIFont
            cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
        }
        return cell
    }

    

}
