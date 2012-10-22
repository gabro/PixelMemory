//
//  GGButton.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/21/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUTTON_LIGHT_UP_ANIMATION_DURATION 0.1f
#define BUTTON_LIGHT_DOWN_ANIMATION_DURATION 0.25f
#define BUTTON_LIGHT_UP_PERSISTANCE 0.1f
#define BASE_ALPHA 0.2f

@interface GGButton : UIButton

- (void)lightUp;

@end
