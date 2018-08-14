//
//  Retailshoplistcell.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class Retailshoplistcell: UITableViewCell {

    @IBOutlet weak var notch: UILabel!
    @IBOutlet weak var Promotiondate: UILabel!
    @IBOutlet weak var Cashback: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Storename: UILabel!
    @IBOutlet weak var CellView: UIView!
   // var semiCircleLayer   = CAShapeLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CellView.layer.borderWidth = 0.5
        CellView.layer.borderColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1).cgColor
        CellView.layer.cornerRadius = 10
        
        
        
        
//
//        let center = CGPoint (x: notch.frame.size.width / 2, y: notch.frame.size.height / 2)
//        let circleRadius = notch.frame.size.width / 2
//        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true)
//        semiCircleLayer.path = circlePath.cgPath
//        semiCircleLayer.lineWidth = 8
//        semiCircleLayer.strokeStart = 0
//        semiCircleLayer.strokeEnd  = 1
//        notch.layer.addSublayer(semiCircleLayer)
        
        
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 27, width: 8, height: 50), cornerRadius: 50).cgPath
//        layer.fillColor = UIColor.red.cgColor
//        CellView.layer.addSublayer(layer)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
