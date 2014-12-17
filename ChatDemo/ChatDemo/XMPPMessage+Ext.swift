//
//  MyMessage.swift
//  ChatDemo
//
//  Created by LIU Chong Liang on 12/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

import Foundation

enum MessageType : Int {
    case
    Text = 1,
    Image,
    ImageURL,
    Voice,
    VoiceURL
}

extension XMPPMessage {
    func fromResourceStr() ->String? {
        let from = self.fromStr()
        let range:Range? = from.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
        let s = from.substringFromIndex(advance(range!.startIndex, 1)).lowercaseString
        return s
    }

    func content() ->(messageType: MessageType, data:AnyObject?) {
        if self.fromResourceStr() != "gajim" {
            return (MessageType.Text, self.body())
        }
        var parseError: NSError?
        if let content = self.elementForName("body").stringValue() {
            content.dataUsingEncoding(1, allowLossyConversion: false)
            let parsedDictionary = NSJSONSerialization.JSONObjectWithData(content.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &parseError)
                as? NSDictionary
            if nil == parsedDictionary {
                return (MessageType.Text, content)
            }
            return (MessageType.ImageURL, parsedDictionary)
        }
        return (MessageType.Text, self.body())
    }
    
//    func messageId() ->String {
//        var id = self.attributeStringValueForName("id")
//        let v = id + "_" + self.elementForName("thread").stringValue()
//        return v
//    }
}