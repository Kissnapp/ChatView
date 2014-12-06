//
//  ChatTableViewTextCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 5/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatTableViewTextCell.h"
#import "ChatCellTextMessage.h"

@interface ChatTableViewTextCell()
{
    UILabel * _messageLabel;
}
@end

@implementation ChatTableViewTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _background = [[UIImageView alloc] initWithFrame:self.frame];
        [self.contentView addSubview:_background];
        
        _messageLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:MessageCellMessageFontSize];
        
        [self.textLabel removeFromSuperview];
        [self.contentView addSubview: _messageLabel];
        [self.contentView addSubview:_avatarView];
        [self.contentView setFrame:self.frame];
    }
    return self;
}

- (void)setMessage:(ChatCellMessage *)message
{
    [super setMessage:message];
    if([message isKindOfClass:[ChatCellTextMessage class]]) {
        _messageLabel.text = ((ChatCellTextMessage*)message).message;
    }
}

- (void)layoutMessageBody:(CGRect)frame
{
    [_messageLabel setFrame:frame];
}

- (UILabel*)textLabel {
    return _messageLabel;
}

@end
