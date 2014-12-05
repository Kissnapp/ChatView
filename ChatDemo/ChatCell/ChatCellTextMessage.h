//
//  Message.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatCellMessage.h"

@interface ChatCellTextMessage : ChatCellMessage

+ (CGSize)sizeForCellMessage:(ChatCellTextMessage*)message constrainedToWidth:(CGFloat)width;
+ (CGSize)sizeForBubbleMessage:(ChatCellTextMessage*)message constrainedToWidth:(CGFloat)width;

+ (instancetype)messageWithString:(NSString *)message;
+ (instancetype)messageWithString:(NSString *)message avatarImage:(UIImage *)image;
+ (instancetype)messageWithString:(NSString *)message direction:(MessageDirection)direction avatarImage:(UIImage *)image;

- (instancetype)initWithString:(NSString *)message;
- (instancetype)initWithString:(NSString *)message avatarImage:(UIImage *)image;
- (instancetype)initWithString:(NSString *)message direction:(MessageDirection)direction avatarImage:(UIImage *)image;

@property (nonatomic, copy) NSString * message;

@end
