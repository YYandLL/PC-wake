//
//  NICSignatureViewQuartzQuadratic.m
//  SignatureDemo
//
//  Created by Jason Harwig on 11/6/12.
//  Copyright (c) 2012 Near Infinity Corporation.

#import "SignatureViewQuartzQuadratic.h"
#import <QuartzCore/QuartzCore.h>

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface SignatureViewQuartzQuadratic () {
    UIBezierPath *path;
    CGPoint previousPoint;
}
@end

@implementation SignatureViewQuartzQuadratic

- (void)commonInit {
    path = [UIBezierPath bezierPath];
    
    // Capture touches
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
    
    // Erase with long press
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(erase)]];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self commonInit];
    return self;
}

- (void)erase {
    path = [UIBezierPath bezierPath];
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    
    self.hasSignature = YES;
    
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
    
    if (self.block) {
        self.block();
    }
}

- (UIImage *)signatureImage {
    CGSize size = self.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image resizeToSize:CGSizeMake(TXBYApplicationW * 0.8, 450 * 0.8)];
    UIImage *newImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.8)];
    return newImage;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setStroke];
    
    path.lineWidth = 3;
    
    [path stroke];
}

@end
