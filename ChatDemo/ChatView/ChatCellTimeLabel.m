//
//  ChatCellTimeLabel.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 21/1/15.
//  Copyright (c) 2015 LIU CHONGLIANG. All rights reserved.
//

#import "ChatCellTimeLabel.h"
#import "ChatTimeCell.h"
#import "NSDate+TimeAgo.h"

@interface ChatCellTimeLabel()

@end

@implementation ChatCellTimeLabel

- (id)init {
    self = [super init];
    if (self) {
        [self applyDefaults];
    }
    return self;
}

- (id)initWithTimeString:(NSString*)time {
    self = [self init];
    if (self) {
        self.timeAgoStr = time;
    }
    return self;
}

- (CGSize)calculatedCellSize
{
    return _calulatedCellSize;
}

- (void)applyDefaults {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    _calulatedCellSize = CGSizeMake(screenWidth, 20);
}

- (ChatTableViewCellTemplate*)dequeAndCreateCellFromTableView:(UITableView*)tableView
{
    static NSString * cellIdentifier = @"chatViewTimestampCell";
    ChatTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = self;
    return cell;
}

@end
