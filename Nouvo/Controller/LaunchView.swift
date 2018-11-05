//
//  LaunchView.swift
//  Nouvo
//
//  Created by Bharathan on 06/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class LaunchView: UIView {

    @IBOutlet var Version: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addBehavior() {
        print("Add all the behavior here")
        
         let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        Version.text = appVersionString
    }

}
