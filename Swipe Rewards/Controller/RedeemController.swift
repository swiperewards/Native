//
//  RedeemController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class RedeemController: UIViewController {

    @IBOutlet weak var SelectedBankDownIcon: UILabel!
    @IBOutlet weak var PaytowhereDownIcon: UILabel!
    @IBOutlet weak var PaytowhereView: UIView!
    @IBOutlet weak var SelectedBankView: UIView!
    @IBOutlet weak var PaymentAccountNoView: UIView!
    @IBOutlet weak var WithdrawalView: UIView!
    @IBOutlet weak var RedeemAmount: UITextField!
    @IBOutlet weak var PaymentAccountNo: UITextField!
    @IBOutlet weak var SelectedBank: UITextField!
    @IBOutlet weak var Paytowhere: UITextField!
    @IBOutlet weak var RedeemView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:RedeemView.bounds.size.height - (RedeemView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:RedeemView.bounds.size.height - (RedeemView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:RedeemView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        RedeemView.layer.mask = maskLayer
        
        
        let fontswipe = FontSwipe()
        SelectedBankDownIcon.font = fontswipe.fontOfSize(20)
        SelectedBankDownIcon.text = fontswipe.stringWithName(.Downarrow)
        SelectedBankDownIcon.textColor = UIColor.darkGray
        
        PaytowhereDownIcon.font = fontswipe.fontOfSize(20)
        PaytowhereDownIcon.text = fontswipe.stringWithName(.Downarrow)
        PaytowhereDownIcon.textColor = UIColor.darkGray
        
        
        
        RedeemAmount.layer.cornerRadius = 4.0
        RedeemAmount.layer.borderWidth = 0.4
        RedeemAmount.layer.borderColor = UIColor.darkGray.cgColor
        
        PaytowhereView.layer.cornerRadius = 4.0
        PaytowhereView.layer.borderWidth = 0.4
        PaytowhereView.layer.borderColor = UIColor.darkGray.cgColor
        
        SelectedBankView.layer.cornerRadius = 4.0
        SelectedBankView.layer.borderWidth = 0.4
        SelectedBankView.layer.borderColor = UIColor.darkGray.cgColor
        
        PaymentAccountNoView.layer.cornerRadius = 4.0
        PaymentAccountNoView.layer.borderWidth = 0.4
        PaymentAccountNoView.layer.borderColor = UIColor.darkGray.cgColor
        
        WithdrawalView.layer.cornerRadius = 4.0
        WithdrawalView.layer.borderWidth = 0.4
        WithdrawalView.layer.borderColor = UIColor.darkGray.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "REDEEM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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
