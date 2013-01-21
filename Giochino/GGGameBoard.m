//
//  GGGameBoard.m
//  Giochino
//
//  Created by Gabriele Petronella on 1/20/13.
//  Copyright (c) 2013 GG. All rights reserved.
//

#import "GGGameBoard.h"

#import <QuartzCore/QuartzCore.h>

@interface GGGameBoard ()
@property (nonatomic, strong) GGGridView * gridView;
@property (nonatomic, strong) UILabel * scoreLabel;
@property (nonatomic, strong) UIView * progressBar;
@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, assign) BOOL shouldPresentProgressBar;
@end

@implementation GGGameBoard

- (id)initWithFrame:(CGRect)frame progressBar:(BOOL)progressBar {
    self = [super initWithFrame:frame];
    if (self) {
        _shouldPresentProgressBar = progressBar;
        [self initGrid];
        [self initScore];
        [self initProgressBar];
    }
    return self;
}

- (void)initGrid {
    _gridView = [[GGGridView alloc] initWithFrame:self.frame];
    _gridView.tilesBaseAlpha = 0.4;
    [self addSubview:_gridView];
}

- (void)setDelegate:(id<GGGridViewDelegate>)delegate {
    self.gridView.delegate = delegate;
}

- (void)initScore {
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.font = GAME_FONT(27.0f);
    _scoreLabel.alpha = 0.8f;
    _scoreLabel.text = @"0";
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat vPadding = 10.0f;
    CGFloat hPadding = 15.0f;
    CGRect scoreLabelFrame = CGRectMake(hPadding, vPadding, CGRectGetWidth(_gridView.frame) - hPadding*2, 0.0f);
    CGSize labelSize = [_scoreLabel.text sizeWithFont:GAME_FONT(27.0f)
                                                 forWidth:CGRectGetWidth(_scoreLabel.frame)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    scoreLabelFrame.size.height = labelSize.height;
    _scoreLabel.frame = scoreLabelFrame;
    
    [self insertSubview:_scoreLabel aboveSubview:_gridView];
}

- (void)initProgressBar {
    CGRect overlayFrame = self.gridView.frame;
    overlayFrame.size.height -= _shouldPresentProgressBar ? PROGRESS_BAR_HEIGHT : 0.0f;
    self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.5f;
    [self.gridView addSubview:self.overlayView];
    
    if (_shouldPresentProgressBar) {
        CGRect barFrame = CGRectMake(CGRectGetMaxX(overlayFrame), CGRectGetMaxY(overlayFrame),
                                     CGRectGetWidth(overlayFrame), 10.0f);
        self.progressBar = [[UIView alloc] initWithFrame:barFrame];
        self.progressBar.backgroundColor = [UIColor blackColor];
        self.progressBar.alpha = 0.5;
        [self.gridView addSubview:self.progressBar];        
    }
}

- (void)updateScore:(NSInteger)score animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 1.0f : 0.0f animations:^{
        self.scoreLabel.alpha = 0.4f;
        self.scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        self.scoreLabel.alpha = 1.0f;
    }];
}

- (void)updateProgress:(NSTimeInterval)progress {
    [UIView animateWithDuration:TIMER_FRAME_RATE animations:^{
        CGRect barFrame = self.progressBar.frame;
        barFrame.origin.x = progress * CGRectGetWidth(self.progressBar.frame);
        self.progressBar.frame = barFrame;
    }];
}

- (void)resetProgressBar {
    CGRect barFrame = self.progressBar.frame;
    barFrame.origin.x = CGRectGetMaxX(self.gridView.frame);
    self.progressBar.frame = barFrame;
}

- (void)showMessage:(NSString *)message
         completion:(void (^)())completion {
    [self showMessage:message inView:self completion:completion];
}

- (void)showMessage:(NSString *)message
             inView:(UIView *)view
         completion:(void(^)())completion {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = GAME_FONT(30.0f);
    label.center = view.center;
    [view addSubview:label];
    view.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.5f
                          delay:0.0f
                        options:!UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         label.layer.affineTransform = CGAffineTransformMakeScale(10.0f, 10.0f);
                         label.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [label removeFromSuperview];
                         view.userInteractionEnabled = YES;
                         if (completion) completion();
                     }];
}


#pragma mark - Where magic happens (TM)
// The GameBoard serves a proxy between the GameContoller and the gridView
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.gridView respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.gridView];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

// This method is necessary for the above forwardInvocation to work
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature * signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [self.gridView methodSignatureForSelector:aSelector];
    }
    return signature;
}

@end
