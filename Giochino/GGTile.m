//
//  GGButton.m
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import "GGTile.h"

@implementation GGTile

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index {
    if (self = [super initWithFrame:frame]) {
        _index = index;
    }
    return self;
}

- (void)lightUpAndDown {
    [self lightUpAndDownCompletion:nil];
}

- (void)lightUpAndDownCompletion:(void (^)(BOOL finished))completion {
    void (^lightUpCompletion)(BOOL) = ^(BOOL finished) {
        [UIView animateWithDuration:BUTTON_LIGHT_DOWN_ANIMATION_DURATION
                              delay:BUTTON_LIGHT_UP_PERSISTANCE
                            options:!UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = BASE_ALPHA;
                         } completion:completion];
    };
    
    [UIView animateWithDuration:BUTTON_LIGHT_UP_ANIMATION_DURATION
                          delay:0.0f
                        options:!UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.0f;
                     } completion:lightUpCompletion];

}

@end
