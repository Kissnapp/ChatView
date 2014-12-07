//
//  ChatTableViewTextCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatBubbleTextCell.h"
#import "ChatCellTextMessage.h"

@interface ChatBubbleTextCell()
{
    UILabel * _messageLabel;
    UIImageView * _bubbleView; // bubble view
}
@end

@implementation ChatBubbleTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self.textLabel removeFromSuperview];
        [self.contentView addSubview:_avatarView];
        [self.contentView setFrame:self.frame];
        
        _bubbleView = [[UIImageView alloc] init];
        [_bodyView addSubview:_bubbleView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        [_bodyView addSubview:_messageLabel];
    }
    return self;
}

- (void)setMessage:(ChatCellMessage *)message
{
    [super setMessage:message];
    if([message isKindOfClass:[ChatCellTextMessage class]]) {
        if(_message.direction == MessageFromMe) {
            _bubbleView.image = [[UIImage imageNamed:@"talk_pop_r_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
        } else {
            _bubbleView.image = [[UIImage imageNamed:@"talk_pop_l_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
        }
        
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:MessageCellMessageFontSize];
        _messageLabel.text = ((ChatCellTextMessage*)message).message;
    }
}

- (void)layoutMessageBody
{
//    [_bubbleView setBackgroundColor:[UIColor yellowColor]];
    [_bubbleView setFrame:_bodyView.bounds];
    
    CGFloat tailOffset = MessageCellBubblePadding;
    if(_message.direction == MessageFromOppsite)
        tailOffset += MessageCellBubbleTailWidth;
//    [_messageLabel setBackgroundColor:[UIColor greenColor]];
    
    CGSize size = ((ChatCellTextMessage*)_message).calculatedMessageSize;
    [_messageLabel setFrame:CGRectMake(tailOffset, MessageCellBubblePadding, size.width, size.height)];
}

- (UILabel*)textLabel {
    return _messageLabel;
}

@end
