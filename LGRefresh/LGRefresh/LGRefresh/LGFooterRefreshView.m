//
//  LGFooterRefreshView.m
//  LGRefresh
//
//  Created by 李堪阶 on 2016/10/2.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "LGFooterRefreshView.h"

typedef enum {
    
    LGFooterRefrshViewStatusNormal,
    LGFooterRefrshViewStatusPulling,
    LGFooterRefrshViewStatusRefrshing
}LGFooterRefrshViewStatus;

@interface LGFooterRefreshView ()

@property (strong ,nonatomic) UIScrollView *superScrollView;

@property (assign ,nonatomic) LGFooterRefrshViewStatus currentStatus;

@property (strong ,nonatomic) UILabel *statusLabel;

@property (strong ,nonatomic) UIActivityIndicatorView *aiView;

@end

@implementation LGFooterRefreshView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self addSubview:self.statusLabel];
        [self addSubview:self.aiView];
        
        self.aiView.frame = CGRectMake(100, 5, 50, 50);
        self.statusLabel.frame = CGRectMake(160, 20, 200, 20);
        
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
    
    if (self.superScrollView.isDragging) { //手拖动
        
        CGFloat normalpullingOffset = 0;
        
        if (self.currentStatus == LGFooterRefrshViewStatusPulling && self.superScrollView.contentOffset.y < normalpullingOffset) {
            NSLog(@"切换nomal");
            self.currentStatus = LGFooterRefrshViewStatusNormal;
        }else if (self.currentStatus == LGFooterRefrshViewStatusNormal && self.superScrollView.contentOffset.y >= normalpullingOffset){
            
            NSLog(@"切换Pulling");
            self.currentStatus = LGFooterRefrshViewStatusPulling;
        }
        
    }else{//手放开
        if (self.currentStatus == LGFooterRefrshViewStatusPulling) {
            NSLog(@"切换Refrshing");
            self.currentStatus = LGFooterRefrshViewStatusRefrshing;
        }
    }
}

- (void)setCurrentStatus:(LGFooterRefrshViewStatus)currentStatus{
    
    _currentStatus = currentStatus;
    
    switch (_currentStatus) {
        case LGFooterRefrshViewStatusNormal:
            
            self.statusLabel.text = @"加载更多数据";
            [self.aiView stopAnimating];
            self.aiView.hidden = YES;
            
            break;
            
        case LGFooterRefrshViewStatusPulling:
           
            self.statusLabel.text = @"释放加载数据";
            
            break;
        case LGFooterRefrshViewStatusRefrshing:
          
            self.statusLabel.text = @"正在加载数据...";
            self.aiView.hidden = NO;
            [self.aiView startAnimating];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom+64, self.superScrollView.contentInset.right);
            }];
            
            
            if (_footerRefrshBlock) {
                self.footerRefrshBlock();
            }
            
            break;
    }
}

- (void)endRefrsh{
    
    if (self.currentStatus == LGFooterRefrshViewStatusRefrshing) {
        self.currentStatus = LGFooterRefrshViewStatusNormal;
        [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom-64, self.superScrollView.contentInset.right);
        }];
    }
}


#pragma mark - 懒加载

- (UILabel *)statusLabel{
    
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.text = @"加载更多数据";
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.font = [UIFont systemFontOfSize:15];
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)aiView{
    
    if (_aiView == nil) {
        
        _aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _aiView;
}

@end
