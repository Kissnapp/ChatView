//
//  ChatCellTableViewCell.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatCellMessage;
@class ChatTableViewCellTemplate;

@protocol ChatTableViewCellDelegate
@optional
- (void)didAvatarTapedWithCell:(ChatTableViewCellTemplate*)messageCell;
- (void)didHoldAndPressOnMessage:(ChatTableViewCellTemplate*)messageCell;
@end

@interface ChatTableViewCellTemplate : UITableViewCell
{
    @protected
    UILabel * _messageFromLabel;
    UIImageView * _avatarView;
    UIView * _bodyView;
    ChatCellMessage * _message;
}

@property (nonatomic, strong) ChatCellMessage * message;

@property (weak) id<ChatTableViewCellDelegate> chatCellDelegate;

- (void)layoutMessageBody;

@end
