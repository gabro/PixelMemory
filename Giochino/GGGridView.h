//
//  GGGrid.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGButton;
@class GGSequence;

@protocol GGGridViewDelegate <NSObject>

- (void)didPressButton:(GGButton *)button;

@end

@interface GGGridView : UIView

@property (nonatomic, weak) id<GGGridViewDelegate> delegate;

- (GGButton *)randomButton;
- (GGSequence *)randomSequenceWithLength:(NSUInteger)length;
- (GGButton *)buttonAtLocation:(CGPoint)point;


- (void)playSequence:(GGSequence *)sequence;
- (void)playSequence:(GGSequence *)sequence completion:(void(^)())completion;
- (void)playSequence:(GGSequence *)sequence completion:(void(^)())completion interval:(NSTimeInterval)interval;

@end
