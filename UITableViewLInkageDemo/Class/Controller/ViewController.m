//
//  ViewController.m
//  UITableViewLInkageDemo
//
//  Created by Eleven on 2017/7/3.
//  Copyright © 2017年 Hawk. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "ConfigurationView.h"
#import "CompareDetailView.h"
#import "CarModel.h"
#import "YYModel.h"

@interface ViewController () <EScrollDelegate>

@property (nonatomic, strong) ConfigurationView *configurationView;
@property (nonatomic, strong) CompareDetailView *compareDetailView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSArray *sourceArr;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"参数对比";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.compareDetailView];
    [self.view addSubview:self.configurationView];
    
    [self loadData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEvent) name:@"addNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEvent:) name:@"deleteNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteNotification" object:nil];
}

- (void)loadData {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"comparedata" ofType:@"json"]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    self.dataArr = [NSArray yy_modelArrayWithClass:[CarModel class] json:dict[@"data"]].mutableCopy;
    
    self.sourceArr = [self.dataArr copy];
    
    // 加一组空数据
    CarModel *model = [[CarModel alloc] init];
    [self.dataArr addObject:model];
    
    [self.configurationView setDatas:self.dataArr];
    [self.compareDetailView setDatas:self.dataArr];
}

#pragma mark - notification
#pragma mark - 模拟添加与删除数据
- (void)addEvent {
    CarModel *model = self.sourceArr[arc4random() % self.sourceArr.count];
    [self.dataArr insertObject:model atIndex:self.dataArr.count - 1];
    [self.configurationView setDatas:self.dataArr];
    [self.compareDetailView setDatas:self.dataArr];
}

- (void)deleteEvent:(NSNotification *)notificaiton {
    NSInteger index = [notificaiton.userInfo[@"index"] integerValue];
    [self.dataArr removeObjectAtIndex:index];
    [self.configurationView setDatas:self.dataArr];
    [self.compareDetailView setDatas:self.dataArr];
}

#pragma mark - EScrollDelegate
#pragma mark - tableveiw联动设置
- (void)e_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.configurationView.tableView) {
        self.compareDetailView.tableView.contentOffset = scrollView.contentOffset;
    } else {
        self.configurationView.tableView.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - getter
- (ConfigurationView *)configurationView {
    if (!_configurationView) {
        _configurationView = [[ConfigurationView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
        _configurationView.delegate = self;
    }
    return _configurationView;
}

- (CompareDetailView *)compareDetailView {
    if (!_compareDetailView) {
        _compareDetailView = [[CompareDetailView alloc] initWithFrame:CGRectMake(ITEM_WIDTH, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH - ITEM_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
        _compareDetailView.delegate = self;
    }
    return _compareDetailView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
