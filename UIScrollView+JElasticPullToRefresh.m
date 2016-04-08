//
//  UIScrollView+JElasticPullToRefresh.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "UIScrollView+JElasticPullToRefresh.h"
#import <objc/runtime.h>

static const void *ObserversKey = &ObserversKey;
static const void *JElasticPullToRefreshViewKey = &JElasticPullToRefreshViewKey;

@implementation UIScrollView (JElasticPullToRefresh)

@dynamic observers;
@dynamic jElasticPullToRefreshView;

- (NSMutableSet *)observers {
    return objc_getAssociatedObject(self, ObserversKey);
}

- (void)setObservers:(NSMutableSet *)observers {
    objc_setAssociatedObject(self, ObserversKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JElasticPullToRefreshView *)jElasticPullToRefreshView {
    return objc_getAssociatedObject(self, JElasticPullToRefreshViewKey);
}

- (void)setJElasticPullToRefreshView:(JElasticPullToRefreshView *)jElasticPullToRefreshView {
    objc_setAssociatedObject(self, JElasticPullToRefreshViewKey, jElasticPullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    NSString *observerID = [NSString stringWithFormat:@"%lu%@", (unsigned long)observer.hash, keyPath];
    if (!self.observers) {
        self.observers = [NSMutableSet set];
    }
    [self.observers addObject:observerID];

    [super addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSString *observerID = [NSString stringWithFormat:@"%lu%@", (unsigned long)observer.hash, keyPath];
    if (self.observers && [self.observers containsObject:observerID]) {
        [self.observers removeObject:observerID];
        [super removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)addJElasticPullToRefreshViewWithActionHandler:(JElasticPullToRefreshActionHandler) actionHandler LoadingView:(JElasticPullToRefreshLoadingView *)loadingView {
    self.multipleTouchEnabled = NO;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;

    JElasticPullToRefreshView *jElasticPullToRefreshView = [[JElasticPullToRefreshView alloc] init];
    self.jElasticPullToRefreshView = jElasticPullToRefreshView;
    jElasticPullToRefreshView.actionHandler = actionHandler;
    jElasticPullToRefreshView.loadingView = loadingView;

    [self addSubview:jElasticPullToRefreshView];

    jElasticPullToRefreshView.observing = YES;
}

- (void)removeJElasticPullToRefreshView {
    if (self.jElasticPullToRefreshView) {
        [self.jElasticPullToRefreshView disassociateDisplayLink];
        self.jElasticPullToRefreshView.observing = NO;
        [self.jElasticPullToRefreshView removeFromSuperview];
    }
}

- (void)setJElasticPullToRefreshBackgroundColor:(UIColor *)color {
    if (self.jElasticPullToRefreshView) {
        self.jElasticPullToRefreshView.backgroundColor = color;
    }
}

- (void)setJElasticPullToRefreshFillColor:(UIColor *)color {
    if (self.jElasticPullToRefreshView) {
        self.jElasticPullToRefreshView.fillColor = color;
    }
}

- (void)stopLoading {
    if (self.jElasticPullToRefreshView) {
        [self.jElasticPullToRefreshView stopLoading];
    }
}

@end
