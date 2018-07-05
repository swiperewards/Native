//
//  SettingsController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift


class SettingsController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var SettingsTV: UITableView!
 
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
        
        self.navigationController?.navigationBar.topItem?.title = "SETTINGS"
        
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]


        
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
        
        let maskLayer = CAShapeLayer(layer: SettingsView.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:SettingsView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:SettingsView.bounds.size.width, y:SettingsView.bounds.size.height - (SettingsView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:SettingsView.bounds.size.height - (SettingsView.bounds.size.height*0.2)), controlPoint: CGPoint(x:SettingsView.bounds.size.width/2, y:SettingsView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = SettingsView.bounds
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
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
