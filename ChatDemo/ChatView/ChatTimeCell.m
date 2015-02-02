//
//  ChatTimeCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 21/1/15.
//  Copyright (c) 2015 LIU CHONGLIANG. All rights reserved.
//

#import "ChatTimeCell.h"
#import "ChatCellTimeLabel.h"

@interface ChatTimeCell()
{
    UILabel * _messageLabel;
}
@end

@implementation ChatTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self.contentView setBackgroundColor:[UIColor redColor]];
        
        _messageLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}

- (void)setMessage:(ChatCellMessage *)message
{
    [super setMessage:message];
    if([message isKindOfClass:[ChatCellTimeLabel class]]) {
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = ((ChatCellTimeLabel*)message).timeAgoStr;
        
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:MessageCellTimestampFontSize];
    }
}

- (void)layoutMessageBody
{
    CGSize size = ((ChatCellTimeLabel*)_message).calculatedCellSize;
    [_messageLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
}

@end
