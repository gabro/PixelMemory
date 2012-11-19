//
//  GGViewController.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GGGridView.h"

@interface GGGameViewController : UIViewController <GGGridViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView * progressBar;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)startNewGame;

@end
