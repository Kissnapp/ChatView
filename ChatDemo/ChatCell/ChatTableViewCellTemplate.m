//
//  ChatCellTableViewCell.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatTableViewCellTemplate.h"
#import "ChatCellMessage.h"

@interface ChatTableViewCellTemplate()
{
}
@end

@implementation ChatTableViewCellTemplate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bodyView = [[UIView alloc] init];
        [self.contentView addSubview:_bodyView];
        [self.textLabel removeFromSuperview];
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

- (void)setMessage:(ChatCellMessage *)message
{
    _message = message;
    if(_message.showAvatar) {
        if(_avatarView)
           [_avatarView removeFromSuperview];
        _avatarView = [[UIImageView alloc] initWithImage:_message.avatar];
        _avatarView.frame = CGRectMake(MessageCellAvatarMargin, 0, MessageCellAvatarWidth, MessageCellAvatarWidth);
        [self.contentView addSubview:_avatarView];
    }
    if(_message.messageFrom) {
        if(_messageFromLabel) {
            [_messageFromLabel removeFromSuperview];
        }
        _messageFromLabel = [[UILabel alloc] init];
        _messageFromLabel.text = _message.messageFrom;
        _messageFromLabel.numberOfLines = 1;
        _messageFromLabel.font = [UIFont systemFontOfSize:MessageCellMessageFromFontSize];
        _messageFromLabel.textColor = [UIColor grayColor];
//        [_messageFromLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:_messageFromLabel];
    }
}

- (void)updateLayout {
    CGRect frame = self.contentView.frame;
    CGFloat windowWidth = frame.size.width;
    CGSize contentSize = _message.calculatedContentBoxSize;
    CGFloat boxWidth = contentSize.width;
    CGFloat boxHeight = contentSize.height;
    CGFloat messageBodyX = 0;
    CGFloat messageLabelX = 0;
    CGFloat messageLabelY = 0;
    CGFloat avatarWidth = MessageCellAvatarMargin;
    
    if(_message.showAvatar) {
        avatarWidth = (MessageCellAvatarMargin + MessageCellAvatarWidth + MessageCellAvatarMargin);
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
            fromX = windowWidth - avatarWidth - boxWidth - MessageCellBubbleTailWidth;
            [_messageFromLabel setTextAlignment:NSTextAlignmentRight];
        }
        [_messageFromLabel setFrame:CGRectMake(fromX, 0, boxWidth, MessageCellMessageFromHeight)];
    }
    
    frame.size.width = boxWidth;
    if (_message.direction == MessageFromMe) {
        frame.origin.x += windowWidth - boxWidth - MessageCellBubbleTailWidth;
        messageBodyX = frame.origin.x;
        avatarWidth = -avatarWidth;
    }
    else {
    }
    
//    [_bodyView setBackgroundColor:[UIColor grayColor]];
    [_bodyView setFrame:CGRectMake(messageBodyX + avatarWidth, messageLabelY,
                                   frame.size.width + MessageCellBubbleTailWidth, boxHeight)];
    
    [self layoutMessageBody];
    [self.contentView setFrame:CGRectMake(0, MessageCellTopPadding, windowWidth, frame.size.height)];
}

- (void)layoutMessageBody
{}

- (void)layoutSubviews {
    [self updateLayout];
}

@end
