//
//  UIScrollView+JElasticPullToRefresh.h
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JElasticPullToRefreshView.h"

@interface UIScrollView (JElasticPullToRefresh)

@property (strong, nonatomic) NSMutableSet *observers;

@property (strong, nonatomic) JElasticPullToRefreshView *jElasticPullToRefreshView;

- (void)addJElasticPullToRefreshViewWithActionHandler:(JElasticPullToRefreshActionHandler) actionHandler LoadingView:(JElasticPullToRefreshLoadingView *)loadingView;

- (void)removeJElasticPullToRefreshView;

- (void)setJElasticPullToRefreshBackgroundColor:(UIColor *)color;

- (void)setJElasticPullToRefreshFillColor:(UIColor *)color;

- (void)stopLoading;

@end
