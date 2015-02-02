//
//  ChatCellTimeLabel.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 21/1/15.
//  Copyright (c) 2015 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellMessage.h"

@interface ChatCellTimeLabel : ChatCellMessage

@property (nonatomic, copy) NSString * timeAgoStr;

- (id)initWithTimeString:(NSString*)time;

@end
