    //
//  GGViewController.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GGGameViewController.h"
#import "GGTile.h"
#import "GGGameBoard.h"
#import "GGSequence.h"
#import "GGGridShape.h"

#import "GGGameOverViewController.h"

@interface GGGameViewController ()
@property (nonatomic, strong) GGGameBoard * gameBoard;
@property (nonatomic, strong) GGSequence * computerSequence;
@property (nonatomic, strong) GGSequence * userSequence;
@property (nonatomic, strong) NSTimer * progressTimer;
@property (nonatomic, strong) NSDate * turnStartTime;
@property (nonatomic, assign) NSTimeInterval maxTime;
@property (nonatomic, assign) NSTimeInterval currentTimeLeft;
@property (nonatomic, assign) BOOL shouldUpdateProgress;
@property (nonatomic, assign) NSInteger score;
@end

@implementation GGGameViewController

#pragma mark - Initializers
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.gameBoard = [[GGGameBoard alloc] initWithFrame:self.view.frame progressBar:YES];
    self.gameBoard.delegate = self;
    [self.view addSubview:self.gameBoard];
    
    [self resetScore];
    
    self.maxTime = GAME_TIME;
    self.currentTimeLeft = self.maxTime;
    
    // TODO this is really weak. Fix it soon
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480) {
            [self.bannerView removeFromSuperview];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startNewGame];
//    [self.gridView playSequence:[self.gridView randomSequenceWithLength:10]];
}


#pragma mark - GGGridDelegate
- (void)gridView:(GGGridView *)gridView didSelectShape:(GGGridShape *)shape {
    [self.userSequence addShape:shape];
    [self checkSequence];
}

#pragma mark - Game business logic
- (void)startNewGame {
    self.computerSequence = [GGSequence sequence];
    [self showMessage:NSLocalizedString(@"START_GAME_MESSAGE", @"") inView:self.view completion:^{
        [self nextLevel];
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_FRAME_RATE
                                                              target:self
                                                            selector:@selector(handleProgressTimer)
                                                            userInfo:nil
                                                             repeats:YES];
    }];
}

- (void)nextLevel {
    [self.computerSequence addShape:[(id)self.gameBoard randomShapeWithLength:(int)arc4random_uniform(MAX_SEQUENCE_LENGTH)+1]];
    [self userInteractionEnabled:NO];
    [(id)self.gameBoard playSequence:self.computerSequence completion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
        self.shouldUpdateProgress = YES;
        self.turnStartTime = [NSDate date];
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
    [self.gameBoard updateProgress:(self.currentTimeLeft / self.maxTime)];
}

- (void)showMessage:(NSString *)message
             inView:(UIView *)view
         completion:(void(^)())completion {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = GAME_FONT(30.0f);
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
        [self updateProgress:TIMER_BONUS * self.computerSequence.length];
        [self updateScore];
        [self userInteractionEnabled:NO];
        self.shouldUpdateProgress = NO;
        [self performSelector:@selector(nextLevel) withObject:nil afterDelay:TURNS_INTERVAL];
    }
}

- (void)resetScore {
    self.score = 0;
}

- (void)updateScore {
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.turnStartTime];
    NSInteger maxScore = SCORE_MULTIPLIER*self.computerSequence.length;
    NSInteger minScore = SCORE_MULTIPLIER*self.computerSequence.length/3;
    NSInteger timePenality = elapsedTime*self.computerSequence.length;
    NSInteger scoreDelta = MAX(maxScore - timePenality, minScore);
    self.score += scoreDelta;
    
    [self.gameBoard updateScore:self.score animated:YES];
}


- (void)gameOver {
    GGGameOverViewController * gameOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverVC"];
    gameOverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    gameOverVC.score = self.score;
    [self showMessage:NSLocalizedString(@"GAME_OVER_MESSAGE", @"") inView:self.view.window completion:nil];
    [self presentViewController:gameOverVC animated:YES completion:nil];
    
    [self.progressTimer invalidate];
}

- (void)userInteractionEnabled:(BOOL)enabled {
    self.gameBoard.userInteractionEnabled = enabled;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
