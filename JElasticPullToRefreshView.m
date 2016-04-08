//
//  JElasticPullToRefreshView.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "JElasticPullToRefreshView.h"
#import "JElasticPullToRefreshConstants.h"
#import "UIView+JElasticPullToRefresh.h"

typedef enum {
    JElasticPullToRefreshStateStopped = 0,
    JElasticPullToRefreshStateDragging,
    JElasticPullToRefreshStateAnimatingBounce,
    JElasticPullToRefreshStateLoading,
    JElasticPullToRefreshStateAnimatingToStopped
} JElasticPullToRefreshState;

@interface JElasticPullToRefreshView ()

@property (assign, nonatomic) BOOL stateChanged;
@property (assign, nonatomic) JElasticPullToRefreshState refreshState;

@property (assign, nonatomic) CGFloat originalContentInsetTop;

@property (strong, nonatomic) UIView *bounceAnimationHelperView;

@property (strong, nonatomic) UIView *cControlPointView;
@property (strong, nonatomic) UIView *l1ControlPointView;
@property (strong, nonatomic) UIView *l2ControlPointView;
@property (strong, nonatomic) UIView *l3ControlPointView;
@property (strong, nonatomic) UIView *r1ControlPointView;
@property (strong, nonatomic) UIView *r2ControlPointView;
@property (strong, nonatomic) UIView *r3ControlPointView;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation JElasticPullToRefreshView

@synthesize refreshState = _refreshState;
@synthesize fillColor = _fillColor;

@synthesize bounceAnimationHelperView = _bounceAnimationHelperView;

@synthesize cControlPointView = _cControlPointView;
@synthesize l1ControlPointView = _l1ControlPointView;
@synthesize l2ControlPointView = _l2ControlPointView;
@synthesize l3ControlPointView = _l3ControlPointView;
@synthesize r1ControlPointView = _r1ControlPointView;
@synthesize r2ControlPointView = _r2ControlPointView;
@synthesize r3ControlPointView = _r3ControlPointView;

@synthesize loadingView = _loadingView;

- (JElasticPullToRefreshState)refreshState {
    if (self.stateChanged) {
        return _refreshState;
    } else {
        return JElasticPullToRefreshStateStopped;
    }
}

- (void)setRefreshState:(JElasticPullToRefreshState)refreshState {
    JElasticPullToRefreshState previousValue = self.refreshState;
    _refreshState = refreshState;
    self.stateChanged = YES;

    if (previousValue == JElasticPullToRefreshStateDragging && refreshState == JElasticPullToRefreshStateAnimatingBounce) {
        [self.loadingView startAnimating];
        [self animateBounce];
    } else if (refreshState == JElasticPullToRefreshStateLoading && self.actionHandler) {
        self.actionHandler();
    } else if (refreshState == JElasticPullToRefreshStateAnimatingToStopped) {
        __weak __typeof(self)weakSelf = self;
        [self resetScrollViewContentInsetShouldAddObserverWhenFinished:YES Animated:YES CompletionBlock:^{
            weakSelf.refreshState = JElasticPullToRefreshStateStopped;
        }];
    } else if (refreshState == JElasticPullToRefreshStateStopped) {
        [self.loadingView stopLoading];
    }
}

- (void)setObserving:(BOOL)observing {
    _observing = observing;

    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return;
    } else {
        if (observing) {
            [scrollView addObserver:self forKeyPath:JElasticPullToRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
            [scrollView addObserver:self forKeyPath:JElasticPullToRefreshContentInset options:NSKeyValueObservingOptionNew context:nil];
            [scrollView addObserver:self forKeyPath:JElasticPullToRefreshFrame options:NSKeyValueObservingOptionNew context:nil];
            [scrollView addObserver:self forKeyPath:JElasticPullToRefreshPanGestureRecognizerState options:NSKeyValueObservingOptionNew context:nil];
        } else {
            [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshContentOffset];
            [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshContentInset];
            [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshFrame];
            [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshPanGestureRecognizerState];
        }
    }
}

- (UIColor *)fillColor {
    if (!_fillColor) {
        _fillColor = [UIColor clearColor];
    }
    return _fillColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;

    self.shapeLayer.fillColor = [fillColor CGColor];
}

- (void)setOriginalContentInsetTop:(CGFloat)originalContentInsetTop {
    _originalContentInsetTop = originalContentInsetTop;

    [self layoutSubviews];
}

- (UIView *)bounceAnimationHelperView {
    if (!_bounceAnimationHelperView) {
        _bounceAnimationHelperView = [[UIView alloc] init];
    }
    return _bounceAnimationHelperView;
}

