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
#define TIMER_FRAME_RATE 0.05
#define TIMER_BONUS 0.6
#define SCORE_MULTIPLIER 10
#define GAME_TIME 10.0f

// Grid constants
#define BUTTONS_PER_ROW 4
#define BUTTONS_PER_COLUMN 6
#define BUTTON_HEIGHT CGRectGetWidth([UIScreen mainScreen].applicationFrame)/BUTTONS_PER_ROW
#define BUTTON_WIDTH BUTTON_HEIGHT
#define BUTTON_PADDING 2.5f
#define PROGRESS_BAR_HEIGHT 10.0f

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
#define GAME_FONT(s) [UIFont fontWithName:@"NEUROPOL" size:s]

#endif
