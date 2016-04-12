//
//  RCCDrawerHelper.m
//  ReactNativeControllers
//
//  Created by Ran Greenberg on 07/04/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RCCDrawerHelper.h"

@implementation RCCDrawerHelper

static CGFloat _sideMenuWidth;

+(UIButton*)createOnTopButton:(NSObject*)context {
    UIButton *onTopButton = [[UIButton alloc] init];
    onTopButton.backgroundColor = [UIColor colorWithRed:22/256 green:45/256 blue:61/256 alpha:0.5 ];
//    onTopButton.backgroundColor = [UIColor greenColor];
    [onTopButton addTarget:context action:@selector(onTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return onTopButton;
}


+(void)addOnTopButtonToScreen:(UIButton*)buttonToAdd
                  contextView:(UIView*)view
                         side:(RCCDrawerSide)side
                sideMenuWidth:(CGFloat)sideMenuWidth
            animationDuration:(CGFloat)duration {
    
    _sideMenuWidth = sideMenuWidth;
    
    CGRect buttonFrame = view.bounds;
    
    buttonFrame.origin.x = [RCCDrawerHelper onTopButtonX:sideMenuWidth side:side];

    switch (side) {
        case RCCDrawerSideLeft:
        {
            buttonFrame.origin.x = sideMenuWidth;
        }
            
            break;
        case RCCDrawerSideRight:
        {
            buttonFrame.origin.x = 0;
        }
            
            break;
            
        default:
            break;
    }
    
    buttonFrame.size.width = buttonFrame.size.width - sideMenuWidth;
    buttonToAdd.frame = view.frame;
    [view addSubview:buttonToAdd];
    
    buttonToAdd.alpha = 0;

    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         buttonToAdd.alpha = 1;
                         buttonToAdd.frame = buttonFrame;
                     }
                     completion:nil];
    
    
}

+(void)onTopButtonPressed:(UIButton*)button animationDuration:(CGFloat)duration {
    
    CGRect buttonFrame = button.bounds;
//    buttonFrame.size.width = buttonFrame.size.width - _sideMenuWidth;
//    button.frame = buttonFrame;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         button.alpha = 0;
                         button.frame = button.superview.frame;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [button removeFromSuperview];
                         }
                     }];
    
}


+(CGFloat)onTopButtonX:(CGFloat)sideMenuWidth side:(RCCDrawerSide)side {
    switch (side) {
        case RCCDrawerSideLeft:
        {
            return sideMenuWidth;
        }
            
            break;
        case RCCDrawerSideRight:
        {
            return 0;
        }
            
            break;
            
        default:
            break;
    }
}

@end
