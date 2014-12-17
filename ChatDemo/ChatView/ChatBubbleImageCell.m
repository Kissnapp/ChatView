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
    UIImageView * _imageView;
    UIImageView * _bubbleView; // bubble view
    NSTimer * _holdPressTimer;
    UIActivityIndicatorView * _loadingActivityView;
}
@end

@implementation ChatBubbleImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _imageLoadingStatus = ChatBubbleImageBeforeLoading;
        _loadingActivityView = nil;
        
        _imageView = [[UIImageView alloc] init];
        
        [self.textLabel removeFromSuperview];
        [self.contentView addSubview: _imageView];
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

void setBubble(UIImageView * imageView, UIImage * image, NSString * imageName) {
    UIEdgeInsets insets = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    UIImage *mask = [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:insets]
                     renderAtSize:image.size];
    UIImage *masked = [image maskWithImage:mask];
    [imageView setImage: masked];
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
        setBubble(_bubbleView, ((ChatCellImageMessage*)_message).image, @"talk_pop_r_mask");
    } else {
        setBubble(_bubbleView, ((ChatCellImageMessage*)_message).image, @"talk_pop_l_mask");
    }
//    [_bodyView setBackgroundColor: [UIColor greenColor]];
}

- (BOOL)loadImage {
    if (_imageURL) {
        if (_loadingActivityView) [_loadingActivityView removeFromSuperview];
        _loadingActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_bubbleView addSubview:_loadingActivityView];
        [_loadingActivityView startAnimating];
        self.imageLoadingStatus = ChatBubbleImageLoading;
        _loadingActivityView.center = _bubbleView.center;
        return YES;
    }
    self.imageLoadingStatus = ChatBubbleImageLoadingFailed;
    if (_loadingActivityView) {
        [_loadingActivityView stopAnimating];
        [_loadingActivityView removeFromSuperview];
    }
    return NO;
}

- (void)setMessage:(ChatCellMessage *)message
{
    [super setMessage:message];
    if([message isKindOfClass:[ChatCellImageMessage class]]) {
        UIImage * image = ((ChatCellImageMessage*)message).image;
        [_imageView setImage:image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
//        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [_bubbleView addSubview:activityView];
//        [activityView startAnimating];
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
