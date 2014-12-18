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
#import "UIImageView+WebCache.h"

@interface ChatCellImageMessage()
{
}
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

+ (instancetype)messageWithBlankImageWithURL:(NSURL*)url withImageSize:(CGSize)size withDirection:(MessageDirection)direction avatarImage:(UIImage *)avatarImage
{
    return [[ChatCellImageMessage alloc] initPlaceholderWithURL:url withImageSize:size withDirection:direction avatarImage:avatarImage];
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

- (instancetype)initPlaceholderWithURL:(NSURL*)url withImageSize:(CGSize)size withDirection:(MessageDirection)direction avatarImage:(UIImage *)avatarImage
{
    self = [super init];
    if(self) {
        _messageType = MessageTypePicture;
        _image = [self blankImageWithRatio:size.width / size.height];
        self.avatar = avatarImage;
        self.imageURL = url;
        self.direction = direction;
        [self applyDefaults];
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
//    __weak ChatCellImageMessage* weakself = self;
//    SDWebImageManager * imgMgr = [SDWebImageManager sharedManager];
//    [imgMgr downloadImageWithURL:_imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if(image && finished) {
//            [[[weakself class] imageCache] storeImage:image forKey:[_imageURL.absoluteString copy]];
//        }
//    }];
    
//    [[[self class] imageCache] queryDiskCacheForKey:_imageURL.absoluteString done:^(UIImage *image, SDImageCacheType cacheType) {
//        if(image != nil)
//            weakself.image = image;
//        else {
//            NSLog(@"Unable to load image from URL: %@", _imageURL.absoluteString);
//        }
//    }];
}

- (UIImage*)blankImageWithRatio:(CGFloat)ratio {
    static UIImage * sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat w = screenWidth * 0.4f;
            CGSize size = CGSizeMake(w, w / ratio);
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
    [self calcSize];
}

- (void)calcSize
{
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
