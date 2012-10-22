//
//  GGGrid.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGButton;

@protocol GGGridDelegate <NSObject>

- (void)didPressButton:(GGButton *)button;

@end

@interface GGGrid : UIView

@property (nonatomic, weak) id<GGGridDelegate> delegate;

- (GGButton *)randomButton;
- (GGButton *)buttonAtLocation:(CGPoint)point;

@end
