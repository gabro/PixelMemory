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
#import "GGGridShape.h"

#import "GGGameOverViewController.h"

#define TIMER_FRAME_RATE 0.05
#define TIMER_BONUS 1

@interface GGGameViewController ()
@property (nonatomic, strong) GGGridView * gridView;
@property (nonatomic, strong) GGSequence * computerSequence;
@property (nonatomic, strong) GGSequence * userSequence;
@property (nonatomic, strong) NSTimer * progressTimer;
@property (nonatomic, assign) NSTimeInterval maxTime;
@property (nonatomic, assign) NSTimeInterval currentTimeLeft;
@property (nonatomic, assign) BOOL shouldUpdateProgress;
@end

@implementation GGGameViewController

#pragma mark - Initializers
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initGrid];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.progressBar.progress = 1.0f;
    self.maxTime = 10.0f;
    self.currentTimeLeft = self.maxTime;
    self.progressBar.alpha = 0.8;
    self.progressBar.transform = CGAffineTransformMakeScale(1.0f, 2.0f);;
    self.progressBar.trackTintColor = [UIColor clearColor];
    self.progressBar.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startNewGame];
//    [self.gridView playSequence:[self.gridView randomSequenceWithLength:10]];
}

- (void)initGrid {
    self.gridView = [[GGGridView alloc] initWithFrame:self.view.frame];
    self.gridView.delegate = self;
    [self.view insertSubview:self.gridView belowSubview:self.progressBar];
}

#pragma mark - GGGridDelegate
- (void)gridView:(GGGridView *)gridView didSelectShape:(GGGridShape *)shape {
    [self.userSequence addShape:shape];
    [self checkSequence];
}

#pragma mark - Game business logic
- (void)startNewGame {
    self.computerSequence = [GGSequence sequence];
    [self showMessage:@"GO!" inView:self.view completion:^{
        [self nextLevel];
    }];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_FRAME_RATE
                                                          target:self
                                                        selector:@selector(handleProgressTimer)
                                                        userInfo:nil
                                                         repeats:YES];
//    [self.progressBar setProgress:1.0f animated:YES];
}

- (void)nextLevel {
    [self.computerSequence addShape:[self.gridView randomShapeWithLength:(int)arc4random_uniform(MAX_SEQUENCE_LENGTH)+1]];
    [self userInteractionEnabled:NO];
    [self.gridView playSequence:self.computerSequence completion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
        self.shouldUpdateProgress = YES;
    }];
}

- (void)handleProgressTimer {
    if (self.shouldUpdateProgress) {
        [self updateProgress:-TIMER_FRAME_RATE];
        if (self.currentTimeLeft <= 0) {
            [self gameOver];
        }
    }
}

- (void)updateProgress:(NSTimeInterval)progress {
    self.currentTimeLeft += MIN(progress, self.maxTime - self.currentTimeLeft);
    [self.progressBar setProgress:(self.currentTimeLeft / self.maxTime) animated:YES];
}

- (void)showMessage:(NSString *)message
             inView:(UIView *)view
         completion:(void(^)())completion {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = NEUROPOL_FONT(30.0f);
    label.center = self.view.center;
    [view addSubview:label];
    [self userInteractionEnabled:NO];
    [UIView animateWithDuration:1.5f
                          delay:0.0f
                        options:!UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         label.layer.affineTransform = CGAffineTransformMakeScale(10.0f, 10.0f);
                         label.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [label removeFromSuperview];
                         [self userInteractionEnabled:YES];
                         if (completion) completion();
                     }];
}

- (void)checkSequence {
    for (int i = 0; i < self.userSequence.length; i++) {
        if (![[self.userSequence elementAtIndex:i] isEqual:[self.computerSequence elementAtIndex:i]]) {
            [self gameOver];
            return;
        }
    }
    if (self.userSequence.length == self.computerSequence.length) {
        [self updateProgress:TIMER_BONUS];
        [self userInteractionEnabled:NO];
        self.shouldUpdateProgress = NO;
        [self performSelector:@selector(nextLevel) withObject:nil afterDelay:TURNS_INTERVAL];
    }
}


- (void)gameOver {
    GGGameOverViewController * gameOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverVC"];
    gameOverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self showMessage:@"Game Over" inView:self.view.window completion:nil];
    [self presentViewController:gameOverVC animated:YES completion:nil];
    
    [self.progressTimer invalidate];
}

- (void)userInteractionEnabled:(BOOL)enabled {
    self.gridView.userInteractionEnabled = enabled;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
