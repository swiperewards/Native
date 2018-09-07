//
//  SettingslistCell.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class SettingslistCell: UITableViewCell {
    @IBOutlet weak var SettingsTitle: UILabel!
    @IBOutlet weak var NotificationSwitch: UISwitch!
    @IBOutlet weak var SettingsIcon: UILabel!
    @IBOutlet var line: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
