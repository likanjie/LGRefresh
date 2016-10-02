//
//  ViewController.m
//  LGRefresh
//
//  Created by 李堪阶 on 2016/10/2.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "ViewController.h"
#import "LGHeadRefreshView.h"
#import "LGFooterRefreshView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *datas;

@end

@implementation ViewController


- (NSArray *)loadData{
    
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        
        int num = arc4random_uniform(1000);
        
        NSString *numStr = [NSString stringWithFormat:@"%d",num];
        
        [mArray addObject:numStr];
    }
    
    return mArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [self loadData];
    
    [self refreshHeadData];
    
    [self refreshFooterData];
}

///刷新头部数据
- (void)refreshHeadData{
    CGRect rect = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    
    LGHeadRefreshView *headRefreshView = [[LGHeadRefreshView alloc]initWithFrame:rect];
    headRefreshView.backgroundColor = [UIColor brownColor];
    
    [self.tableView addSubview:headRefreshView];
    
    __weak typeof(headRefreshView) weakRefreshView = headRefreshView;
    
    headRefreshView.headrRefrshBlock = ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSArray *newData = [self loadData];
            
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:newData];
            
            [mArray addObjectsFromArray:self.datas];
            
            self.datas = mArray;
            
            [self.tableView reloadData];
            
            [weakRefreshView endRefrsh];
        });
    };

}

///刷新尾部数据
- (void)refreshFooterData{
    
    LGFooterRefreshView *footerRefreshView =  [[LGFooterRefreshView alloc]init];
    footerRefreshView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableFooterView = footerRefreshView;
    
    __weak typeof(footerRefreshView) weakFooterRefreshView = footerRefreshView;
    
    footerRefreshView.footerRefrshBlock = ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSArray *newData = [self loadData];
            
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:newData];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.datas];
            
            [array addObjectsFromArray:mArray];
            
            self.datas = array;
            
            [self.tableView reloadData];
            
            [weakFooterRefreshView endRefrsh];
        });
    };

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell%@",self.datas[indexPath.row]];
    
    return cell;
}

@end
