//
//  ChatCellMessage.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellMessage.h"

const CGFloat MessageCellBubblePadding = 7.0f;
const CGFloat MessageCellTopPadding = 3.2f;
const CGFloat MessageCellMessageFontSize = 15.0f;
const CGFloat MessageCellMessageFromFontSize = 12.0f;
const CGFloat MessageCellTimestampFontSize = 12.0f;
const CGFloat MessageCellAvatarWidth = 40.f;
const CGFloat MessageCellAvatarMargin = 3.f;
const CGFloat MessageCellMessageFromMargin = 3.f;
const CGFloat MessageCellMessageFromHeight = 10.f;
const CGFloat MessageCellMessageFromWidth = 200.f;

#define _hasMessageFrom (!(!_messageFrom || 0 == _messageFrom.length))

@implementation ChatCellMessage

- (instancetype)init {
    self = [super init];
    if(self) {
        [self applyDefaults];
    }
    return self;
}

- (void)applyDefaults {
    _showAvatar = _avatar != nil;
    _showMessageFrom = _hasMessageFrom;
    _direction = MessageFromMe;
}

- (BOOL)hasMessageFrom {
    return _hasMessageFrom;
}

- (BOOL)showAvatar {
    return _avatar && _showAvatar;
}
//
//- (void)setShowAvatar:(BOOL)showAvatar {
//    if(showAvatar && _avatar)
//        _showAvatar=YES;
//    
//}

- (BOOL)showMessageFrom {
    return _hasMessageFrom && _showMessageFrom;
}

@end
