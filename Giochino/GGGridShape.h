//
//  GGGridShape.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/23/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGGridShape : NSObject

@property (nonatomic, readonly) NSArray * indices;

+ (GGGridShape *)shape;

- (void)addIndex:(NSUInteger)index;
- (NSUInteger)length;

@end
