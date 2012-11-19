//
//  GGGameOverViewController.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGGameOverViewController.h"
#import "GGGameViewController.h"

@interface GGGameOverViewController ()

@end

@implementation GGGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_over_bg"]];
    self.resultLabel.font = NEUROPOL_FONT(20.0f);
    self.resultLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GAME_OVER_SCORE_MESSAGE", nil), self.score];
}

- (IBAction)back {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tryAgain {
    GGGameViewController * gameController = (GGGameViewController *)self.presentingViewController;
    [gameController dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
