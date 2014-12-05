//
//  ChatCellTableViewCell.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCellTextMessage.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) ChatCellTextMessage * message;

@end
