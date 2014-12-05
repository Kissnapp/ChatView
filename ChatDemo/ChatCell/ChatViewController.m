//
//  ChatViewController.m
//  ChatDemo
//
//  Created by LIU CHONGLIANG on 2/12/14.
//  Copyright (c) 2014 LIU CHONGLIANG. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatCellTextMessage.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * _tableView;
    __strong NSMutableArray * _messages;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messages = [NSMutableArray array];
    
    self.title = @"ChatView Demo";
    _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
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
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"Count: %d", _messages.count);
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"chatViewCell";
    ChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ChatCellTextMessage * cm = _messages[indexPath.row];
    cell.message = cm;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCellTextMessage * msg = (ChatCellTextMessage*)_messages[indexPath.row];
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
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
