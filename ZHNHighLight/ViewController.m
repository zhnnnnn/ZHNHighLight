//
//  ViewController.m
//  ZHNHighLight
//
//  Created by 张辉男 on 17/8/12.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+ZHNHighLight.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.zhn_highLightColor = [UIColor redColor];
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"zhnnnnn");
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"zhnnnnn";
    return cell;
}

#pragma mark - getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
