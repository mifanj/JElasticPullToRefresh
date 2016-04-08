//
//  JElasticPullToRefreshLoadingView.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "JElasticPullToRefreshLoadingView.h"

@implementation JElasticPullToRefreshLoadingView

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
        _maskLayer.fillColor = [[UIColor blackColor] CGColor];
        _maskLayer.actions = @{@"path":[NSNull null], @"position":[NSNull null], @"bounds":[NSNull null]};
        self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

- (instancetype)init {
    return [super initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [super initWithFrame:CGRectZero];
}

- (void)setPullProgress:(CGFloat)progress {

}

- (void)startAnimating {

}

- (void)stopLoading {

}

@end
