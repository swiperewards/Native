//
//  SignUpController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 03/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift

class SignUpController: UIViewController {

    @IBOutlet weak var SignInbutton: UIButton!
    @IBOutlet weak var ConfirmPasswordIcon: UILabel!
    @IBOutlet weak var PasswordIcon: UILabel!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var Lastnameicon: UILabel!
    @IBOutlet weak var Firstnameicon: UILabel!
    @IBOutlet weak var Swipelogoicon: UILabel!
    
    var attrs = [
        //  kCTFontAttributeName : UIFont.fontNames(forFamilyName: "SF Pro Text Semibold"),
        kCTForegroundColorAttributeName : UIColor.white,
        kCTUnderlineStyleAttributeName : 1] as [CFString : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonTitleStr = NSMutableAttributedString(string:"Sign In", attributes:attrs as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any])
        attributedString.append(buttonTitleStr)
        SignInbutton.setAttributedTitle(attributedString, for: .normal)
        
        
        let fontswipe = FontSwipe()
        let fontswipelogo = FontSwipeLogo()
        
        Firstnameicon.font = fontswipe.fontOfSize(20)
        Firstnameicon.text = fontswipe.stringWithName(.Username)
        Firstnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        Lastnameicon.font = fontswipe.fontOfSize(20)
        Lastnameicon.text = fontswipe.stringWithName(.Username)
        Lastnameicon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Email)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        PasswordIcon.font = fontswipe.fontOfSize(20)
        PasswordIcon.text = fontswipe.stringWithName(.Password)
        PasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        ConfirmPasswordIcon.font = fontswipe.fontOfSize(20)
        ConfirmPasswordIcon.text = fontswipe.stringWithName(.Password)
        ConfirmPasswordIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        Swipelogoicon.font = fontswipelogo.fontOfSize(60)
        Swipelogoicon.text = fontswipelogo.stringWithName(.Swipelogo)
        Swipelogoicon.textColor = UIColor.white

        // Do any additional setup after loading the view.
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
