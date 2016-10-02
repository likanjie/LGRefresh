//
//  LGFooterRefreshView.h
//  LGRefresh
//
//  Created by 李堪阶 on 2016/10/2.
//  Copyright © 2016年 DM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FooterRefrshBlock)();

@interface LGFooterRefreshView : UIView

@property (copy ,nonatomic) FooterRefrshBlock footerRefrshBlock;

- (void)endRefrsh;

@end
