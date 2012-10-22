//
//  GGViewController.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GGGameViewController.h"
#import "GGButton.h"
#import "GGSequence.h"

#import "GGGameOverViewController.h"

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
    [self startNewGame];

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
- (void)startNewGame {
    self.computerSequence = [GGSequence sequence];
    [self nextLevel];
}

- (void)nextLevel {
    [self.computerSequence addButton:[self.grid randomButton]];
    [self userInteractionEnabled:NO];
    [self.computerSequence playCompletion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
        [self showMessage:@"GO!"];
    }];
}

- (void)showMessage:(NSString *)message {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = [UIFont systemFontOfSize:30.0f];
    label.center = self.view.center;
    [self.view addSubview:label];
    [self userInteractionEnabled:NO];
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:!UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         label.layer.affineTransform = CGAffineTransformMakeScale(10.0f, 10.0f);
                         label.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [label removeFromSuperview];
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
    GGGameOverViewController * gameOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverVC"];
    gameOverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:gameOverVC animated:YES completion:nil];
}

- (void)userInteractionEnabled:(BOOL)enabled {
    self.view.userInteractionEnabled = enabled;
}

@end
