//
//  ChatTableViewImageCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 6/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatBubbleImageCell.h"
#import "ChatCellImageMessage.h"
#import "UIImage+Utils.h"
#import "UIImageView+WebCache.h"

@interface ChatBubbleImageCell()
{
    UIImageView * _bubbleView; // bubble view
    NSTimer * _holdPressTimer;
    UIActivityIndicatorView * _loadingActivityView;
}
@end

@implementation ChatBubbleImageCell

+ (SDImageCache*) imageCache {
    static SDImageCache * imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[SDImageCache alloc] initWithNamespace:@"chatCellImages"];
    });
    return imageCache;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _imageLoadingStatus = ChatBubbleImageBeforeLoading;
        _loadingActivityView = nil;
        
        [self.textLabel removeFromSuperview];
        [self.contentView addSubview:_avatarView];
        [self.contentView setFrame:self.frame];
        
        _bubbleView = [[UIImageView alloc] init];
        [_bodyView addSubview:_bubbleView];
        
        UILongPressGestureRecognizer * ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleLongPress:)];
        ges.minimumPressDuration = .5f;
        ges.allowableMovement = 600;
        [_bubbleView setUserInteractionEnabled:YES];
        [_bubbleView addGestureRecognizer:ges];
    }
    return self;
}

- (void)renderBubble:(UIImage*)image withImageName:(NSString*)imageName {
    UIEdgeInsets insets = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    UIImage *mask = [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:insets]
                     renderAtSize:_bubbleView.bounds.size];
    UIImage *masked = [image maskWithImage:mask];
    [_bubbleView setImage: masked];
    
    if(_loadingActivityView) {
        if (_imageLoadingStatus == ChatBubbleImageLoading) {
            _loadingActivityView.center = _bubbleView.center;
            [_loadingActivityView setHidden:NO];
        } else if(_imageLoadingStatus == ChatBubbleImageLoadingDone
                  || _imageLoadingStatus == ChatBubbleImageLoadingFailed
                  ) {
            [_loadingActivityView removeFromSuperview];
        }
    }
}

- (void)layoutMessageBody
{
    UIImage *img = ((ChatCellImageMessage*)_message).image;
    CGFloat m = 0;
    if(img.size.width >_bodyView.bounds.size.width)
        [_bubbleView setFrame:_bodyView.bounds];
    else {
        m = img.size.width - CGRectGetWidth(_bodyView.bounds);
        if(_message.direction == MessageFromMe)
            m = -m;
        else
            m = 0;
        [_bubbleView setFrame:CGRectMake(m, 0, img.size.width, img.size.height)];
    }
    
    if(_message.direction == MessageFromMe) {
        [self renderBubble:((ChatCellImageMessage*)_message).image withImageName:@"talk_pop_r_mask"];
    } else {
        [self renderBubble:((ChatCellImageMessage*)_message).image withImageName:@"talk_pop_l_mask"];
    }
//    [_bodyView setBackgroundColor: [UIColor greenColor]];
}

- (void)setLoading {
    ChatCellImageMessage* message = (ChatCellImageMessage*)_message;
    if (message.image) {
        if (_loadingActivityView) [_loadingActivityView removeFromSuperview];
        _loadingActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_bubbleView addSubview:_loadingActivityView];
        [_loadingActivityView startAnimating];
        self.imageLoadingStatus = ChatBubbleImageLoading;
        _loadingActivityView.center = _bubbleView.center;
        return;
    }
    self.imageLoadingStatus = ChatBubbleImageLoadingFailed;
    if (_loadingActivityView) {
        [_loadingActivityView stopAnimating];
        [_loadingActivityView removeFromSuperview];
    }
}

- (void)setMessage:(ChatCellMessage *)message
{
    [super setMessage:message];
    if([message isKindOfClass:[ChatCellImageMessage class]]) {
        ChatCellImageMessage * msg = (ChatCellImageMessage*)message;
        if (msg.imageURL) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:msg.imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    UIImage * img = [image renderAtSize:msg.image.size];
                    msg.image = img;
                    _imageLoadingStatus = ChatBubbleImageLoadingDone;
                    if(_message.direction == MessageFromMe) {
                        [self renderBubble:((ChatCellImageMessage*)_message).image withImageName:@"talk_pop_r_mask"];
                    } else {
                        [self renderBubble:((ChatCellImageMessage*)_message).image withImageName:@"talk_pop_l_mask"];
                    }
                }
            }];
            [_loadingActivityView setHidden:YES];
            _imageLoadingStatus = ChatBubbleImageLoading;
            [self setLoading];
        }
    }
}

- (void)bubbleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _holdPressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(handleHoldPressTimer:) userInfo:nil repeats:NO];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled
              || gestureRecognizer.state == UIGestureRecognizerStateFailed
              || gestureRecognizer.state == UIGestureRecognizerStateEnded
              ) {
        [_holdPressTimer invalidate];
        _holdPressTimer = nil;
    }
}

- (void)handleHoldPressTimer:(NSTimer*)timer {
    if(self.chatCellDelegate) {
        [self.chatCellDelegate didHoldAndPressOnMessage:self];
    }
}

@end
