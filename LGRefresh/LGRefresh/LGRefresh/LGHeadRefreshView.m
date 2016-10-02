//
//  LGHeadRefreshView.m
//  LGRefresh
//
//  Created by 李堪阶 on 2016/10/2.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "LGHeadRefreshView.h"

typedef enum {
    
    LGHeadRefreshViewStatusNormal,
    LGHeadRefreshViewStatusPulling,
    LGHeadRefreshViewStatusRefreshing
    
}LGHeadRefreshViewStatus;

@interface LGHeadRefreshView ()

@property (assign,nonatomic) LGHeadRefreshViewStatus currentStatus;

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) UILabel *statusLabel;

@property (strong,nonatomic) UILabel *timeLabel;

@property (strong ,nonatomic) UIActivityIndicatorView *aiView;

@property (strong,nonatomic) UIScrollView *superScrollView;

@end

@implementation LGHeadRefreshView



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.imageView];
        [self addSubview:self.statusLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.aiView];
        
        self.imageView.frame = CGRectMake(130, 5, 50, 50);
        self.statusLabel.frame = CGRectMake(190, 15, 200, 20);
        self.timeLabel.frame = CGRectMake(190, 35, 200, 20);
        self.aiView.frame = CGRectMake(130, 5, 50, 50);
        
        self.aiView.hidden = YES;
    }
    
    return self;
}
- (void)dealloc{
    
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        
        self.superScrollView = (UIScrollView *)newSuperview;
        
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    

    if ([self.superScrollView isDragging]) {//手拖动时
        
        CGFloat normalPullingOffset = -124;
        
        if (self.currentStatus == LGHeadRefreshViewStatusPulling && self.superScrollView.contentOffset.y > normalPullingOffset) {
            
            NSLog(@"切换到normal");
            self.currentStatus = LGHeadRefreshViewStatusNormal;
            
        }else if(self.currentStatus == LGHeadRefreshViewStatusNormal && self.superScrollView.contentOffset.y <= normalPullingOffset){
            NSLog(@"切换到pulling");
            self.currentStatus = LGHeadRefreshViewStatusPulling;
        }
    }else{//手放开
        
        if (self.currentStatus == LGHeadRefreshViewStatusPulling) {
            NSLog(@"切换到Refreshing");
            self.currentStatus = LGHeadRefreshViewStatusRefreshing;
        }
    }
}

- (void)setCurrentStatus:(LGHeadRefreshViewStatus)currentStatus{
    
    _currentStatus = currentStatus;
    
    if (_currentStatus == LGHeadRefreshViewStatusNormal) {
        
        self.statusLabel.text = @"下拉刷新";
        [self.aiView stopAnimating];
        self.aiView.hidden = YES;
        self.imageView.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, (M_PI+0.01));
        }];
        
        
        
    }else if (_currentStatus == LGHeadRefreshViewStatusPulling){
        self.statusLabel.text = @"释放刷新";
        
        [UIView animateWithDuration:0.2 animations:^{
             self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, (M_PI-0.01));
        }];
        
    }else{
        
        self.statusLabel.text = @"正在刷新";
        self.imageView.hidden = YES;
        self.aiView.hidden = NO;
        [self.aiView startAnimating];
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top+60, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];
        
        if (_headrRefrshBlock) {
            self.headrRefrshBlock();
        }
    }

}

- (void)endRefrsh{
    
    if (self.currentStatus == LGHeadRefreshViewStatusRefreshing) {
        
        self.currentStatus = LGHeadRefreshViewStatusNormal;

        [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top-60, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];
        
        self.timeLabel.text = [self getTime:[NSDate date]];
    }
}

- (NSString *)getTime:(NSDate *)date{
    
    NSDateFormatter *dfm = [[NSDateFormatter alloc]init];
    
    dfm.dateFormat = @"HH:mm";
    
    NSString *dateStr = [NSString stringWithFormat:@"最新纪录：%@",[dfm stringFromDate:date]];
    
    return dateStr;
}

#pragma mark - 懒加载

- (UIImageView *)imageView{
    
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pull_refresh"]];
    }
    return _imageView;
}

- (UILabel *)statusLabel{
    
    if (_statusLabel == nil) {
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.text = @"下拉刷新";
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = [UIColor darkGrayColor];
    }
    return _statusLabel;
}

- (UILabel *)timeLabel{

    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"最后更新：暂无纪录";
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor darkGrayColor];
    }
    
    return _timeLabel;
}

- (UIActivityIndicatorView *)aiView{
    
    if (_aiView == nil) {
        
        _aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _aiView;
}

@end
