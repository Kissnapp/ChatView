//
//  ViewController.swift
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Menu";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chatViewMenuTaped(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ToChatViewController") as ChatViewController
        let messages = [
            ChatCellTextMessage(string: "This is a disaster! If we have to recall 100,000 units, we’ll take a huge loss this year.", direction: MessageDirection.FromMe, avatarImage: UIImage(named: "avatar-heshang")),
            ChatCellTextMessage(string: "We have no choice. The product defect poses a safety hazard. If we don’t act quickly, we’ll have a huge liability issue on our hands.", direction: MessageDirection.FromOppsite, avatarImage: UIImage(named: "avatar-women")),
            ChatCellTextMessage(string: "I think we’re blowing this out of proportion. Only a small amount of our June product run was affected.", direction: MessageDirection.FromMe, avatarImage: UIImage(named: "avatar-heshang")),
            ChatCellTextMessage(string: "Yes, but even one case of someone getting hurt because of the defect would be a PR nightmare, and that’s on top of the charges of negligence we’d have to face in court. We need to get ahead of this now", direction: MessageDirection.FromOppsite, avatarImage: UIImage(named: "avatar-women")),
            ChatCellTextMessage(string: "All right!", direction: MessageDirection.FromOppsite, avatarImage: UIImage(named: "avatar-women")),
            ChatCellTextMessage(string: "OMG!", direction: MessageDirection.FromOppsite, avatarImage: UIImage(named: "avatar-women"))
        ]
        vc.pushMessages(messages)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToViewController(identifier: String) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

