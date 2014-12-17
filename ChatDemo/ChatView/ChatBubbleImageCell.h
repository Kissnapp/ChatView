//
//  ChatTableViewImageCell.h
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 6/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatTableViewCellTemplate.h"

typedef NS_ENUM(NSUInteger, ChatBubbleImageLoadStatus) {
    ChatBubbleImageBeforeLoading = 0,
    ChatBubbleImageLoading,
    ChatBubbleImageLoadingDone,
    ChatBubbleImageLoadingFailed,
};

@interface ChatBubbleImageCell : ChatTableViewCellTemplate

@property (nonatomic, assign) ChatBubbleImageLoadStatus imageLoadingStatus;
@property (nonatomic, copy) NSString * imageURL;

- (BOOL)loadImage;

@end
