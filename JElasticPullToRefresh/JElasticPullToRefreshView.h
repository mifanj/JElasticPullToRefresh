//
//  JElasticPullToRefreshView.h
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JElasticPullToRefreshLoadingViewCircle.h"

typedef void (^JElasticPullToRefreshCompletionBlock)(void);
typedef void (^JElasticPullToRefreshActionHandler)(void);

@interface JElasticPullToRefreshView : UIView

@property (strong, nonatomic) JElasticPullToRefreshLoadingView *loadingView;

@property (strong, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) BOOL observing;
@property (copy, nonatomic) JElasticPullToRefreshActionHandler actionHandler;

- (void)disassociateDisplayLink;

- (void)stopLoading;

@end
