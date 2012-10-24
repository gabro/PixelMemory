//
//  GGSequence.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGSequence.h"
#import "GGButton.h"

@interface GGSequence ()
@end

@implementation GGSequence

- (id)init {
    self = [super init];
    if (self) {
        _shapes = [NSArray array];
    }
    return self;
}

+ (GGSequence *)sequence {
    return [[GGSequence alloc] init];
}

- (void)addShape:(GGGridShape *)shape {
    _shapes = [self.shapes arrayByAddingObject:shape];
}


- (NSUInteger)length {
    return self.shapes.count;
}

- (GGButton *)elementAtIndex:(NSUInteger)index {
    return [self.shapes objectAtIndex:index];
}

@end
