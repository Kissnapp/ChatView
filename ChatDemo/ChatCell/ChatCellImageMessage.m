//
//  ChatCellImageMessage.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellImageMessage.h"

@implementation ChatCellImageMessage

+ (instancetype)messageWithImage:(UIImage*)image {
   return [ChatCellImageMessage messageWithImage:image avatarImage:nil];
}

+ (instancetype)messageWithImage:(UIImage *)image avatarImage:(UIImage *)avatarImage {
    return [[ChatCellImageMessage alloc] initWithImage:image avatarImage:avatarImage];
}

+ (instancetype)messageWithImage:(UIImage *)image direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage {
    return [[ChatCellImageMessage alloc] initWithImage:image direction:direction avatarImage:avatarImage];
}

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithImage:image];
}

- (instancetype)initWithImage:(UIImage *)image avatarImage:(UIImage *)avatarImage {
    self = [super init];
    if(self) {
        _messageType = MessageTypePicture;
        _image = image;
        self.avatar = avatarImage;
        [self applyDefaults];
    }
    return self;
}

- (void)applyDefaults {
    
}

- (instancetype)initWithImage:(UIImage *)image direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage {
    self = [super init];
    if(self) {
        _image = image;
        self.avatar = avatarImage;
        self.direction = direction;
        [self applyDefaults];
    }
    return self;
}
@end
