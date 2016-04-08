//
//  JElasticPullToRefreshLoadingView.h
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JElasticPullToRefreshLoadingView : UIView

@property (strong, nonatomic) CAShapeLayer *maskLayer;

- (void)setPullProgress:(CGFloat)progress;

- (void)startAnimating;

- (void)stopLoading;

@end
