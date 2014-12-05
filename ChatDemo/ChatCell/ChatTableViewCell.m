//
//  ChatCellTableViewCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatTableViewCell()
{
    UILabel * _messageFromLabel;
    UILabel * _messageLabel;
    UIImageView * _background; // bubble view
    UIImageView * _avatarView;
}
@end

@implementation ChatTableViewCell

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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setMessage:(ChatCellTextMessage *)message
{
    _message = message;
    _messageLabel.text = message.message;
    if(_message.avatar) {
        _avatarView = [[UIImageView alloc] initWithImage:_message.avatar];
        _avatarView.frame = CGRectMake(MessageCellAvatarMargin, 0, MessageCellAvatarWidth, MessageCellAvatarWidth);
        [self.contentView addSubview:_avatarView];
    }
    if(_message.direction == MessageFromMe) {
        _background.image = [[UIImage imageNamed:@"talk_pop_r_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
    } else {
        _background.image = [[UIImage imageNamed:@"talk_pop_l_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
    }
    if(_message.messageFrom) {
        _messageFromLabel = [[UILabel alloc] init];
        _messageFromLabel.text = _message.messageFrom;
        _messageFromLabel.numberOfLines = 1;
        _messageFromLabel.font = [UIFont systemFontOfSize:MessageCellMessageFromFontSize];
        [self.contentView addSubview:_messageFromLabel];
    }
}

- (UILabel*)textLabel {
    return _messageLabel;
}

- (void)updateFrame {
    CGRect frame = self.contentView.frame;
    CGFloat windowWidth = frame.size.width;
    CGFloat width = _message.calculatedBubbleSize.width;
    CGFloat height = _message.calculatedBubbleSize.height;
    CGFloat margin = 13;
    CGFloat messageLabelX = 0;
    CGFloat messageLabelY = 0;
    
    if(_message.showAvatar) {
        if(_message.direction == MessageFromMe) {
            messageLabelX -= MessageCellAvatarMargin + MessageCellAvatarWidth + MessageCellAvatarMargin;
            CGRect f = _avatarView.frame;
            [_avatarView setFrame:CGRectMake(windowWidth - MessageCellAvatarWidth - MessageCellAvatarMargin, f.origin.y, f.size.width, f.size.height)];
        } else {
            messageLabelX = MessageCellAvatarMargin + MessageCellAvatarWidth + MessageCellAvatarMargin;
        }
    }
    
    if(_message.showMessageFrom) {
        messageLabelY = MESSAGE_FROM_HEIGHT;
        CGFloat fromX = messageLabelX + 5;
        if(_message.direction == MessageFromMe) {
            fromX = windowWidth - (MessageCellAvatarMargin + MessageCellAvatarWidth + MessageCellAvatarMargin) - MessageCellMessageFromWidth;
            [_messageFromLabel setTextAlignment:NSTextAlignmentRight];
        }
        [_messageFromLabel setFrame:CGRectMake(fromX, 0, MessageCellMessageFromWidth, MessageCellMessageFromHeight)];
    }
    
    frame.size.width = width;
    if (_message.direction == MessageFromMe) {
        frame.origin.x += windowWidth - width;
        [_background setFrame:CGRectMake(frame.origin.x - MessageCellBubblePadding - margin + messageLabelX, messageLabelY,
                                         frame.size.width + MessageCellBubblePadding + margin, height)];
        margin = frame.origin.x - margin;
    }
    else {
        [_background setFrame:CGRectMake(messageLabelX, messageLabelY,
                                         frame.size.width + MessageCellBubblePadding + margin, height)];
    }
    [_messageLabel setFrame:CGRectMake(margin + messageLabelX, messageLabelY, frame.size.width, height)];
    
    [self.contentView setFrame:CGRectMake(0, MessageCellTopPadding, windowWidth, frame.size.height)];
}

- (void)layoutSubviews {
    [self updateFrame];
}

@end
