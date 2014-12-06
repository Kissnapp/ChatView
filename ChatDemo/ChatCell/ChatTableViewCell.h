//
//  ChatCellTableViewCell.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatCellMessage;
@interface ChatTableViewCell : UITableViewCell
{
    @protected
    UILabel * _messageFromLabel;
    UIImageView * _background; // bubble view
    UIImageView * _avatarView;
    ChatCellMessage * _message;
}

@property (nonatomic, strong) ChatCellMessage * message;

- (void)layoutMessageBody:(CGRect)frame;

@end
