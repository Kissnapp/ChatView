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

+ (instancetype)messageWithImageURL:(NSString *)imageURL imageSize:(CGSize)size direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage;
{
    return nil;
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

- (instancetype)initWithImageURL:(NSString *)imageURL imageSize:(CGSize)size direction:(MessageDirection)direction avatarImage:(UIImage *)avatarImage;
{
    self = [super init];
    if(self) {
        _messageType = MessageTypePicture;
        _image = [self blankImage];
        self.avatar = avatarImage;
        self.direction = direction;
        [self applyDefaults];
    }
    return self;
}

- (UIImage*)blankImage {
    static UIImage * sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat w = screenWidth * 0.4f;
            CGSize size = CGSizeMake(w, w * (3.f/4.f));
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
            CGContextFillRect(context, (CGRect){ {0,0}, size} );
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            sharedInstance = image;
        }
    }
    return sharedInstance;
}

- (void)applyDefaults {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat w = screenWidth * 0.4f;
    if(_image.size.width > _image.size.height) {
        if(_image.size.width > w) {
            _image = [_image resizedImageToFitInSize:CGSizeMake(w, _image.size.height) scaleIfSmaller:NO];
        }
    }
    else {
        _image = [_image resizedImageToFitInSize:CGSizeMake(w, _image.size.height) scaleIfSmaller:NO];
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