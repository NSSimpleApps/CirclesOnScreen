//
//  CustomView.m
//  CirclesOnScreen
//
//  Created by NSSimpleApps on 16.11.14.
//  Copyright (c) 2014 NSSimpleApps. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addPanGesture];
    }
    return self;
}

- (void)addPanGesture {
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)tapGestureRecognizer {
    
    CGPoint centerOfCircle = [tapGestureRecognizer locationInView:self];
    
    CAShapeLayer* circularLayer = [CAShapeLayer layer];
    circularLayer.strokeColor = [[UIColor blackColor] CGColor];
    circularLayer.lineWidth = 3.0;
    circularLayer.path = [self getCircularLinePathWithCenter:centerOfCircle radius:0];
    circularLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.layer addSublayer:circularLayer];
    
    [self expandCircularLayer:circularLayer center:centerOfCircle radius:[self maximumRadius:centerOfCircle]];
}

- (CGPathRef)getCircularLinePathWithCenter:(CGPoint)center radius:(CGFloat)radius {
    
    UIBezierPath *circularLine = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x - radius, center.y - radius,
                                                                                   2*radius, 2*radius)];
    return [circularLine CGPath];
}

- (CGFloat)maximumRadius:(CGPoint)touchLocation {
    
    CGSize sizeOfView = [self bounds].size;
    
    CGFloat width = sizeOfView.width;
    CGFloat height = sizeOfView.height;
    
    CGFloat x = touchLocation.x;
    CGFloat y = touchLocation.y;
    
    CGFloat R1 = hypotf(x, y);
    CGFloat R2 = hypotf(x - width, y);
    CGFloat R3 = hypotf(x, y - height);
    CGFloat R4 = hypotf(x - width, y - height);
    
    return MAX(MAX(R1, R2), MAX(R3, R4));
}

- (void)expandCircularLayer:(CAShapeLayer*)circularLayer center:(CGPoint)center radius:(CGFloat)radius {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    NSArray *values = @[(id)[self getCircularLinePathWithCenter:center radius:0],
                        (id)[self getCircularLinePathWithCenter:center radius:radius/4],
                        (id)[self getCircularLinePathWithCenter:center radius:radius/2],
                        (id)[self getCircularLinePathWithCenter:center radius:3*radius/4],
                        (id)[self getCircularLinePathWithCenter:center radius:radius]];
    
    animation.values = values;
    animation.duration = 0.6;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [circularLayer addAnimation:animation forKey:@"expanding"];
}

@end
