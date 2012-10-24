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

@interface GGGameViewController ()
@property (nonatomic, strong) GGGridView * gridView;
@property (nonatomic, strong) GGSequence * computerSequence;
@property (nonatomic, strong) GGSequence * userSequence;
@end

@implementation GGGameViewController

#pragma mark - Initializers
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initGrid];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startNewGame];
//    [self.gridView playSequence:[self.gridView randomSequenceWithLength:10]];
}

- (void)initGrid {
    self.gridView = [[GGGridView alloc] initWithFrame:self.view.frame];
    self.gridView.delegate = self;
    [self.view addSubview:self.gridView];
}

#pragma mark - GGGridDelegate
- (void)gridView:(GGGridView *)gridView didSelectShape:(GGGridShape *)shape {
    [self.userSequence addShape:shape];
    [self checkSequence];
}

#pragma mark - Game business logic
- (void)startNewGame {
    self.computerSequence = [GGSequence sequence];
    [self showMessage:@"GO!" completion:^{
        [self nextLevel];
    }];
}

- (void)nextLevel {
    [self.computerSequence addShape:[self.gridView randomShapeWithLength:(int)arc4random_uniform(4)+1]];
    [self userInteractionEnabled:NO];
    [self.gridView playSequence:self.computerSequence completion:^{
        self.userSequence = [GGSequence sequence];
        [self userInteractionEnabled:YES];
    }];
}

- (void)showMessage:(NSString *)message
         completion:(void(^)())completion {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = NEUROPOL_FONT(30.0f);
    label.center = self.view.center;
    [self.view addSubview:label];
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
                         completion();
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
        [self userInteractionEnabled:NO];
        [self performSelector:@selector(nextLevel) withObject:nil afterDelay:TURNS_INTERVAL];
    }
}

- (void)gameOver {
    GGGameOverViewController * gameOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverVC"];
    gameOverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self showMessage:@"Game Over" completion:^{
        [self presentViewController:gameOverVC animated:YES completion:nil];
    }];
}

- (void)userInteractionEnabled:(BOOL)enabled {
    self.view.userInteractionEnabled = enabled;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
