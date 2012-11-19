//
//  GGViewController.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGridView.h"

@interface GGGameViewController : UIViewController <GGGridViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView * progressBar;

- (void)startNewGame;

@end
