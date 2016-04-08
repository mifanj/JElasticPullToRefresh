//
//  JElasticPullToRefreshLoadingViewCircle.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "JElasticPullToRefreshLoadingViewCircle.h"

static NSString *const RotationAnimation = @"RotationAnimation";

@interface JElasticPullToRefreshLoadingViewCircle ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) CATransform3D identityTransform;

@end

@implementation JElasticPullToRefreshLoadingViewCircle

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
    }
    return _shapeLayer;
}

- (CATransform3D)identityTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    _identityTransform = CATransform3DRotate(transform, (-90.0 * M_PI / 180.0), 0, 0, 1.0);

    return _identityTransform;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.shapeLayer.lineWidth = 1.0;
        self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        self.shapeLayer.strokeColor = [[self tintColor] CGColor];
        self.shapeLayer.actions = @{@"strokeEnd":[NSNull null], @"transform":[NSNull null]};
        self.shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.layer addSublayer:self.shapeLayer];
    }

    return self;
}

- (void)setPullProgress:(CGFloat)progress {
    [super setPullProgress:progress];

    self.shapeLayer.strokeEnd = MIN(0.9 * progress, 0.9);
    if (progress > 1.0) {
        CGFloat degress = ((progress - 1.0) * 200.0);
        self.shapeLayer.transform = CATransform3DRotate(self.identityTransform, (degress * M_PI / 180.0) , 0, 0, 1.0);
    } else {
        self.shapeLayer.transform = self.identityTransform;
    }
}

- (void)startAnimating {
    [super startAnimating];

    if ([self.shapeLayer animationForKey:RotationAnimation]) {
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(2.0 * M_PI + [[self.shapeLayer valueForKeyPath:@"transform.rotation.z"] doubleValue]);
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.shapeLayer addAnimation:rotationAnimation forKey:RotationAnimation];
}

- (void)stopLoading {
    [super stopLoading];

    [self.shapeLayer removeAnimationForKey:RotationAnimation];
}

- (CGFloat)currentDegree {
    CGFloat degree = [[self.shapeLayer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    return degree;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    self.shapeLayer.strokeColor = self.tintColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.shapeLayer.frame = self.bounds;

    CGFloat inset = self.shapeLayer.lineWidth / 2.0;
    self.shapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.shapeLayer.bounds, inset, inset)] CGPath];
}

@end
