//
//  ChatCellMessage.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellMessage.h"
#import "ChatTableViewCellTemplate.h"

const CGFloat MessageCellBubblePadding = 7.0f;
const CGFloat MessageCellBubbleTailWidth = 5.f;
const CGFloat MessageCellTopPadding = 3.2f;
const CGFloat MessageCellMessageFontSize = 15.0f;
const CGFloat MessageCellMessageFromFontSize = 12.0f;
const CGFloat MessageCellTimestampFontSize = 12.0f;
const CGFloat MessageCellAvatarWidth = 40.f;
const CGFloat MessageCellAvatarMargin = 3.f;
const CGFloat MessageCellMessageFromMargin = 3.f;
const CGFloat MessageCellMessageFromHeight = 10.f;

#define _hasMessageFrom (!(!_messageFrom || 0 == _messageFrom.length))

@interface ChatCellMessage()

@end

@implementation ChatCellMessage

- (void)calculateSizesByConstranedWidth:(CGFloat)width {
    _calculatedContentBoxSize = _calulatedCellSize =
    CGSizeMake(MessageCellAvatarWidth, MessageCellAvatarWidth);
}

- (BOOL)hasMessageFrom {
    return _hasMessageFrom;
}

- (BOOL)showAvatar {
    return _avatar && _showAvatar;
}

- (void)setShowAvatar:(BOOL)showAvatar {
    if(showAvatar && _avatar!=nil) {
        _showAvatar = YES;
        return;
    }
    _showAvatar = NO;
}

- (BOOL)showMessageFrom {
    return _hasMessageFrom && _showMessageFrom;
}

- (CGSize)calculatedContentBoxSize {
    return _calculatedContentBoxSize;
}

- (CGSize)calculatedCellSize {
    return _calulatedCellSize;
}

- (ChatTableViewCellTemplate*)dequeAndCreateCellFromTableView:(UITableView*)tableView
{
    static NSString * cellIdentifier = @"chatViewCell";
    ChatTableViewCellTemplate * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatTableViewCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = self;
    return cell;
}
@end
