//
//  ContactUsController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import  Fontello_Swift
class ContactUsController: UIViewController {

    @IBOutlet weak var PhoneIcon: UILabel!
    @IBOutlet weak var PhoneView: UIView!
    @IBOutlet weak var MailView: UIView!
    @IBOutlet weak var MailIcon: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        let fontswipe = FontSwipe()
        
        PhoneIcon.font = fontswipe.fontOfSize(40)
        PhoneIcon.text = fontswipe.stringWithName(.Phone)
        PhoneIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        MailIcon.font = fontswipe.fontOfSize(40)
        MailIcon.text = fontswipe.stringWithName(.Email)
        MailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PhoneView.layer.cornerRadius = 4.0
        PhoneView.layer.borderWidth = 0.2
        PhoneView.layer.borderColor = UIColor.darkGray.cgColor
        
        MailView.layer.cornerRadius = 4.0
        MailView.layer.borderWidth = 0.2
        MailView.layer.borderColor = UIColor.darkGray.cgColor


        // Do any additional setup after loading the view.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "CONTACT US"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
