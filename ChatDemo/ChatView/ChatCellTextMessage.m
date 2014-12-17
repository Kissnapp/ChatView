//
//  Message.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellTextMessage.h"
#import "ChatBubbleTextCell.h"

@interface ChatCellTextMessage()
{
}
@end

@implementation ChatCellTextMessage

+ (instancetype)messageWithString:(NSString *)message
{
    return [ChatCellTextMessage messageWithString:message avatarImage:nil];
}

+ (instancetype)messageWithString:(NSString *)message avatarImage:(UIImage *)image
{
    return [[ChatCellTextMessage alloc] initWithString:message avatarImage:image];
}

+ (instancetype)messageWithString:(NSString *)message direction:(MessageDirection)direction avatarImage:(UIImage *)image
{
    return [[ChatCellTextMessage alloc] initWithString:message direction:direction avatarImage:image];
}

- (instancetype)initWithString:(NSString *)message
{
    return [self initWithString:message avatarImage:nil];
}

- (instancetype)initWithString:(NSString *)message avatarImage:(UIImage *)image
{
    self = [super init];
    if(self)
    {
        _message = message;
        [super setAvatar:image];
        [self applyDefaults];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)message direction:(MessageDirection)direction avatarImage:(UIImage *)image;
{
    self = [super init];
    if(self)
    {
        _message = message;
        [self setAvatar:image];
        [self setDirection:direction];
        [self applyDefaults];
    }
    return self;
}

- (void)applyDefaults {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    [self calculateSizesByConstranedWidth:screenWidth * 0.7];
}

- (CGSize)calculatedCellSize
{
    if([self hasMessageFrom] && [self showMessageFrom]) {
        CGSize rect = CGSizeMake(_calulatedCellSize.width, _calulatedCellSize.height + MESSAGE_FROM_HEIGHT);
        return rect;
    }
    return _calulatedCellSize;
}

- (ChatTableViewCellTemplate*)dequeAndCreateCellFromTableView:(UITableView*)tableView
{
    static NSString * cellIdentifier = @"chatViewTextCell";
    ChatBubbleTextCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatBubbleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = self;
    return cell;
}

- (void)calculateSizesByConstranedWidth:(CGFloat)width {
    CGSize size = [self sizeForBubbleMessage:self constrainedToWidth:width - (MessageCellBubblePadding*2 + MessageCellBubbleTailWidth)];
    CGFloat calculatedHeight = size.height;
//    if(calculatedHeight < MessageCellAvatarWidth) {
//        calculatedHeight = MessageCellAvatarWidth + MessageCellTopPadding;
//        size.height = MessageCellAvatarWidth;
//    }
    _calulatedCellSize = CGSizeMake(width + (MessageCellBubblePadding*2 + MessageCellBubbleTailWidth)
                                    , calculatedHeight + MessageCellTopPadding  + MessageCellBubblePadding*2);
    _calculatedContentBoxSize = CGSizeMake(size.width + (MessageCellBubblePadding*2)
                                        , calculatedHeight + MessageCellBubblePadding*2);
    
    _calculatedMessageSize = size;
}

- (CGSize)sizeForBubbleMessage:(ChatCellMessage*)message constrainedToWidth:(CGFloat)width {
    // must be multi-line
//    return ceil([((ChatCellTextMessage*)message).message sizeWithFont:[UIFont systemFontOfSize:MessageCellMessageFontSize]
//                                constrainedToSize:CGSizeMake(width, MAXFLOAT)
//                                    lineBreakMode:NSLineBreakByWordWrapping].height);

    UIFont * f = [UIFont systemFontOfSize:MessageCellMessageFontSize];
    CGRect rect = [((ChatCellTextMessage*)message).message boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:@{NSFontAttributeName:f}
                                                context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

@end
