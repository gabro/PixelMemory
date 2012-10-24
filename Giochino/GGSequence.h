//
//  GGSequence.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGGridShape;

@interface GGSequence : NSObject

@property (nonatomic, readonly) NSArray * shapes;

+ (GGSequence *)sequence;

- (NSUInteger)length;

- (void)addShape:(GGGridShape *)shape;
- (GGGridShape *)elementAtIndex:(NSUInteger)index;

@end
