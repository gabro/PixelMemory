//
//  GGButton.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGTile : UIView

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, assign) CGFloat baseAlpha;

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index baseAlpha:(CGFloat)baseAlpha;

- (void)lightUpAndDown;
- (void)lightUpAndDownCompletion:(void(^)(BOOL finished))completion;

@end
