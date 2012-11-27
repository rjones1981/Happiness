//
//  FaceView.h
//  Happiness
//
//  Created by Rabun Jones on 11/27/12.
//  Copyright (c) 2012 edu.standford.cs193p.rjones. All rights reserved.
//

#import <UIKit/UIKit.h>

/* forward reference */
@class FaceView;

@protocol FaceViewDataSource
- (float)smileForFaceView:(FaceView *)sender;
@end

@interface FaceView : UIView

@property (nonatomic) CGFloat scale;

/* this allows someone to set themselves up as the DataSource delegate for this class */
@property (nonatomic,weak) IBOutlet id <FaceViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
