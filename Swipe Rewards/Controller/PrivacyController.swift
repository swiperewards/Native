//
//  PrivacyController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class PrivacyController: UIViewController {

    @IBOutlet weak var PrivacyIcon5: UILabel!
    @IBOutlet weak var PrivacyIcon4: UILabel!
    @IBOutlet weak var PrivacyIcon3: UILabel!
    @IBOutlet weak var PrivacyIcon2: UILabel!
    @IBOutlet weak var PrivacyIcon1: UILabel!
    @IBOutlet weak var Privacycontent5: UILabel!
    @IBOutlet weak var Privacycontent4: UILabel!
    @IBOutlet weak var PrivacyContent3: UILabel!
    @IBOutlet weak var Privacycontent2: UILabel!
    @IBOutlet weak var Privacycontent1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fontswipe = FontSwipe()
        
        PrivacyIcon1.font = fontswipe.fontOfSize(20)
        PrivacyIcon1.text = fontswipe.stringWithName(.Rightclick)
        PrivacyIcon1.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PrivacyIcon2.font = fontswipe.fontOfSize(20)
        PrivacyIcon2.text = fontswipe.stringWithName(.Rightclick)
        PrivacyIcon2.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PrivacyIcon3.font = fontswipe.fontOfSize(20)
        PrivacyIcon3.text = fontswipe.stringWithName(.Rightclick)
        PrivacyIcon3.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PrivacyIcon4.font = fontswipe.fontOfSize(20)
        PrivacyIcon4.text = fontswipe.stringWithName(.Rightclick)
        PrivacyIcon4.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PrivacyIcon5.font = fontswipe.fontOfSize(20)
        PrivacyIcon5.text = fontswipe.stringWithName(.Rightclick)
        PrivacyIcon5.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        setUpNavBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "PRIVACY & SECURITY"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
