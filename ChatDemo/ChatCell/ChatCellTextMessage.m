//
//  Message.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellTextMessage.h"
#import "ChatTableViewTextCell.h"

@interface ChatCellTextMessage()
{
    CGSize _calulatedCellSize, _calculatedBubbleSize;
}
@end

@implementation ChatCellTextMessage

- (CGSize)sizeForCellMessage:(ChatCellMessage*)message constrainedToWidth:(CGFloat)width {
    CGSize size = [self sizeForBubbleMessage:message constrainedToWidth:width];
    CGFloat calculatedHeight = MessageCellBubblePadding + size.height + MessageCellTopPadding*2;
    return CGSizeMake(size.width, calculatedHeight);
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
    
    _calulatedCellSize = [self sizeForCellMessage:self constrainedToWidth:screenWidth * (2.f/3.f)];
    
    // 除去Top－Margin
    _calculatedBubbleSize = CGSizeMake(_calulatedCellSize.width, _calulatedCellSize.height - MessageCellTopPadding*2);
}

- (CGSize)calculatedCellSize
{
    if([self hasMessageFrom] && [self showMessageFrom]) {
        CGSize rect = CGSizeMake(_calulatedCellSize.width, _calulatedCellSize.height + MESSAGE_FROM_HEIGHT);
//        if (self.showAvatar) {
//            rect.height = fmax(_calulatedCellSize.height + MESSAGE_FROM_HEIGHT,
//                               MessageCellAvatarWidth/* So far equals to Height */);
//        }
        return rect;
    }
    return _calulatedCellSize;
}

- (CGSize)calculatedBubbleSize {
    return _calculatedBubbleSize;
}

- (ChatTableViewCell*)dequeAndCreateCellFromTableView:(UITableView*)tableView
{
    static NSString * cellIdentifier = @"chatViewTextCell";
    ChatTableViewTextCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatTableViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = self;
    return cell;
}

@end
