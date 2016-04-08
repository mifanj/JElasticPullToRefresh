//
//  UIView+JElasticPullToRefresh.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "UIView+JElasticPullToRefresh.h"

@implementation UIView (JElasticPullToRefresh)

- (CGPoint)jElasticPullToRefresh_centerUsePresentationLayerIfPossible:(BOOL)usePresentationLayerIfPossible {
    if (usePresentationLayerIfPossible && self.layer.presentationLayer) {
        CALayer *layer = (CALayer *)[self.layer presentationLayer];
        return layer.position;
    } else {
        return self.center;
    }
}

@end
