//
//  RosterViewController.swift
//  ChatDemo
//
//  Created by LIU Chong Liang on 9/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

import Foundation

class RosterViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView?
    var innerFetchResultsController:NSFetchedResultsController?
    let myImage = UIImage(named: "avatar-heshang")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Demos", style: UIBarButtonItemStyle.Plain, target: self, action: "toCellDemo:");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGoOnline:", name: XMPPWorkerConstants.NOTI_DID_GOONLINE, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let vc as ChatViewController:
            if let user = sender as? XMPPUserCoreDataStorageObject {
                vc.pushMessages(self.getChatMessages())
            } else if let messages = sender as? [ChatCellMessage] {
                vc.pushMessages(messages)
            }
        default:
            return
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        get {
            if self.innerFetchResultsController == nil {
                let rosterMoc = XMPPWorker.sharedInstance.roster
                let entity = NSEntityDescription.entityForName("XMPPUserCoreDataStorageObject", inManagedObjectContext:rosterMoc!)
                let sd1 = NSSortDescriptor(key: "sectionNum", ascending: true)
                let sd2 = NSSortDescriptor(key: "displayName", ascending: true)
                let fetchReq = NSFetchRequest()
                fetchReq.entity = entity
                fetchReq.sortDescriptors = [sd1, sd2]
                fetchReq.fetchBatchSize = 10
                let predicate = NSPredicate(format: "subscription == %@", "both")
                fetchReq.predicate = predicate
                self.innerFetchResultsController = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: rosterMoc!, sectionNameKeyPath: "sectionNum", cacheName: nil)
                self.innerFetchResultsController?.delegate = self
                
                var error:NSError?
                if nil == innerFetchResultsController?.performFetch(&error) {
                    NSLog("Error performing fetch: %@", error!)
                }
            }
            return self.innerFetchResultsController!
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView!.reloadData()
    }
    
    @objc
    private func didGoOnline(notification: NSNotification){
    }
    
    @objc
    private func toCellDemo(sender: AnyObject?) {
        self.performSegueWithIdentifier("ToDemos", sender: nil)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        cell?.textLabel?.text = user.displayName
        
        if user.photo != nil {
            cell?.imageView?.image = user.photo
        } else {
            if let phData = XMPPWorker.sharedInstance.xmppvCardAvatarModule?.photoDataForJID(user.jid) {
                cell?.imageView?.image = UIImage(data: phData)
            }
            else {
                cell?.imageView?.image = UIImage(named: "avatar-placeholder")
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController.sections
        if section < sections?.count {
            let secInfo = sections?[section] as NSFetchedResultsSectionInfo?
            let n = secInfo?.numberOfObjects
            return n!
        }
        return 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = self.fetchedResultsController.sections
        if section < sections?.count {
            let secInfo = sections?[section] as NSFetchedResultsSectionInfo?
            NSLog("Section: %@", secInfo!.name!)
            let s = secInfo?.name!.toInt()
            switch s! {
            case 0: return "Avaliable"
            case 1: return "Away"
            default: return "Offline"
                
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sections = self.fetchedResultsController.sections
        let secinfo = sections?[indexPath.section] as NSFetchedResultsSectionInfo
        let user = secinfo.objects[indexPath.row] as XMPPUserCoreDataStorageObject
        self.performSegueWithIdentifier("ToChatViewController", sender: user)
        
//        let body = DDXMLElement(name: "body")
//        body.setStringValue("Hello")
//        let message = DDXMLElement(name: "message")
//        message.addAttributeWithName("type", stringValue: "chat")
//        message.addAttributeWithName("to", stringValue: "hongpu")
//        message.addChild(body)
//       
//        let photoElem = DDXMLElement(name: "Photo")
//        let binElem = DDXMLElement(name:"Binval")
//        
//        let imgData = UIImagePNGRepresentation(UIImage(named: "meinv"))
//        binElem.setStringValue(imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0)))
//        photoElem.addChild(binElem)
//        message.addChild(photoElem)
//        
//        NSLog("%@", message)
    }
    
    func getChatMessages() -> [ChatCellMessage] {
        let storage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        let moc = storage.mainThreadManagedObjectContext
        let entityDescription = NSEntityDescription.entityForName("XMPPMessageArchiving_Message_CoreDataObject", inManagedObjectContext: moc)
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error:NSError?
        var chatCellMessages = [ChatCellMessage]()
        
//        request.predicate = NSPredicate(format: "messageStr = nil")
        let messages = moc.executeFetchRequest(request, error: &error)

        for message in messages! {
            let m = message as XMPPMessageArchiving_Message_CoreDataObject
//            NSLog("%@: ", m.message)
//            NSLog("%@ --> %@, \n%@", m.message.fromStr(), m.messageStr, m.body)
//            if let t = m.thread {
//                NSLog("Thread: %@", t)
//            } else {
//                NSLog("Without Thread id")
//            }
            var avatar:UIImage? = self.myImage
            var direction = MessageDirection.FromMe
            if m.message.fromStr().hasPrefix(XMPPWorker.sharedInstance.userJID!) == false {
                direction = MessageDirection.FromOppsite
                avatar = UIImage(named: "avatar-women")
            }
            let content = m.message.content()
            switch content.messageType {
            case MessageType.ImageURL:
                if let decoded = content.data as? NSDictionary {
                    let strSize = decoded["size"] as String
                    let url = decoded["src"] as? String
                    let sizeArr = strSize.componentsSeparatedByString("x")
                    let w = sizeArr[0] as NSString
                    let size = CGSizeMake(CGFloat(w.floatValue), CGFloat((sizeArr[1] as NSString).floatValue))
                    assert(sizeArr.count == 2)
                    let cellImgMsg = ChatCellImageMessage(placeholderWithURL:NSURL(string: url!), withImageSize:size, withDirection: direction, avatarImage: avatar)
                    cellImgMsg.messageOwner = m.message.fromStr()
                    chatCellMessages.append(cellImgMsg)
                }
            default:
                if let text = m.message.content().data as? String {
                    let cellMsg = ChatCellTextMessage(string: text, direction: direction, avatarImage: avatar!)
                    cellMsg.messageOwner = m.message.fromStr()
                    chatCellMessages.append(cellMsg)
                }
            }
        }
        return chatCellMessages
    }
}