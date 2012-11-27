//
//  FaceView.m
//  Happiness
//
//  Created by Rabun Jones on 11/27/12.
//  Copyright (c) 2012 edu.standford.cs193p.rjones. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25

- (CGFloat)scale {
    if(!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale {
    if(scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        /* set a stateless gesture scale by resetting the value */
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

/* allows recalling of drawRect on redraw */
- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

/* works with storyboard for redraw when rotate occurs */
//- (void)awakeFromNib {
//    [self setup];
//}

/* not called when it comes out of storyboard only works on alloc init with frame */
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
}

- (void)drawRect:(CGRect)rect {
    
    /* only valid in a drawRect method */
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    
    /* do not use center because that is the center of the superview not the subview (this view) */
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
    
    /* find the larger of width or height */
    CGFloat size = self.bounds.size.width / 2;
    if(self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale;
    
    /* set the line width and color */
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    /* draw the face */
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    /* draw the eyes */
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    //draw mouth
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    
    /* control points used for BES curve */
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    float smile = [self.dataSource smileForFaceView:self];
    if(smile < -1) smile = -1;
    if(smile > 1) smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}

@end
