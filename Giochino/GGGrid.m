//
//  GGGrid.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GGGrid.h"
#import "GGButton.h"
#import "GGSequence.h"

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface GGGrid ()
@property (nonatomic, copy) NSArray * buttons;
@property (nonatomic, copy) NSArray * colors;
@end

@implementation GGGrid

- (id)initWithFrame:(CGRect)frame
{
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
            GGButton * button = [[GGButton alloc] initWithFrame:buttonFrame];
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

- (GGButton *)randomButton {
    return self.buttons[(int)arc4random_uniform(self.buttons.count)];
}

- (GGSequence *)randomSequenceWithLength:(NSUInteger)length {
    GGSequence * sequence = [GGSequence sequence];
    for (NSUInteger i = 0; i < length; i++) {
        [sequence addButton:[self randomButton]];
    }
    return sequence;
}

- (GGButton *)buttonAtLocation:(CGPoint)point {
    NSInteger column = point.x / (BUTTON_WIDTH);
    NSInteger row = point.y / (BUTTON_HEIGHT);
    return self.buttons[row * BUTTONS_PER_ROW + column];
}

- (void)buttonPressed:(GGButton *)button {
    [self.delegate didPressButton:button];
}

@end
