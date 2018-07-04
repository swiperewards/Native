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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fontData = [
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Notification) + "   Notification" ],
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Password) + "   Change Password"],
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Contact) + "   Contact Us"],
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Privacysecurity) + "   Privacy & Security"],
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Termsofuse) + "   Terms of Use"],
    ["font":fontswipe.fontOfSize(19), "text":fontswipe.stringWithName(.Signout) + "   Sign Out"]
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
        return fontData.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingslistCell", for: indexPath) as! SettingslistCell
        
        cell.textLabel?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        cell.SettingsTitle?.font = fontData[indexPath.row]["font"] as! UIFont
        cell.SettingsTitle?.text = fontData[indexPath.row]["text"] as? String
        
        if indexPath.row == 0 {
            cell.NotificationSwitch.isHidden = false
        }else {
            cell.NotificationSwitch.isHidden = true
        }
        
        
        //        cell.titlelab.text = ((responseArray[indexPath.row] as AnyObject).value(forKey: "projecttitle") as? String)!
        //        cell.tasktitlelab.text = ((responseArray[indexPath.row] as AnyObject).value(forKey: "task_title") as? String)!
        
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
