//
//  WalletCardsCell.swift
//  Swipe Rewards
//
//  Created by Bharathan on 05/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class WalletCardsCell: UITableViewCell {

    @IBOutlet weak var CardIcon: UIImageView!
    @IBOutlet weak var CardNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
