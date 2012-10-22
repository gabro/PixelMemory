//
//  GGSequence.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGButton;

@interface GGSequence : NSObject

+ (GGSequence *)sequence;

- (void)addButton:(GGButton *)button;

- (void)play;

@end