- (UIView *)cControlPointView {
    if (!_cControlPointView) {
        _cControlPointView = [[UIView alloc] init];
    }
    return _cControlPointView;
}

- (UIView *)l1ControlPointView {
    if (!_l1ControlPointView) {
        _l1ControlPointView = [[UIView alloc] init];
    }
    return _l1ControlPointView;
}

- (UIView *)l2ControlPointView {
    if (!_l2ControlPointView) {
        _l2ControlPointView = [[UIView alloc] init];
    }
    return _l2ControlPointView;
}

- (UIView *)l3ControlPointView {
    if (!_l3ControlPointView) {
        _l3ControlPointView = [[UIView alloc] init];
    }
    return _l3ControlPointView;
}

- (UIView *)r1ControlPointView {
    if (!_r1ControlPointView) {
        _r1ControlPointView = [[UIView alloc] init];
    }
    return _r1ControlPointView;
}

- (UIView *)r2ControlPointView {
    if (!_r2ControlPointView) {
        _r2ControlPointView = [[UIView alloc] init];
    }
    return _r2ControlPointView;
}

- (UIView *)r3ControlPointView {
    if (!_r3ControlPointView) {
        _r3ControlPointView = [[UIView alloc] init];
    }
    return _r3ControlPointView;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (JElasticPullToRefreshLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JElasticPullToRefreshLoadingView alloc] init];
    }
    return _loadingView;
}

- (void)setLoadingView:(JElasticPullToRefreshLoadingView *)loadingView {
    [self.loadingView removeFromSuperview];
    if (loadingView) {
        [self addSubview:loadingView];
    }
    _loadingView = loadingView;
}

- (void)animateBounce {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return;
    } else {
        [self resetScrollViewContentInsetShouldAddObserverWhenFinished:NO Animated:NO CompletionBlock:nil];

        CGFloat centerY = JElasticPullToRefreshLoadingContentInset;
        NSTimeInterval duration = 0.9;

        scrollView.scrollEnabled = NO;
        [self startDisplayLink];
        [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshContentOffset context:nil];
        [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshContentInset context:nil];

        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.43 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.cControlPointView.center = CGPointMake(weakSelf.cControlPointView.center.x, centerY);
            weakSelf.l1ControlPointView.center = CGPointMake(weakSelf.l1ControlPointView.center.x, centerY);
            weakSelf.l2ControlPointView.center = CGPointMake(weakSelf.l2ControlPointView.center.x, centerY);
            weakSelf.l3ControlPointView.center = CGPointMake(weakSelf.l3ControlPointView.center.x, centerY);
            weakSelf.r1ControlPointView.center = CGPointMake(weakSelf.r1ControlPointView.center.x, centerY);
            weakSelf.r2ControlPointView.center = CGPointMake(weakSelf.r2ControlPointView.center.x, centerY);
            weakSelf.r3ControlPointView.center = CGPointMake(weakSelf.r3ControlPointView.center.x, centerY);
        } completion:^(BOOL finished) {
            [weakSelf stopDisplayLink];
            [weakSelf resetScrollViewContentInsetShouldAddObserverWhenFinished:YES Animated:NO CompletionBlock:nil];
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            UIScrollView *scrollView = [strongSelf scrollView];
            if (strongSelf && scrollView) {
                [scrollView addObserver:strongSelf forKeyPath:JElasticPullToRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
                scrollView.scrollEnabled = YES;
            }
            weakSelf.refreshState = JElasticPullToRefreshStateLoading;
        }];

        self.bounceAnimationHelperView.center = CGPointMake(0, self.originalContentInsetTop + [self currentHeight]);
        [UIView animateWithDuration:duration * 0.4 animations:^{
            CGFloat contentInsetTop = weakSelf.originalContentInsetTop;
            weakSelf.bounceAnimationHelperView.center = CGPointMake(0, contentInsetTop + JElasticPullToRefreshLoadingContentInset);
        }];
    }
}

- (void)applicationWillEnterForeground {
    if (self.refreshState == JElasticPullToRefreshStateLoading) {
        [self layoutSubviews];
    }
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.superview;
}

- (void)stopLoading {
    if (self.refreshState == JElasticPullToRefreshStateAnimatingToStopped) {
        return;
    }
    self.refreshState = JElasticPullToRefreshStateAnimatingToStopped;
}

- (BOOL)isAnimating {
    if (self.refreshState == JElasticPullToRefreshStateAnimatingBounce || self.refreshState == JElasticPullToRefreshStateAnimatingToStopped) {
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat)actualContentOffsetY {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return 0;
    } else {
        return MAX(-scrollView.contentInset.top - scrollView.contentOffset.y, 0);
    }
}

