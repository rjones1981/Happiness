//
//  HappinessViewController.m
//  Happiness
//
//  Created by Rabun Jones on 11/27/12.
//  Copyright (c) 2012 edu.standford.cs193p.rjones. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

/* add FaceViewDataSource here because this is private api */
@interface HappinessViewController () <FaceViewDataSource>
@property (nonatomic,weak) IBOutlet FaceView * faceView;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

- (void)setHappiness:(int)happiness {
    _happiness = happiness;
    [self.faceView setNeedsDisplay]; //Never call drawRect directly simply setNeedsDisplay
}

/* when the system sets this view add a gesture recognizer with the target being the faceView and the action being the pinch method */
- (void)setFaceView:(FaceView *)faceView {
    _faceView = faceView;
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    self.faceView.dataSource = self;
}

- (void)handleHappinessGesture:(UIPanGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}

- (float)smileForFaceView:(FaceView *)sender {
    return (self.happiness - 50) / 50.0;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
