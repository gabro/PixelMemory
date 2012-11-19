//
//  GGGameOverViewController.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGGameOverViewController : UIViewController

@property (nonatomic, assign) NSInteger score;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end
