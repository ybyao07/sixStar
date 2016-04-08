//
//  BaseTableViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PureLayout.h"
@interface BaseTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSLayoutConstraint *_scrollHeight;
}
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableview -> 从Xib中加载
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]] && view.tag == 0) {
            self.tableView = (UITableView *)view;
            break;
        }
    }
    // xib 中未找到TableView 手动创建
    if (!self.tableView) {
        self.tableView = [UITableView newAutoLayoutView];
        [self.view addSubview:self.tableView];
//        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44];
    }
    
    // 设置TableView
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view bringSubviewToFront:self.navBar];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"BaseTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
