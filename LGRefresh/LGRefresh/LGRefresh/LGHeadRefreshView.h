//
//  LGHeadRefreshView.h
//  LGRefresh
//
//  Created by 李堪阶 on 2016/10/2.
//  Copyright © 2016年 DM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LGHeadRefrshBlock)();

@interface LGHeadRefreshView : UIView

@property (copy ,nonatomic) LGHeadRefrshBlock headrRefrshBlock;

- (void)endRefrsh;

@end
