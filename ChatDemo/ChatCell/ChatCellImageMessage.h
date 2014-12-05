//
//  ChatCellImageMessage.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellMessage.h"

@interface ChatCellImageMessage : ChatCellMessage
+ (instancetype)messageWithImage:(UIImage*)image;
+ (instancetype)messageWithImage:(UIImage *)image avatarImage:(UIImage *)avatarImage;
+ (instancetype)messageWithImage:(UIImage *)image direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage;

- (instancetype)initWithImage:(UIImage *)avatarImage;
- (instancetype)initWithImage:(UIImage *)image avatarImage:(UIImage *)avatarImage;
- (instancetype)initWithImage:(UIImage *)image direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage;

@property (nonatomic, strong) UIImage * image;
@end
