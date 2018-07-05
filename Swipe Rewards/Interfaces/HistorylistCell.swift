//
//  HistorylistCell.swift
//  Swipe Rewards
//
//  Created by Bharathan on 05/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class HistorylistCell: UITableViewCell {
    @IBOutlet weak var Noitifytitle: UILabel!
    @IBOutlet weak var Notifydate: UILabel!
    @IBOutlet weak var Notifyamount: UILabel!
    @IBOutlet weak var NotifyIcon: UILabel!
    @IBOutlet weak var NotifyArrowIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
