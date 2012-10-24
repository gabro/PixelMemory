//
//  GGGrid.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GGGridView.h"
#import "GGButton.h"
#import "GGSequence.h"
#import "GGGridShape.h"

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface GGGridView ()
@property (nonatomic, copy) NSArray * buttons;
@property (nonatomic, copy) NSArray * colors;
@property (nonatomic, strong) NSTimer * playSequenceTimer;
@property (nonatomic, strong) NSEnumerator * playSequenceEnumerator;
@property (nonatomic, strong) NSTimer * playShapeTimer;
@property (nonatomic, strong) NSEnumerator * playShapeEnumerator;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, copy) void (^sequenceCompletion)();
@property (nonatomic, copy) void (^shapeCompletion)();
@end

@implementation GGGridView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initColors];
        [self initButtons];
    }
    return self;
}


- (void)initColors {
    NSMutableArray * colors = [NSMutableArray array];
#define addColor(r,g,b) [colors addObject:rgb(r,g,b)];
    addColor(254, 246, 140) //YELLOW
    addColor(174, 210, 159) //GREEN
    addColor(219, 88, 140) //PURPLE
    addColor(63, 172, 229) //BLUE
#undef addColor
    self.colors = colors;
}

- (void)initButtons {
    NSMutableArray * buttons = [NSMutableArray arrayWithCapacity:BUTTONS_PER_COLUMN*BUTTONS_PER_ROW];
    for (NSUInteger i = 0 ; i < BUTTONS_PER_COLUMN; i++) {
        for (NSUInteger j = 0; j < BUTTONS_PER_ROW; j++) {
            CGFloat xOrigin = BUTTON_WIDTH * j + BUTTON_PADDING;
            CGFloat yOrigin = BUTTON_HEIGHT * i + BUTTON_PADDING;
            CGRect buttonFrame = CGRectMake(xOrigin, yOrigin, BUTTON_WIDTH - BUTTON_PADDING * 2, BUTTON_HEIGHT - BUTTON_PADDING * 2);
            GGButton * button = [[GGButton alloc] initWithFrame:buttonFrame index:(i * BUTTONS_PER_ROW + j)];
            button.backgroundColor = [self randomColor];
            button.alpha = BASE_ALPHA;
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
            [buttons addObject:button];
        }
    }
    self.buttons = buttons;
}

- (UIColor *)randomColor {
    return self.colors[(int)arc4random_uniform(self.colors.count)];
}

- (GGGridShape *)randomShape {
    GGGridShape * shape = [GGGridShape shape];
    [shape addIndex:[self randomButton].index];
    return shape;
}

- (GGButton *)randomButton {
    return self.buttons[(int)arc4random_uniform(self.buttons.count)];
}

- (GGSequence *)randomSequenceWithLength:(NSUInteger)length {
    GGSequence * sequence = [GGSequence sequence];
    for (NSUInteger i = 0; i < length; i++) {
        [sequence addShape:[self randomShape]];
    }
    return sequence;
}

- (GGButton *)buttonAtIndex:(NSUInteger)index {
    for (GGButton * button in self.buttons) {
        if (button.index == index) {
            return button;
        }
    }
    return nil;
}

- (GGButton *)buttonAtLocation:(CGPoint)point {
    NSInteger column = point.x / (BUTTON_WIDTH);
    NSInteger row = point.y / (BUTTON_HEIGHT);
    NSUInteger index = row * BUTTONS_PER_ROW + column;
    return [self buttonAtIndex:index];
}

- (void)buttonPressed:(GGButton *)button {
    [self.delegate didPressButton:button];
}

- (void)playSequence:(GGSequence *)sequence {
    [self playSequence:sequence completion:nil];
}

- (void)playSequence:(GGSequence *)sequence
          completion:(void (^)())completion {
    [self playSequence:sequence completion:completion interval:PLAY_INTERVAL];
}

- (void)playSequence:(GGSequence *)sequence
          completion:(void (^)())completion
            interval:(NSTimeInterval)interval {
    if (!self.isPlaying) {
        self.isPlaying = YES;
        self.playSequenceEnumerator = [sequence.shapes objectEnumerator];
        self.playSequenceTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                          target:self
                                                        selector:@selector(playSequenceStep)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    self.sequenceCompletion = completion;
}

- (void)playSequenceStep {
    GGGridShape * shape;
    if ((shape = self.playSequenceEnumerator.nextObject)) {
        [self playShape:shape completion:nil interval:PLAY_SHAPE_INTERVAL];
    } else {
        [self.playSequenceTimer invalidate];
        self.isPlaying = NO;
        if(self.sequenceCompletion) self.sequenceCompletion();
    }
}

- (void)playShape:(GGGridShape *)shape
       completion:(void (^)())completion
         interval:(NSTimeInterval)interval {
    self.playShapeEnumerator = [shape.indices objectEnumerator];
    self.playShapeTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                           target:self
                                                         selector:@selector(playShapeStep)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)playShapeStep {
    NSNumber * index;
    if ((index = self.playShapeEnumerator.nextObject)) {
        [[self buttonAtIndex:index.intValue] lightUp];
    } else {
        [self.playShapeTimer invalidate];
        if (self.shapeCompletion) self.shapeCompletion();
    }
}

@end
