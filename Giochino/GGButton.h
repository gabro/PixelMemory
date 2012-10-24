//
//  GGButton.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGButton : UIButton

@property (nonatomic, readonly) NSUInteger index;

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index;

- (void)lightUp;
- (void)lightUpCompletion:(void(^)(BOOL finished))completion;

@end
