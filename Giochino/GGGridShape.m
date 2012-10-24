//
//  GGGridShape.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/23/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGGridShape.h"

@interface GGGridShape ()
@end

@implementation GGGridShape

- (id)init {
    self = [super init];
    if (self) {
        _indices = [NSArray array];
    }
    return self;
}

+ (GGGridShape *)shape {
    return [[GGGridShape alloc] init];
}

- (void)addIndex:(NSUInteger)index {
    _indices = [self.indices arrayByAddingObject:@(index)];
}

- (NSUInteger)length {
    return self.indices.count;
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:self.class])
        return NO;
    
    GGGridShape * that = object;
    
    if (self.indices.count != that.indices.count) {
        return NO;
    }
    
    for (NSUInteger i = 0; i < self.indices.count; i++) {
        if (![self.indices[i] isEqual:that.indices[i]]) {
            return NO;
        }
    }
    
    return YES;
}
@end
