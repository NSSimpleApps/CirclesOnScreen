//
//  ViewController.m
//  CirclesOnScreen
//
//  Created by NSSimpleApps on 16.11.14.
//  Copyright (c) 2014 NSSimpleApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    CGPoint centerOfCircle = [sender locationInView:self.view];
    
    CAShapeLayer* circularLayer = [CAShapeLayer layer];
    circularLayer.strokeColor = [[UIColor blackColor] CGColor];
    circularLayer.lineWidth = 3.0;
    circularLayer.path = [self circularPathWithCenter:centerOfCircle radius:0];
    circularLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.view.layer addSublayer:circularLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.values = @[(id)[self circularPathWithCenter:centerOfCircle radius:0],
                         (id)[self circularPathWithCenter:centerOfCircle radius:[self maximumRadius:centerOfCircle]]];;
    animation.duration = 0.6;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    
    [circularLayer addAnimation:animation forKey:@"expanding"];
}

- (CGPathRef)circularPathWithCenter:(CGPoint)center radius:(CGFloat)radius {
    
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x - radius, center.y - radius,
                                                                                   2*radius, 2*radius)];
    return [circularPath CGPath];
}

- (CGFloat)maximumRadius:(CGPoint)touchLocation {
    
    CGSize sizeOfView = [self.view bounds].size;
    
    CGFloat width = sizeOfView.width, height = sizeOfView.height;
    
    CGFloat x = touchLocation.x, y = touchLocation.y;
    
    CGFloat R1 = hypotf(x, y);
    CGFloat R2 = hypotf(x - width, y);
    CGFloat R3 = hypotf(x, y - height);
    CGFloat R4 = hypotf(x - width, y - height);
    
    return MAX(MAX(R1, R2), MAX(R3, R4));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    CALayer *layer = [self.view.layer.sublayers lastObject];
    [layer removeFromSuperlayer];
}

@end
