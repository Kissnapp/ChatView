//
//  ChatViewController.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCellTemplate.h"
#import "ChatCellMessage.h"
#import "SDWebImageManager.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, ChatTableViewCellDelegate>
{
    UITableView * _tableView;
    __strong NSMutableArray * _messages;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushMessages:(NSArray*)messages
{
    [self ensureViewLoaded];
    [_messages addObjectsFromArray:messages];
}

#pragma mark -
#pragma mark - init the UI Methods

- (void)initData {
    _messages = [NSMutableArray array];
}

-(void)initParameters {
    CGRect frame = self.view.frame;
    self.title = @"ChatView Demo";
    _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
     if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
//        _tableView.contentInset = UIEdgeInsetsMake(44 + 20, 0, 0, 0);
        [_tableView setFrame:CGRectMake(0, 64, frame.size.width, frame.size.height - 64)];
    }

    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark -
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"Count: %d", _messages.count);
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCellMessage * cm = _messages[indexPath.row];
    ChatTableViewCellTemplate * cell = [cm dequeAndCreateCellFromTableView:tableView];
    cell.chatCellDelegate = self;
//    cell.message = cm;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCellMessage * msg = (ChatCellMessage*)_messages[indexPath.row];
    if (msg.direction == MessageFromOppsite) {
        msg.messageFrom = @"YoYo";
        msg.showMessageFrom = YES;
        msg.showAvatar = YES;
    }
    else {
        msg.messageFrom = @"Jack Lee";
        msg.showMessageFrom = YES;
        msg.showAvatar = YES;
    }
    return msg.calculatedCellSize.height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    CGFloat width = CGRectGetWidth(tableView.bounds) * (2.f/3.f);
//    return UITableViewAutomaticDimension;
//}

- (void) ensureViewLoaded {
    self.view.backgroundColor = self.view.backgroundColor;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_messages.count > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark -
#pragma mark - ChatTableViewCellDelegate
- (void)didAvatarTapedWithCell:(ChatTableViewCellTemplate*)messageCell; {
    NSLog(@"didAvatarTapedWithCell:%@", messageCell.message.messageOwner);
}

- (void)didHoldAndPressOnMessage:(ChatTableViewCellTemplate*)message; {
    NSLog(@"didHoldAndPressOnMessage");
}

@end
