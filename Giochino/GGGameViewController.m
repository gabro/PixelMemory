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

@interface GGGameViewController ()
@property (nonatomic, strong) GGGrid * grid;
@property (nonatomic, strong) GGSequence * computerSequence;
@property (nonatomic, strong) GGSequence * userSequence;
@end

@implementation GGGameViewController

#pragma mark - Initializers
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Become first responder in order to listen to shake events

    [self initGrid];
    [self initDragRecognizer];
    [self startGame];
}

- (void)initGrid {
    self.grid = [[GGGrid alloc] initWithFrame:self.view.frame];
    self.grid.delegate = self;
    [self.view addSubview:self.grid];
}

#pragma mark - Drag Recognizer
- (void)initDragRecognizer {
    UILongPressGestureRecognizer * dragger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    dragger.numberOfTapsRequired=0;
    dragger.minimumPressDuration=0.005;
    [self.view addGestureRecognizer:dragger];
}

- (void)handleDrag:(UILongPressGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.grid];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [[self.grid buttonAtLocation:touchPoint] lightUp];
    }
}

#pragma mark - GGGridDelegate
- (void)didPressButton:(GGButton *)button {
    [button lightUp];
    [self.userSequence addButton:button];
    [self checkSequence];
}

#pragma mark - Game business logic
- (void)startGame {
    self.computerSequence = [GGSequence sequence];
    [self nextLevel];
}

- (void)nextLevel {
    [self.computerSequence addButton:[self.grid randomButton]];
    [self userInteractionEnabled:NO];
    [self.computerSequence playCompletion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
    }];
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

- (void)userInteractionEnabled:(BOOL)enabled {
    self.view.userInteractionEnabled = enabled;
}

@end
