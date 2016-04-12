//
//  RCCDrawerHelper.h
//  ReactNativeControllers
//
//  Created by Ran Greenberg on 07/04/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RCCDrawerSide){
    RCCDrawerSideLeft,
    RCCDrawerSideRight
};


@interface RCCDrawerHelper : NSObject

+(UIButton*)createOnTopButton:(NSObject*)context;

+(void)addOnTopButtonToScreen:(UIButton*)buttonToAdd
                  contextView:(UIView*)view
                         side:(RCCDrawerSide)side
                sideMenuWidth:(CGFloat)sideMenuWidth
            animationDuration:(CGFloat)duration;

+(void)onTopButtonPressed:(UIButton*)button animationDuration:(CGFloat)duration;


@end
