//
//  GGGameBoard.h
//  Giochino
//
//  Created by Gabriele Petronella on 1/20/13.
//  Copyright (c) 2013 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGridView.h"

@interface GGGameBoard : UIView

@property (nonatomic, weak) id<GGGridViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame progressBar:(BOOL)progressBar;

- (void)updateScore:(NSInteger)score animated:(BOOL)animated;

- (void)updateProgress:(NSTimeInterval)progress;

@end
