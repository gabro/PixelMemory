//
//  GGButton.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGButton.h"

@implementation GGButton

- (void)lightUp {
    void (^completion)(BOOL) = ^(BOOL finished) {
        [UIView animateWithDuration:BUTTON_LIGHT_DOWN_ANIMATION_DURATION
                              delay:BUTTON_LIGHT_UP_PERSISTANCE
                            options:!UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = BASE_ALPHA;
                         } completion:nil];
    };
    
    [UIView animateWithDuration:BUTTON_LIGHT_UP_ANIMATION_DURATION
                          delay:0.0f
                        options:!UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.0f;
                     } completion:completion];
}

@end
