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
@class GGGridShape;
@class GGGridView;

@protocol GGGridViewDelegate <NSObject>

- (void)gridView:(GGGridView *)gridView didSelectShape:(GGGridShape *)shape;

@end

@interface GGGridView : UIView

@property (nonatomic, weak) id<GGGridViewDelegate> delegate;

- (GGSequence *)randomSequenceWithLength:(NSUInteger)length;
- (GGGridShape *)randomShapeWithLength:(NSUInteger)length;

- (void)playSequence:(GGSequence *)sequence;
- (void)playSequence:(GGSequence *)sequence completion:(void(^)())completion;
- (void)playSequence:(GGSequence *)sequence completion:(void(^)())completion interval:(NSTimeInterval)interval;

@end
