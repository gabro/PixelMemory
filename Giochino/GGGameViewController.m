//
//  GGViewController.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGGameViewController.h"
#import "GGButton.h"
#import "GGSequence.h"

#import <QuartzCore/QuartzCore.h>

#define BUTTONS_PER_ROW 4
#define BUTTONS_PER_COLUMN 6
#define BUTTON_HEIGHT CGRectGetWidth(self.view.frame)/BUTTONS_PER_ROW
#define BUTTON_WIDTH BUTTON_HEIGHT
#define BUTTON_PADDING 2.5f

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface GGGameViewController ()
@property (nonatomic, copy) NSArray * colors;
@property (nonatomic, copy) NSArray * buttons;
@property (nonatomic, strong) GGSequence * computerSequence;
@property (nonatomic, strong) GGSequence * userSequence;
@end

@implementation GGGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Become first responder in order to listen to shake events

    [self initColors];
	[self drawGrid];
    [self initDragRecognizer];
    [self startGame];
}

- (void)initDragRecognizer {
    UILongPressGestureRecognizer * dragger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    dragger.numberOfTapsRequired=0;
    dragger.minimumPressDuration=0.005;
    [self.view addGestureRecognizer:dragger];
}

- (void)drawGrid {
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
            [self.view addSubview:button];
            [buttons addObject:button];
        }
    }
    self.buttons = buttons;
}

- (void)buttonPressed:(GGButton *)button {
    [button lightUp];
    [self recordButton:button];
    [self checkSequence];
}

- (void)recordButton:(GGButton *)button {
    [self.userSequence addButton:button];
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

- (UIColor *)randomColor {
    return self.colors[(int)arc4random_uniform(self.colors.count)];
}

- (GGButton *)buttonAtLocation:(CGPoint)point {
    NSInteger column = point.x / (BUTTON_WIDTH);
    NSInteger row = point.y / (BUTTON_HEIGHT);
    return self.buttons[row * BUTTONS_PER_ROW + column];
}

- (void)handleDrag:(UILongPressGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [[self buttonAtLocation:touchPoint] lightUp];
    }
}

- (GGButton *)randomButton {
    return self.buttons[(int)arc4random_uniform(self.buttons.count)];
}

- (void)startGame {
    self.computerSequence = [GGSequence sequence];
    [self nextLevel];
}

- (void)nextLevel {
    [self.computerSequence addButton:[self randomButton]];
    [self userInteractionEnabled:NO];
    [self.computerSequence playCompletion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
    }];
}

- (void)userInteractionEnabled:(BOOL)enabled {
    self.view.userInteractionEnabled = enabled;
}

- (void)checkSequence {
    for (int i = 0; i < self.userSequence.length; i++) {
        if (![[self.userSequence elementAtIndex:i] isEqual:[self.computerSequence elementAtIndex:i]]) {
            [self gameOver];
        }
    }
    if (self.userSequence.length == self.computerSequence.length) {
        [self nextLevel];
    }
}

- (void)gameOver {
    NSString * message = [NSString stringWithFormat:@"Game Over! You're result was %i. Try again!", self.computerSequence.length - 1];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
