//
//  WalletController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift



class WalletController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var Cashback: UILabel!
    @IBOutlet var Level: UILabel!
    @IBOutlet var Levelmode: UILabel!
    
    
    
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "WALLET"
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
        ConnectivityNetworkCheck()
        ConnecttoWalletCARD()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        Progressview.layer.borderWidth = 1.5
//        Progressview.layer.cornerRadius = 5
//        Progressview.layer.borderColor = UIColor.white.cgColor
//        Progressview.clipsToBounds = true
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
        CreditorDebitHeader.text = "Credit/Debit Cards"
        CreditorDebitHeader?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
        setUpNavBar()
        ConnectivityNetworkCheck()
        ConnecttoWalletCARD()
        
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
            "requestData": [
            ]] as [String : AnyObject]
    }
    //MARK: -  Fetching Deals data from server
    func WalletCARDResponse(response: [String : AnyObject]){
        indicator.removeFromSuperview()
        print("WalletCARDResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
        TotalCardNumberarray = response["responseData"]?.value(forKey: "cardNumber") as! [String]
        print("responseArray1  :", TotalCardNumberarray)
        TotalCardNumberarray.append("Add New Card")
        print("responseArray1  :", TotalCardNumberarray)
        CardID  = response["responseData"]?.value(forKey: "id") as! [NSNumber]
        
        print("responseArray1  :", CardID)
        TotalCardNamearray = response["responseData"]?.value(forKey: "nameOnCard") as! [String]
        print("TotalCardNamearray  :", TotalCardNamearray)
        TotalCardNamearray.append("Add New Card")
        BankCardNumberTV.reloadData()
            
        }else{
            
        }
        
    }
    func setUpNavBar(){
            self.navigationController?.navigationBar.topItem?.title = "WALLET"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            let maskLayer = CAShapeLayer(layer: self.view.layer)
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint(x:0, y:0))
            arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
            arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:WalletView.bounds.size.height - (WalletView.bounds.size.height*0.2)))
            arrowPath.addQuadCurve(to: CGPoint(x:0, y:WalletView.bounds.size.height - (WalletView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:WalletView.bounds.size.height))
            arrowPath.addLine(to: CGPoint(x:0, y:0))
            arrowPath.close()
            maskLayer.path = arrowPath.cgPath
            maskLayer.frame = self.view.bounds
            maskLayer.masksToBounds = true
            WalletView.layer.mask = maskLayer
    }
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TotalCardNumberarray.count
    }
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
        
        
        
        
        //  ((TotalCardNamearray[indexPath.row] as AnyObject) as? String)! + ()
        
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
    func DeleteCardAPI()  {
        /*{
         "platform": "android",
         "deviceId": "some string here",
         "lat": "",
         "long": "",
         "requestData":{
         "cardId": 1
         }
         }*/
        DeleteCARDAPIInputBody()
        let DeleteCARDAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.DeleteCardURL
        RequestManager.PostPathwithAUTH(urlString: DeleteCARDAPI, params: Input, successBlock:{
            (response) -> () in self.DeleteCARDResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
        
    }
    func DeleteCARDAPIInputBody()  {
        print("Deleted Card ID is :",self.DeleteCardID)
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "cardId": self.DeleteCardID as AnyObject
            ]] as [String : AnyObject]
    }
    func DeleteCARDResponse(response: [String : AnyObject]){
        print("DeleteCARDResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            
            BankCardNumberTV.reloadData()
        }else{
            
        }
        
    }


}
