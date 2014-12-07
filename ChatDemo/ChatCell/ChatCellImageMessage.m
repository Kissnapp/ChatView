//
//  ChatCellImageMessage.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellImageMessage.h"
#import "ChatBubbleImageCell.h"
#import "UIImage+Resize.h"

@interface ChatCellImageMessage()
@end

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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat w = screenWidth * 0.7f;
    if(_image.size.width > _image.size.height) {
        if(_image.size.width > 2) {
            _image = [_image resizedImageToFitInSize:CGSizeMake(w, _image.size.height) scaleIfSmaller:NO];
        }
    }
    [self calculateSizesByConstranedWidth:w];
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

- (void)setImage:(UIImage *)image {
    _image = image;
    if(image) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat w = screenWidth * 0.7f;
        [self calculateSizesByConstranedWidth:w];
    }
}

- (void)calculateSizesByConstranedWidth:(CGFloat)width {
    CGSize imageSize = [_image size];
    CGFloat cellHeight = MessageCellBubblePadding*2 + imageSize.height + MessageCellTopPadding;
    
    _calulatedCellSize = CGSizeMake(width, cellHeight);

    _calculatedContentBoxSize = CGSizeMake(width, _calulatedCellSize.height - (MessageCellBubblePadding*2 + MessageCellTopPadding));
}

- (ChatTableViewCellTemplate*)dequeAndCreateCellFromTableView:(UITableView*)tableView
{
    static NSString * cellIdentifier = @"chatViewImageCell";
    ChatBubbleImageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatBubbleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = self;
    return cell;
}

@end
