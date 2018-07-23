//
//  WalletController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift



class WalletController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var WalletView: UIView!
    @IBOutlet weak var CreditorDebitHeader: UILabel!
    @IBOutlet weak var BankCardNumberTV: UITableView!
    private let TotalCardNumberarray = ["Add New Card"]
    let fontswipe = FontSwipe()
    var fontData = [[:]]
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.topItem?.title = "WALLET"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BankCardNumberTV.register(UINib(nibName: "WalletCardsCell", bundle: nil),
                           forCellReuseIdentifier: "WalletCardsCell")
        
        CreditorDebitHeader.text = "Credit/Debit Cards"
        
        CreditorDebitHeader?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
       // fontData = [["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.a) ]]
        
        self.navigationController?.navigationBar.topItem?.title = "WALLET"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let maskLayer = CAShapeLayer(layer: self.view.layer)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.view.bounds.size.width, y:WalletView.bounds.size.height - (WalletView.bounds.size.height*0.2)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:WalletView.bounds.size.height - (WalletView.bounds.size.height*0.2)), controlPoint: CGPoint(x:self.view.bounds.size.width/2, y:WalletView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        maskLayer.path = arrowPath.cgPath
        maskLayer.frame = self.view.bounds
        maskLayer.masksToBounds = true
        WalletView.layer.mask = maskLayer

        // Do any additional setup after loading the view.
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TotalCardNumberarray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsCell", for: indexPath) as! WalletCardsCell
        return cell
        
        
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
