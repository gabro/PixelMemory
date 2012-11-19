//
//  GameConstants.h
//  Giochino
//
//  Created by Gabriele Petronella on 10/22/12.
//  Copyright (c) 2012 GG. All rights reserved.
//

#ifndef Giochino_GameConstants_h
#define Giochino_GameConstants_h

// Game constanst
#define TURNS_INTERVAL 0.6f

// Grid constants
#define BUTTONS_PER_ROW 4
#define BUTTONS_PER_COLUMN 6
#define BUTTON_HEIGHT CGRectGetWidth([UIScreen mainScreen].applicationFrame)/BUTTONS_PER_ROW
#define BUTTON_WIDTH BUTTON_HEIGHT
#define BUTTON_PADDING 2.5f

// Buttons constatns
#define BUTTON_LIGHT_UP_ANIMATION_DURATION 0.1f
#define BUTTON_LIGHT_DOWN_ANIMATION_DURATION 0.25f
#define BUTTON_LIGHT_UP_PERSISTANCE 0.1f
#define BASE_ALPHA 0.1f


// Sequence constants
#define MAX_SEQUENCE_LENGTH 1
#define PLAY_INTERVAL 0.2f
#define PLAY_SHAPE_INTERVAL 0.1f

// Misc
#define NEUROPOL_FONT(s) [UIFont fontWithName:@"NEUROPOL" size:s]

#endif
