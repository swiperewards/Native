//
//  LaunchViewController.swift
//  Nouvo
//
//  Created by Bharathan on 06/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet var version: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        version.text = appVersionString
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