- (CGFloat)currentHeight {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return 0;
    } else {
        return MAX(-self.originalContentInsetTop - scrollView.contentOffset.y, 0);
    }
}

- (CGFloat)currentWaveHeight {
    return MIN(self.bounds.size.height / 3.0 * 1.6, JElasticPullToRefreshWaveMaxHeight);
}

- (CGPathRef)currentPath {
    CGFloat width = [self scrollView].bounds.size.width;

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    BOOL animating = [self isAnimating];

    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0, [self.l3ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating].y)];
    [bezierPath addCurveToPoint:[self.l1ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint1:[self.l3ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint2:[self.l2ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating]];
    [bezierPath addCurveToPoint:[self.r1ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint1:[self.cControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint2:[self.r1ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating]];
    [bezierPath addCurveToPoint:[self.r3ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint1:[self.r1ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating] controlPoint2:[self.r2ControlPointView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:animating]];
    [bezierPath addLineToPoint:CGPointMake(width, 0)];

    [bezierPath closePath];

    return bezierPath.CGPath;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;

        self.shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
        self.shapeLayer.fillColor = [[UIColor blackColor] CGColor];
        self.shapeLayer.actions = @{@"path" : [NSNull null], @"position" : [NSNull null], @"bounds" : [NSNull null]};
        [self.layer addSublayer:self.shapeLayer];

        [self addSubview:self.bounceAnimationHelperView];
        [self addSubview:self.cControlPointView];
        [self addSubview:self.l1ControlPointView];
        [self addSubview:self.l2ControlPointView];
        [self addSubview:self.l3ControlPointView];
        [self addSubview:self.r1ControlPointView];
        [self addSubview:self.r2ControlPointView];
        [self addSubview:self.r3ControlPointView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (keyPath == JElasticPullToRefreshContentOffset) {
        CGFloat newContentOffsetY = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        UIScrollView *scrollView = [self scrollView];
        if (scrollView) {
            if ((self.refreshState == JElasticPullToRefreshStateLoading || self.refreshState == JElasticPullToRefreshStateAnimatingToStopped) && (newContentOffsetY < -scrollView.contentInset.top)) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);
            } else {
                [self scrollViewDidChangeContentOffsetDragging:scrollView.dragging];
            }
            [self layoutSubviews];
        }
    } else if (keyPath == JElasticPullToRefreshContentInset) {
        CGFloat newContentInsetTop = [[change objectForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue].top;
        self.originalContentInsetTop = newContentInsetTop;
    } else if (keyPath == JElasticPullToRefreshFrame) {
        [self layoutSubviews];
    } else if (keyPath == JElasticPullToRefreshPanGestureRecognizerState) {
        UIGestureRecognizerState gestureState = [self scrollView].panGestureRecognizer.state;
        if (gestureState == UIGestureRecognizerStateEnded || gestureState == UIGestureRecognizerStateCancelled || gestureState == UIGestureRecognizerStateFailed) {
            [self scrollViewDidChangeContentOffsetDragging:NO];
        }
    }
}

- (void)scrollViewDidChangeContentOffsetDragging:(BOOL)dragging {
    CGFloat offsetY = [self actualContentOffsetY];

    if (self.refreshState == JElasticPullToRefreshStateStopped && dragging) {
        self.refreshState = JElasticPullToRefreshStateDragging;
    } else if (self.refreshState == JElasticPullToRefreshStateDragging && !dragging) {
        if (offsetY >= JElasticPullToRefreshMinOffsetToPull) {
            self.refreshState = JElasticPullToRefreshStateAnimatingBounce;
        } else {
            self.refreshState = JElasticPullToRefreshStateStopped;
        }
    } else if (self.refreshState == JElasticPullToRefreshStateDragging || self.refreshState == JElasticPullToRefreshStateStopped) {
        CGFloat pullProgress = offsetY / JElasticPullToRefreshMinOffsetToPull;
        [self.loadingView setPullProgress:pullProgress];
    }
}

- (void)resetScrollViewContentInsetShouldAddObserverWhenFinished:(BOOL)shouldAddObserverWhenFinished Animated:(BOOL)animated CompletionBlock:(JElasticPullToRefreshCompletionBlock)endingBlock {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return;
    } else {
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.top = self.originalContentInsetTop;
        if (self.refreshState == JElasticPullToRefreshStateAnimatingBounce) {
            contentInset.top += [self currentHeight];
        } else if (self.refreshState == JElasticPullToRefreshStateLoading) {
            contentInset.top += JElasticPullToRefreshLoadingContentInset;
        }
        [scrollView removeObserver:self forKeyPath:JElasticPullToRefreshContentInset];

        void(^animationBlock)(void) = ^(void) {
            scrollView.contentInset = contentInset;
        };
        void(^completionBlock)(void) = ^(void) {
            if (shouldAddObserverWhenFinished && self.observing) {
                [scrollView addObserver:self forKeyPath:JElasticPullToRefreshContentInset options:NSKeyValueObservingOptionNew context:nil];
            }
            if (endingBlock) {
                endingBlock();
            }
        };

        if (animated) {
            [self startDisplayLink];
            [UIView animateWithDuration:0.35 animations:animationBlock completion:^(BOOL finished) {
                [self stopDisplayLink];
                completionBlock();
            }];
        } else {
            animationBlock();
            completionBlock();
        }
    }
}

- (void)startDisplayLink {
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
}

- (void)displayLinkTick {
    CGFloat width = self.bounds.size.width;
    CGFloat height = 0;

    if (self.refreshState == JElasticPullToRefreshStateAnimatingBounce) {
        UIScrollView *scrollView = [self scrollView];
        if (!scrollView) {
            return;
        } else {
            scrollView.contentInset = UIEdgeInsetsMake([self.bounceAnimationHelperView jElasticPullToRefresh_centerUsePresentationLayerIfPossible:[self isAnimating]].y, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);

            height = scrollView.contentInset.top - self.originalContentInsetTop;

            self.frame = CGRectMake(0, -height - 1.0, width, height);
        }
    } else if (self.refreshState == JElasticPullToRefreshStateAnimatingToStopped) {
        height = [self actualContentOffsetY];
    }

    self.shapeLayer.frame = CGRectMake(0, 0, width, height);
    self.shapeLayer.path = [self currentPath];

    [self layoutLoadingView];
}

- (void)layoutLoadingView {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGFloat loadingViewSize = JElasticPullToRefreshLoadingViewSize;
    CGFloat minOriginY = (JElasticPullToRefreshLoadingContentInset - loadingViewSize) / 2.0;
    CGFloat originY = MAX(MIN((height - loadingViewSize) / 2.0, minOriginY), 0);

    self.loadingView.frame = CGRectMake((width - loadingViewSize) / 2.0, originY, loadingViewSize, loadingViewSize);
    self.loadingView.maskLayer.frame = [self convertRect:self.shapeLayer.frame toView:self.loadingView];
    self.loadingView.maskLayer.path = self.shapeLayer.path;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIScrollView *scrollView = [self scrollView];
    if (scrollView && self.refreshState != JElasticPullToRefreshStateAnimatingBounce) {
        CGFloat width = scrollView.bounds.size.width;
        CGFloat height = [self currentHeight];

        self.frame = CGRectMake(0, -height, width, height);

        if (self.refreshState == JElasticPullToRefreshStateLoading || self.refreshState == JElasticPullToRefreshStateAnimatingToStopped) {
            self.cControlPointView.center = CGPointMake(width / 2.0, height);
            self.l1ControlPointView.center = CGPointMake(0, height);
            self.l2ControlPointView.center = CGPointMake(0, height);
            self.l3ControlPointView.center = CGPointMake(0, height);
            self.r1ControlPointView.center = CGPointMake(width, height);
            self.r2ControlPointView.center = CGPointMake(width, height);
            self.r3ControlPointView.center = CGPointMake(width, height);
        } else {
            CGFloat locationX = [scrollView.panGestureRecognizer locationInView:scrollView].x;

            CGFloat waveHeight = [self currentWaveHeight];
            CGFloat baseHeight = self.bounds.size.height - waveHeight;

            CGFloat minLeftX = MIN((locationX - width / 2.0) * 0.28, 0);
            CGFloat maxRightX = MAX(width + (locationX - width / 2.0) * 0.28, width);

            CGFloat leftPartWidth = locationX - minLeftX;
            CGFloat rightPartWidth = maxRightX - locationX;

            self.cControlPointView.center = CGPointMake(locationX, baseHeight + waveHeight * 1.36);
            self.l1ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.71, baseHeight + waveHeight * 0.64);
            self.l2ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.44, baseHeight);
            self.l3ControlPointView.center = CGPointMake(minLeftX, baseHeight);
            self.r1ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.71, baseHeight + waveHeight * 0.64);
            self.r2ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.44, baseHeight);
            self.r3ControlPointView.center = CGPointMake(maxRightX, baseHeight);
        }

        self.shapeLayer.frame = CGRectMake(0, 0, width, height);
        self.shapeLayer.path = [self currentPath];

        [self layoutLoadingView];
    }
}

- (void)disassociateDisplayLink {
    [self.displayLink invalidate];
}

- (void)dealloc {
    self.observing = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






























@end
