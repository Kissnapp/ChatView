//
//  XMPPWorker.swift
//  ChatDemo
//
//  Created by LIU Chong Liang on 8/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

import Foundation

 struct XMPPWorkerConstants {
     static let NOTI_DID_GOONLINE = "NOTI_DID_GOONLINE"
}

class XMPPWorker {
    private var workerInner:XMPPWorkerInner?
    private var isXmppConnected: Bool = false
    var userJID: String?
    var userPassword: String?
    var customCertEvaluation: Bool = true
    var hostPort:UInt16 = 5222
    var hostName:String?
    
    var roster:NSManagedObjectContext?
    var xmppvCardAvatarModule: XMPPvCardAvatarModule? {
        get {
            return workerInner?.xmppvCardAvatarModule
        }
    }
    
    class var sharedInstance :XMPPWorker {
        struct Singleton {
            static let instance = XMPPWorker()
        }
        return Singleton.instance
    }
    
    init() {
        workerInner = XMPPWorkerInner()
        workerInner?.worker = self;
        workerInner?.setupStream()
        roster = workerInner?.xmppRosterStorage?.mainThreadManagedObjectContext
    }
    
    func connect() -> Bool {
        if let stream = workerInner?.xmppStream {
            if !stream.isDisconnected() {
                return true
            }
        }
        switch (userJID, userPassword) {
        case let (.Some(userJID), .Some(userPassword)):
            var error:NSError?
            if let stream = workerInner?.xmppStream {
                stream.myJID = XMPPJID.jidWithString(userJID)
                if let hn = self.hostName {
                    stream.hostName = hn
                    stream.hostPort = self.hostPort
                }
                if !stream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
                    let alertView = UIAlertView(title: "Error", message: "Cannot connect to \(error?.localizedDescription)", delegate: nil, cancelButtonTitle: "Ok")
                    alertView.show()
                }
            }
            return true
        default:
            return false
        }
    }
    
    func disconnect() {
        workerInner?.goOffline()
        workerInner?.xmppStream?.disconnect()
    }
    
    func teardownStream() {
        workerInner?.teardownStream()
    }
    
    internal class XMPPWorkerInner : NSObject, XMPPStreamDelegate, XMPPRosterDelegate {
        internal weak var worker: XMPPWorker?
        internal var xmppStream: XMPPStream?
        internal var xmppReconnect: XMPPReconnect?
        internal var xmppRoster: XMPPRoster?
        internal var xmppRosterStorage: XMPPRosterCoreDataStorage?
        internal var xmppvCardStorage: XMPPvCardCoreDataStorage?
        internal var xmppvCardTempModule: XMPPvCardTempModule?
        internal var xmppvCardAvatarModule: XMPPvCardAvatarModule?
        internal var xmppCapabilitiesStorage: XMPPCapabilitiesCoreDataStorage?
        internal var xmppCapabilities: XMPPCapabilities?
        
        internal var xmppMessageArchivingStorage: XMPPMessageArchivingCoreDataStorage?
        internal var xmppMessageArchivingModule: XMPPMessageArchiving?
        
        override init() {
            xmppStream = XMPPStream()
            xmppReconnect = XMPPReconnect()
            xmppRosterStorage = XMPPRosterCoreDataStorage()
            xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
            xmppvCardStorage = XMPPvCardCoreDataStorage.sharedInstance()
            xmppvCardTempModule = XMPPvCardTempModule(withvCardStorage: xmppvCardStorage!)
            xmppvCardAvatarModule = XMPPvCardAvatarModule(withvCardTempModule: xmppvCardTempModule!)
            xmppCapabilitiesStorage = XMPPCapabilitiesCoreDataStorage.sharedInstance()
            xmppCapabilities = XMPPCapabilities(capabilitiesStorage: xmppCapabilitiesStorage)
            
            xmppMessageArchivingStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
            xmppMessageArchivingModule = XMPPMessageArchiving(messageArchivingStorage: xmppMessageArchivingStorage)
            
            super.init()
        }
        
        internal func goOnline() {
            let presence = XMPPPresence()
            let domain = xmppStream!.myJID.domain
            NSLog("Go Online: domain is %@", domain)
            
            xmppStream!.sendElement(presence)
            
            NSNotificationCenter.defaultCenter().postNotificationName(XMPPWorkerConstants.NOTI_DID_GOONLINE, object: nil)
        }
        
        internal func goOffline() {
            let presence = XMPPPresence(type: "unavailable")
            xmppStream?.sendElement(presence)
        }
        
        internal func setupStream() {
            #if arch(i386)
                xmppStream!.enableBackgroundingOnSocket = true
            #endif
            
            xmppRoster!.autoFetchRoster = true
            xmppRoster!.autoAcceptKnownPresenceSubscriptionRequests = true
            
            xmppCapabilities?.autoFetchHashedCapabilities = true
            xmppCapabilities?.autoFetchNonHashedCapabilities = false
            
            xmppMessageArchivingModule?.clientSideMessageArchivingOnly = false
            
            xmppStream!.addDelegate(self, delegateQueue: dispatch_get_main_queue())
            xmppRoster!.addDelegate(self, delegateQueue: dispatch_get_main_queue())
            xmppMessageArchivingModule?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
            
            xmppReconnect!.activate(xmppStream)
            xmppRoster!.activate(xmppStream)
            xmppvCardTempModule!.activate(xmppStream)
            xmppvCardAvatarModule!.activate(xmppStream)
            xmppCapabilities!.activate(xmppStream)
            xmppMessageArchivingModule?.activate(xmppStream)
        }
        
        internal func teardownStream() {
            xmppStream?.removeDelegate(self)
            xmppRoster?.removeDelegate(self)
            xmppMessageArchivingModule?.removeDelegate(self)
            
            xmppReconnect?.deactivate()
            xmppRoster?.deactivate()
            xmppvCardTempModule?.deactivate()
            xmppvCardAvatarModule?.deactivate()
            xmppCapabilities?.deactivate()
            xmppMessageArchivingModule?.deactivate()
            
            xmppStream?.disconnect()
            
            xmppStream = nil
            xmppReconnect = nil
            xmppRoster = nil
            xmppRosterStorage = nil
            xmppvCardStorage = nil
            xmppvCardTempModule = nil
            xmppvCardAvatarModule = nil
            xmppCapabilities = nil
            xmppCapabilitiesStorage = nil
            
            xmppMessageArchivingModule = nil;
            xmppMessageArchivingStorage = nil;
        }
        
        internal func xmppStream(sender: XMPPStream!, socketDidConnect socket: GCDAsyncSocket!) {
            NSLog("socketDidConnect")
        }
        
        internal func xmppStream(sender: XMPPStream!, willSecureWithSettings settings: NSMutableDictionary!) {
            NSLog("willSecureWithSettings: %@", settings)
            let expectedCertName = xmppStream!.myJID.domain;
            if expectedCertName != nil {
                settings .setObject(expectedCertName, forKey: kCFStreamSSLPeerName as NSString)
            }
            if let customCertEval = worker?.customCertEvaluation {
                if customCertEval {
                    settings .setObject(true, forKey: GCDAsyncSocketManuallyEvaluateTrust)
                }
            }
        }
        
        internal func xmppStream(sender: XMPPStream!, didReceiveTrust trust: SecTrust!, completionHandler: ((Bool) -> Void)!) {
            NSLog("didReceiveTrust")
            if true {
                completionHandler(true)
                return
            }
//            let bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//            dispatch_async(bgQueue, { () -> Void in
//                let r:SecTrustResultType = SecTrustResultType(kSecTrustResultDeny)
//                let c = UnsafeMutablePointer<SecTrustResultType>.alloc(1)
//                c.initialize(r)
//                let status = SecTrustEvaluate(trust, c)
//                if  status == noErr && (r == SecTrustResultType(kSecTrustResultProceed) || r == SecTrustResultType(kSecTrustResultUnspecified)) {
//                    completionHandler(true)
//                } else {
//                    completionHandler(false)
//                }
//                c.dealloc(1)
//            })
        }
        
        internal func xmppStreamDidConnect(sender: XMPPStream!) {
            NSLog("xmppStreamDidConnect")
            worker?.isXmppConnected = true
            var error:NSError?
            if !(xmppStream!.authenticateWithPassword(worker?.userPassword, error: &error)) {
                NSLog("Error authenticating: %@", error!)
            }
        }
        
        internal func xmppStreamDidAuthenticate(sender: XMPPStream!) {
            NSLog("xmppStreamDidAuthenticate")
            goOnline()
        }
        
        internal func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
            NSLog("didNotAuthenticate")
        }
        
        internal func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
            NSLog("didReceiveMessage: %@", message)
        }
        
        func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
            NSLog("didReceiveIQ: %@", iq)
            return false
        }
        
        internal func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
            NSLog("didReceivePresence <- from: %@", presence)
        }
        
        internal func xmppStream(sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
            if !worker!.isXmppConnected {
                NSLog("didReceiveError: Unable to connect to server.")
            } else {
                NSLog("didReceiveError: %@", error.stringValue())
            }
        }
        
        func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
            NSLog("didReceivePresenceSubscriptionRequest <- %@", presence)
        }
    }
}