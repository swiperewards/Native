//
//  ForgotController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift

class ForgotController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var BackIcon: UILabel!
    @IBOutlet weak var EmailIcon: UILabel!
    @IBOutlet weak var Email: FloatLabelTextField!
    @IBOutlet weak var SwipeLogo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontswipe = FontSwipe()
        let fontswipelogo = FontSwipeLogo()
        EmailIcon.font = fontswipe.fontOfSize(20)
        EmailIcon.text = fontswipe.stringWithName(.Username)
        EmailIcon.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        SwipeLogo.font = fontswipelogo.fontOfSize(60)
        SwipeLogo.text = fontswipelogo.stringWithName(.Swipelogo)
        SwipeLogo.textColor = UIColor.white
        BackIcon.font = fontswipe.fontOfSize(20)
        BackIcon.text = fontswipe.stringWithName(.Backarrow)
        BackIcon.textColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitPressed(_ sender: Any) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
