//
//  GGSequence.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGSequence.h"
#import "GGButton.h"

#define PLAY_INTERVAL 0.5f

@interface GGSequence ()
@property (nonatomic, strong) NSArray * buttons;
@property (nonatomic, strong) NSTimer * playTimer;
@property (nonatomic, strong) NSEnumerator * playEnumerator;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation GGSequence

- (id)init
{
    self = [super init];
    if (self) {
        _buttons = [NSArray array];
    }
    return self;
}

+ (GGSequence *)sequence {
    return [[GGSequence alloc] init];
}

- (void)addButton:(GGButton *)button {
    self.buttons = [self.buttons arrayByAddingObject:button];
}

- (void)play {
    if (!self.isPlaying) {
        self.isPlaying = YES;
        self.playEnumerator = [self.buttons objectEnumerator];
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:PLAY_INTERVAL
                                                  target:self
                                                selector:@selector(playStep)
                                                userInfo:nil
                                                 repeats:YES];\
    }
}

- (void)playStep {
    GGButton * button;
    if ((button = self.playEnumerator.nextObject)) {
        [button lightUp];
    } else {
        [self.playTimer invalidate];
        self.isPlaying = NO;
    }
}


@end
