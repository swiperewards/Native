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
class SettingsController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var userimageview: UIImageView!
    @IBOutlet weak var NameofSwipe: UILabel!
    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var SettingsTV: UITableView!
    let cameraPicker = UIImagePickerController()
    var imageName = String()
    var tags : Int = 0
    let fontswipe = FontSwipe()
    var fontData = [[:]]
    
    private let settingsTitlearray = ["Notification",
                                      "Change Password",
                                      "Contact Us",
                                      "Privacy & Security",
                                      "Terms of Use",
                                      "Sign Out"]
    
    private var settingsIconArray = NSArray()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "SETTINGS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      
        
        
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string1:String = (Database.value(forKey: Constants.UsernameKey)  as? String)!
        let string2 = string1.replacingOccurrences(of: "/", with: "  ")
        NameofSwipe.text = string2
        self.navigationController?.navigationBar.topItem?.title = "SETTINGS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        let username: String?
        username = Database.value(forKey: Constants.profileimagekey) as? String
        if  username == "" || username == nil{
        }
        else{
            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
            let data1 = NSData.init(contentsOf: url!)
            if data1 != nil {
                userimageview.image = UIImage(data:data1! as Data)
                self.userimageview.contentMode = .scaleAspectFill
                self.userimageview.layer.borderWidth = 1.0
                self.userimageview.layer.masksToBounds = false
                self.userimageview.layer.borderColor = UIColor.white.cgColor
                self.userimageview.layer.cornerRadius = self.userimageview.frame.size.width / 2
                self.userimageview.clipsToBounds = true
            }
        }
        
//      settingsIconArray =  [fontswipe.stringWithName(.Notification),
//         fontswipe.stringWithName(.Password),
//         fontswipe.stringWithName(.Contact),
//         fontswipe.stringWithName(.Privacysecurity),
//         fontswipe.stringWithName(.Termsofuse),
//         fontswipe.stringWithName(.Signout)]
//
        
        
        fontData = [
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Notification)  ],
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Password) ],
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Contact) ],
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Privacysecurity) ],
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Termsofuse)],
    ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Signout) ]
        ]
        
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:SettingsView.bounds.size.height - (SettingsView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:SettingsView.bounds.size.height - (SettingsView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:SettingsView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        SettingsView.layer.mask = maskLayer
        
        
        SettingsTV.register(UINib(nibName: "SettingslistCell", bundle: nil),
                                forCellReuseIdentifier: "SettingslistCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitlearray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingslistCell", for: indexPath) as! SettingslistCell
        
        cell.SettingsTitle?.text = settingsTitlearray[indexPath.row]
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
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            print("on")
            self.showToast(message: "Notifications Enabled")
        }
        else{
            print("off")
             self.showToast(message: "Notifications Disabled")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
            
            Database.removeObject(forKey: Constants.Tokenkey)
            Database.removeObject(forKey: Constants.profileimagekey)
            //LocalDatabase.ClearallLocalDB()
            Database.synchronize()
            GIDSignIn.sharedInstance().signOut()
            let navigationController = storyboard.instantiateViewController(withIdentifier: "SignInController")
            self.present(navigationController, animated: true, completion: nil)
            break
            
        default:
            break
        }
        
        
    }
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



extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if tags == 0 {
            
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
                imageName = imgUrl.lastPathComponent
            }
            
         
            dismiss(animated: true, completion: nil)
            // let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.userimageview.image = image
                let resizedImage = RequestManager.resizeImage(image: image, targetSize: CGSize(width: 300.0, height: 300.0))
                let activityIndicator = RequestManager.showActivityIndicator(vc: self)
                self.sendUploadPhotoRequest(image: image, activityIndicator: activityIndicator)
            }
        }
        else
        {
        let fileurl:URL = info[UIImagePickerControllerImageURL] as! URL
        imageName = fileurl.lastPathComponent
        print(imageName)
        dismiss(animated: true, completion: nil)
       // let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userimageview.image = image
            let resizedImage = RequestManager.resizeImage(image: image, targetSize: CGSize(width: 300.0, height: 300.0))
            let activityIndicator = RequestManager.showActivityIndicator(vc: self)
            self.sendUploadPhotoRequest(image: image, activityIndicator: activityIndicator)
        }
       }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendUploadPhotoRequest(image: UIImage, activityIndicator: UIActivityIndicatorView) {
        
        //"http://192.168.0.198:5000/user/profilepic/uid32-560.jpg"
        //http://winjitstaging.cloudapp.net:5000/user/profilepic8167688.jpg

        print("Image :",image)
        self.userimageview.contentMode = .scaleAspectFill
        self.userimageview.image = image
        self.userimageview.layer.borderWidth = 1.0
        self.userimageview.layer.masksToBounds = false
        self.userimageview.layer.borderColor = UIColor.white.cgColor
        self.userimageview.layer.cornerRadius = self.userimageview.frame.size.width / 2
        self.userimageview.clipsToBounds = true
        let uploadImageServer = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.UploadImageURL
     //   let randNo = Int(arc4random_uniform(100000000))
        
       // let randNo = Int(arc4random_uniform(100000000))
       // let name = "profilepic"
        
        activityIndicator.stopAnimating()
        RequestManager.postImage(urlString: uploadImageServer, params: image, imageName: imageName, successBlock: { (response) in
//
//            let url = URL(string:Database.value(forKey: Constants.profileimagekey) as! String)
//            let data1 = NSData.init(contentsOf: url!)
//            if data1 != nil {
//                self.userimageview.image = UIImage(data:data1! as Data)
//                self.userimageview.contentMode = .scaleAspectFill
//                self.userimageview.layer.borderWidth = 1.0
//                self.userimageview.layer.masksToBounds = false
//                self.userimageview.layer.borderColor = UIColor.white.cgColor
//                self.userimageview.layer.cornerRadius = self.userimageview.frame.size.width / 2
//                self.userimageview.clipsToBounds = true
//            }
           activityIndicator.stopAnimating()
        }, failureBlock: { (error) in
          print(error)
          activityIndicator.stopAnimating()
//            if let jsonError = FunctionManager.responseMessageFromError(error: error){
//                print(jsonError)
//            }
//            FunctionManager.showSesionExpiredAlert(vc: self, error: error)
        })
        
      
    }
    
}

