//
//  ChatCellMessage.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

FOUNDATION_EXPORT const CGFloat MessageCellBubblePadding;
FOUNDATION_EXPORT const CGFloat MessageCellTopPadding;
FOUNDATION_EXPORT const CGFloat MessageCellMessageFontSize;
FOUNDATION_EXPORT const CGFloat MessageCellMessageFromFontSize;
FOUNDATION_EXPORT const CGFloat MessageCellTimestampFontSize;
FOUNDATION_EXPORT const CGFloat MessageCellAvatarWidth;
FOUNDATION_EXPORT const CGFloat MessageCellAvatarMargin;
FOUNDATION_EXPORT const CGFloat MessageCellMessageFromMargin;
FOUNDATION_EXPORT const CGFloat MessageCellMessageFromHeight;
FOUNDATION_EXPORT const CGFloat MessageCellMessageFromWidth;

#define MESSAGE_FROM_HEIGHT (MessageCellMessageFromHeight + MessageCellMessageFromMargin)

typedef NS_ENUM(NSUInteger, MessageDirection) {
    MessageFromMe = 0,
    MessageFromOppsite
};

@interface ChatCellMessage : NSObject

@property (nonatomic, copy) NSString * messageFrom;
@property (nonatomic, strong) UIImage * avatar;
@property (nonatomic, assign) MessageDirection direction;

@property (nonatomic) BOOL showMessageFrom;
@property (nonatomic) BOOL showAvatar;

@property (nonatomic, readonly) CGSize calculatedBubbleSize;
@property (nonatomic, readonly) CGSize calculatedCellSize;

- (BOOL)hasMessageFrom;

@end
