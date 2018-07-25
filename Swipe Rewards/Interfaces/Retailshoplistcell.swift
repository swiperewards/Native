//
//  Retailshoplistcell.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class Retailshoplistcell: UITableViewCell {

    @IBOutlet weak var Promotiondate: UILabel!
    @IBOutlet weak var Cashback: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Storename: UILabel!
    @IBOutlet weak var CellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CellView.layer.borderWidth = 0.5
        CellView.layer.borderColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1).cgColor
        CellView.layer.cornerRadius = 10

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
