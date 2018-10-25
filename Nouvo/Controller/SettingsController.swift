//
//  SettingsController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
import AssetsLibrary
import GoogleSignIn
import MXParallaxHeader
import SDWebImage


class SettingsController: UIViewController,UITableViewDelegate,UITableViewDataSource,MXParallaxHeaderDelegate {

     //MARK: - OUTLET & INSTANCE
    @IBOutlet var Version: UILabel!
    var Input = [String: AnyObject]()
    @IBOutlet var headerview: UIView!
    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var userimageview: UIImageView!
    @IBOutlet weak var NameofSwipe: UILabel!
    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var SettingsTV: UITableView!
    let cameraPicker = UIImagePickerController()
    var imageName = String()
    var tags : Int = 0
    let fontswipe = FontSwipe()
    let fontRefer = ReferandEarn()
    var fontData = [[:]]
    var indicator = UIActivityIndicatorView()
    private var settingsTitlearray = NSArray()
    
     //MARK: - ViewWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "SETTINGS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    
    }
     //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameofSwipe.text = string2
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        print(appVersionString)
        Version.text = "\("Version:")\(appVersionString)"
        let socialIdenity: String?
        socialIdenity = Database.value(forKey: Constants.GoogleIdentityforchangepasswordkey) as? String
        if socialIdenity == "" || socialIdenity == nil {
            settingsTitlearray = ["Notification",
                                  "Change Password",
                                  "Contact Us",
                                  "Privacy & Security",
                                  "Terms of Use",
                                  "Refer & Earn",
                                  "Sign Out"]
            fontData = [
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Notification)  ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Password) ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Contact) ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Privacysecurity) ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Termsofuse)],
                ["font":fontRefer.fontOfSize(25), "text":fontRefer.stringWithName(.Referandearn)],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Signout) ]
            ]
            
        }else{
            settingsTitlearray = ["Notification",
                                  "Contact Us",
                                  "Privacy & Security",
                                  "Terms of Use",
                                  "Refer & Earn",
                                  "Sign Out"]
            fontData = [
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Notification)  ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Contact) ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Privacysecurity) ],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Termsofuse)],
                ["font":fontRefer.fontOfSize(25), "text":fontRefer.stringWithName(.Referandearn)],
                ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Signout) ]
            ]
            
        }
        self.navigationController?.navigationBar.topItem?.title = "SETTINGS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }else{
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            self.userimageview.sd_setImage(with: url)
                self.userimageview.contentMode = .scaleAspectFill
                self.userimageview.layer.borderWidth = 1.0
                self.userimageview.layer.masksToBounds = false
                self.userimageview.layer.borderColor = UIColor.white.cgColor
                self.userimageview.layer.cornerRadius = self.userimageview.frame.size.width / 2
                self.userimageview.clipsToBounds = true
            
        }
        SettingsTV.parallaxHeader.view = headerview // You can set the parallax header view from the floating view
        SettingsTV.parallaxHeader.height = 180
        SettingsTV.parallaxHeader.minimumHeight = 0
        SettingsTV.parallaxHeader.mode = MXParallaxHeaderMode.fill
        SettingsTV.parallaxHeader.delegate = self
        
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
        
        
        SettingsTV.register(UINib(nibName: "SettingslistCell", bundle: nil),
                                forCellReuseIdentifier: "SettingslistCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitlearray.count
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingslistCell", for: indexPath) as! SettingslistCell
        cell.SettingsTitle?.text = settingsTitlearray[indexPath.row] as? String
        cell.SettingsIcon?.text =  fontData[indexPath.row]["text"] as? String
        cell.SettingsIcon?.font =  fontData[indexPath.row]["font"] as! UIFont
        cell.SettingsIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        if indexPath.row == 0 {
            cell.NotificationSwitch.isHidden = false
        }else {
            cell.NotificationSwitch.isHidden = true
        }
        cell.NotificationSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let socialIdenity: String?
        socialIdenity = Database.value(forKey: Constants.GoogleIdentityforchangepasswordkey) as? String
        if socialIdenity == "" || socialIdenity == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            switch indexPath.row {
            case 0:
                break
            case 1:
                let view: ChangePasswordController = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 2:
                let view: ContactUsController = storyboard.instantiateViewController(withIdentifier: "ContactUsController") as! ContactUsController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 3:
                let view: PrivacyController = storyboard.instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 4:
                let view: TermsofUseController = storyboard.instantiateViewController(withIdentifier: "TermsofUseController") as! TermsofUseController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 5:
                // text to share
                let view: ReferandEarnViewController = storyboard.instantiateViewController(withIdentifier: "ReferandEarnViewController") as! ReferandEarnViewController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 6:
                let alert = UIAlertController(title: "Confirm" , message: "Are you sure you want to sign out?", preferredStyle: .alert)
                let CancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: self.doSomething1)
                let okAction = UIAlertAction(title: "YES", style: .default, handler: self.doSomething)
                alert.addAction(CancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            switch indexPath.row {
            case 0:
                break
            case 1:
                let view: ContactUsController = storyboard.instantiateViewController(withIdentifier: "ContactUsController") as! ContactUsController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 2:
                let view: PrivacyController = storyboard.instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 3:
                let view: TermsofUseController = storyboard.instantiateViewController(withIdentifier: "TermsofUseController") as! TermsofUseController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 4:
                // text to share
                let view: ReferandEarnViewController = storyboard.instantiateViewController(withIdentifier: "ReferandEarnViewController") as! ReferandEarnViewController
                self.navigationController?.pushViewController(view, animated: true)
                break
            case 5:
                let alert = UIAlertController(title: "Confirm" , message: "Are you sure you want to sign out?", preferredStyle: .alert)
                let CancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: self.doSomething1)
                let okAction = UIAlertAction(title: "YES", style: .default, handler: self.doSomething)
                alert.addAction(CancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    //MARK: - NOTIFICATION SWITCH
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            print("on")
            self.showToast(message: "Notifications Enabled")
        }else{
             print("off")
             self.showToast(message: "Notifications Disabled")
        }
    }
    //MARK: - LOGOUT ACTION
    func doSomething(action: UIAlertAction) {
        //Use action.title
        Database.removeObject(forKey: Constants.Tokenkey)
        Database.removeObject(forKey: Constants.profileimagekey)
        Database.removeObject(forKey: Constants.GoogleIdentityforchangepasswordkey)
        //LocalDatabase.ClearallLocalDB()
        Database.synchronize()
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SignInController")
        self.present(navigationController, animated: true, completion: nil)
    }
    func doSomething1(action: UIAlertAction) {
        //Use action.title
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - UPLOAD IMAGE TAP ACTION
    @IBAction func UploadImage(_ sender: Any) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    func showCamera() {
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        tags = 0
        present(cameraPicker, animated: true, completion: nil)
    }
    func showAlbum() {
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        tags = 1
        present(cameraPicker, animated: true, completion: nil)
    }
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-100, y: self.view.frame.size.height-100, width: 190, height: 35))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
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

}
//MARK: - NAVIGATION FOR IMAGE PICKER
extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if tags == 0 {
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
                imageName = imgUrl.lastPathComponent
            }
            dismiss(animated: true, completion: nil)
            // let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let activityIndicator = RequestManager.showActivityIndicator(vc: self)
                self.sendUploadPhotoRequest(image: image, activityIndicator: activityIndicator)
            }
        }else{
        let fileurl:URL = info[UIImagePickerControllerImageURL] as! URL
        imageName = fileurl.lastPathComponent
        print(imageName)
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let activityIndicator = RequestManager.showActivityIndicator(vc: self)
            self.sendUploadPhotoRequest(image: image, activityIndicator: activityIndicator)
        }
       }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: -  Fetching IMAGE data from server
    func UpdateResponse(response: [String : AnyObject]){
        print("Profile response :", response)
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
            Constants.profileimage = (responses["responseData"]?.value(forKey: "imageUrl") as? String)!
            Database.set(Constants.profileimage, forKey: Constants.profileimagekey)
            Database.synchronize()
            self.userimageview.sd_setImage(with: URL(string:Database.value(forKey: Constants.profileimagekey) as! String), completed: {
                (image, error, cacheType, url) in
                self.hideLoading()
                
            })
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
    
    //MARK: - SEND IMAGE FILE TO SERVER
    func sendUploadPhotoRequest(image: UIImage, activityIndicator: UIActivityIndicatorView) {
        showSpinning()
        var modifiedImage = image
        var imageExtension = ".png"
        var mimeTypeParam = "image/png"
        var imageData : Data!
        if let compressedImageData = UIImageJPEGRepresentation(modifiedImage, 0.6)
        {
            if let compressedImage = UIImage(data: compressedImageData)
            {
                modifiedImage = compressedImage
                imageExtension = ".jpg"
                mimeTypeParam = "image/jpg;base64,"
                imageData = compressedImageData
            }
            
        }
        if modifiedImage == image
        {
            if let pngImageData = UIImagePNGRepresentation(modifiedImage)
            {
                if let pngImage = UIImage(data: pngImageData)
                {
                    modifiedImage = pngImage
                    imageExtension = ".png"
                    mimeTypeParam = "image/png;base64,"
                    imageData = pngImageData
                }
            }
            
        }
        imageData = UIImageJPEGRepresentation(modifiedImage, 0.5)
        let strBase64:String =  (imageData?.base64EncodedString(options: .lineLength64Characters))!
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        let jsonObject: [String: AnyObject] = [
             "image": "\("data:")\(mimeTypeParam)\(strBase64)" as AnyObject
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
            "platform": "IOS" as AnyObject,
            "requestData": encrypted] as [String : AnyObject]
        self.userimageview.contentMode = .scaleAspectFill
        self.userimageview.layer.borderWidth = 1.0
        self.userimageview.layer.masksToBounds = false
        self.userimageview.layer.borderColor = UIColor.white.cgColor
        self.userimageview.layer.cornerRadius = self.userimageview.frame.size.width / 2
        self.userimageview.clipsToBounds = true
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        let uploadImageServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.UploadImageURL
        activityIndicator.stopAnimating()
        RequestManager.PostPathwithAUTH(urlString: uploadImageServer, params: Input, successBlock:{
            (response) -> () in self.UpdateResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in}}
    
        //MARK: -  Activity Indicator
        func hideLoading(){
           
            indicator.stopAnimating()
        }
        private func createActivityIndicator() -> UIActivityIndicatorView {
            indicator.hidesWhenStopped = true
            indicator.color = UIColor.white
            return indicator
        }
        private func showSpinning() {
            indicator.translatesAutoresizingMaskIntoConstraints = false
            userimageview.addSubview(indicator)
            centerActivityIndicatorInButton()
            indicator.startAnimating()
        }
    
        private func centerActivityIndicatorInButton() {
            let xCenterConstraint = NSLayoutConstraint(item: userimageview, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
            userimageview.addConstraint(xCenterConstraint)
            let yCenterConstraint = NSLayoutConstraint(item: userimageview, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
            userimageview.addConstraint(yCenterConstraint)
        }
}

