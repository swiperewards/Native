//
//  HistoryController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 04/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class HistoryController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    
    @IBOutlet weak var HistoryTV: UITableView!
    let fontswipe = FontSwipe()
    var fontData = [[:]]
    var fontData1 = [[:]]
    private let notifydatearray = [   "18 May 2018",
                               "18 May 2018",
                               "18 May 2018",
                               "18 May 2018",
                               "18 May 2018",
                               "18 May 2018"]
    private let notifyamountarray = [   "",
                                "+$35.15",
                                "",
                                "-$42.13",
                                "",
                                "-$8.15"]
    private let notifytitlearray = [   "Congratulations! You went up one level to level 19",
                                        "You received this week's reward",
                                        "Take your mom out of your favourite restaurant and receive 2x reward on Mother's day",
                                        "You transferred your reward",
                                        "Congratulations! You went up one level to level 18",
                                        "You transferred your reward"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "HISTORY"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "HISTORY"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        
        fontData = [
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Awardcup) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Redeem) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Notification) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Transfer) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Awardcup) ],
            ["font":fontswipe.fontOfSize(25), "text":fontswipe.stringWithName(.Transfer) ]
        ]
        
        fontData1 = [
            ["font":fontswipe.fontOfSize(17), "text": "" ],
            ["font":fontswipe.fontOfSize(17), "text": fontswipe.stringWithName(.Arrowupword) ],
            ["font":fontswipe.fontOfSize(17), "text": "" ],
            ["font":fontswipe.fontOfSize(17), "text": fontswipe.stringWithName(.Arrowdown) ],
            ["font":fontswipe.fontOfSize(17), "text": "" ],
            ["font":fontswipe.fontOfSize(17), "text": fontswipe.stringWithName(.Arrowdown) ]]
        
        
        HistoryTV.register(UINib(nibName: "HistorylistCell", bundle: nil),
                            forCellReuseIdentifier: "HistorylistCell")
        
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
        return notifydatearray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistorylistCell", for: indexPath) as! HistorylistCell
        
    
        cell.Noitifytitle?.text = notifytitlearray[indexPath.row]
        cell.Notifydate?.text = notifydatearray[indexPath.row]
        cell.Notifyamount?.text = notifyamountarray[indexPath.row]
       
        
        cell.NotifyIcon?.text =  fontData[indexPath.row]["text"] as? String
        cell.NotifyIcon?.font =  fontData[indexPath.row]["font"] as! UIFont
        cell.NotifyIcon?.textColor =  UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        
        
        if cell.Noitifytitle?.text == "You received this week's reward"{
            cell.NotifyArrowIcon?.text =  fontData1[indexPath.row]["text"] as? String
            cell.NotifyArrowIcon?.font =  fontData1[indexPath.row]["font"] as! UIFont
            cell.NotifyArrowIcon?.textColor =  UIColor.green
        }else if cell.Noitifytitle?.text == "You transferred your reward" {
            cell.NotifyArrowIcon?.text =  fontData1[indexPath.row]["text"] as? String
            cell.NotifyArrowIcon?.font =  fontData1[indexPath.row]["font"] as! UIFont
            cell.NotifyArrowIcon?.textColor =  UIColor.red
        }else{
            
        }
        
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
