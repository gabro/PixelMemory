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

@protocol GGGridDelegate <NSObject>

- (void)didPressButton:(GGButton *)button;

@end

@interface GGGrid : UIView

@property (nonatomic, weak) id<GGGridDelegate> delegate;

- (GGButton *)randomButton;
- (GGSequence *)randomSequenceWithLength:(NSUInteger)length;
- (GGButton *)buttonAtLocation:(CGPoint)point;

@end
