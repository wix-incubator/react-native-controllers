//
//  DarwerTheSideBarManagerViewController.m
//  ReactNativeControllers
//
//  Created by Ran Greenberg on 22/03/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RCCTheSideBarManagerViewController.h"
#import "RCCViewController.h"
#import "RCCDrawerHelper.h"
#import "RCTConvert.h"

@interface RCCTheSideBarManagerViewController ()

@property (nonatomic) BOOL isOpen;
@property (nonatomic) BOOL shouldHideStatusBar;

@property (nonatomic) SidebarTransitionStyle animationStyle;

@property (nonatomic, strong) RCCViewController *leftViewController;
@property (nonatomic, strong) RCCViewController *rightViewController;
@property (nonatomic, strong) RCCViewController *centerViewController;


@end

@implementation RCCTheSideBarManagerViewController

@synthesize closeOnTopButton = _closeOnTopButton, drawerStyle = _drawerStyle;

-(void)setShouldHideStatusBar:(BOOL)shouldHideStatusBar {
    _shouldHideStatusBar = shouldHideStatusBar;
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(UIButton*)closeOnTopButton {
    if (!_closeOnTopButton) {
        _closeOnTopButton = [RCCDrawerHelper createOnTopButton:self];
    }
    return _closeOnTopButton;
}


- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge {
    
    self.drawerStyle = props[@"style"];
    
    // centerDRAWER_WIDTH
    if ([children count] < 1) return nil;
    self.centerViewController = [RCCViewController controllerWithLayout:children[0] globalProps:props bridge:bridge];
    
    // left

    NSString *componentLeft = props[@"componentLeft"];
    NSDictionary *passPropsLeft = props[@"passPropsLeft"];
    
    if (componentLeft)  {
        self.leftViewController = [[RCCViewController alloc] initWithComponent:componentLeft passProps:passPropsLeft navigatorStyle:nil globalProps:props bridge:bridge];
    }
    
    // right

    NSString *componentRight = props[@"componentRight"];
    NSDictionary *passPropsRight = props[@"passPropsRight"];
    
    if (componentRight) {
        self.rightViewController = [[RCCViewController alloc] initWithComponent:componentRight passProps:passPropsRight navigatorStyle:nil globalProps:props bridge:bridge];
    }
    
    self = [super initWithContentViewController:self.centerViewController
                      leftSidebarViewController:self.leftViewController
                     rightSidebarViewController:self.rightViewController];
    [self setDrawerType:props[@"drawerType"]];
    
    [self setStyle];
    
    self.isOpen = NO;

    if (!self) return nil;
    return self;
}

-(void)setStyle:(TheSideBarSide)side {
    
    CGRect sideBarFrame = self.view.frame;
    
    switch (side) {
        case TheSideBarSideLeft:
        {
            NSNumber *leftDrawerWidth = self.drawerStyle[@"leftDrawerWidth"];
            if (leftDrawerWidth) {
                
                self.visibleWidth = self.view.bounds.size.width * MIN(1, (leftDrawerWidth.floatValue/100.0));
                sideBarFrame.size.width = self.view.bounds.size.width * MIN(1, (leftDrawerWidth.floatValue/100.0));
                self.leftViewController.view.frame = sideBarFrame;
            }
        }
            break;
            
        case TheSideBarSideRight:
        {
            NSNumber *rightDrawerWidth = self.drawerStyle[@"rightDrawerWidth"];
            if (rightDrawerWidth) {
                self.visibleWidth = self.view.bounds.size.width * MIN(1, (rightDrawerWidth.floatValue/100.0));
                sideBarFrame.size.width = self.view.bounds.size.width * MIN(1, (rightDrawerWidth.floatValue/100.0));
                sideBarFrame.origin.x = self.view.frame.size.width - self.visibleWidth;
                self.rightViewController.view.frame = sideBarFrame;
            }
        }
            break;
            
        default:
            break;
    }
}


-(void)setStyle {
    
    [self setStyle:TheSideBarSideLeft];
    [self setStyle:TheSideBarSideRight];
    
    NSString *contentOverlayColor = self.drawerStyle[@"contentOverlayColor"];
    if (contentOverlayColor)
    {
        UIColor *color = contentOverlayColor != (id)[NSNull null] ? [RCTConvert UIColor:contentOverlayColor] : nil;
        self.closeOnTopButton.backgroundColor = color;
    }
}


-(void)setDrawerType:(NSString*)type {
    if ([type isEqualToString:@"airbnb"]) self.animationStyle = SidebarTransitionStyleAirbnb;
    else if ([type isEqualToString:@"facebook"]) self.animationStyle = SidebarTransitionStyleFacebook;
    else if ([type isEqualToString:@"luvocracy"]) self.animationStyle = SidebarTransitionStyleLuvocracy;
    else if ([type isEqualToString:@"feedly"]) self.animationStyle = SidebarTransitionStyleFeedly;
    else if ([type isEqualToString:@"flipboard"]) self.animationStyle = SidebarTransitionStyleFlipboard;
    else if ([type isEqualToString:@"wunderlist"]) self.animationStyle = SidebarTransitionStyleWunderlist;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge {
    
    NSLog(@"performAction:%@", performAction);
    
    TheSideBarSide side = TheSideBarSideLeft;
    
    if ([actionParams[@"side"] isEqualToString:@"right"]) side = TheSideBarSideRight;
    
    
    // open
    if ([performAction isEqualToString:@"open"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self openSideMenu:side];
            
        });
        return;
    }
    
    // close
    if ([performAction isEqualToString:@"close"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self onTopButtonPressed:self.closeOnTopButton];
            
        });
        return;
    }
    
    // toggle
    if ([performAction isEqualToString:@"toggle"])
    {
        [self setStyle:side];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isOpen) {
                self.shouldHideStatusBar = NO;
                [self onTopButtonPressed:self.closeOnTopButton];
                
            }
            else {
                self.shouldHideStatusBar = YES;
                [self openSideMenu:side];
                
            }
            
            self.isOpen = !self.isOpen;
            
        });
        return;
    }
    
    // setStyle
    if ([performAction isEqualToString:@"setStyle"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (actionParams[@"animationType"]) {
                NSString *animationTypeString = actionParams[@"animationType"];
                
                CGRect leftSideBarFrame = self.leftViewController.view.frame;
                leftSideBarFrame.origin.x = 0;
                self.leftViewController.view.frame = leftSideBarFrame;
                
                CGRect rightSideBarFrame = self.rightViewController.view.frame;
                rightSideBarFrame.origin.x = self.view.frame.size.width - self.visibleWidth;
                self.rightViewController.view.frame = rightSideBarFrame;
                
                if ([animationTypeString isEqualToString:@"airbnb"])  {
                    self.animationStyle = SidebarTransitionStyleAirbnb;
                }
                else if ([animationTypeString isEqualToString:@"facebook"]){
                    self.animationStyle = SidebarTransitionStyleFacebook;
                }
                else if ([animationTypeString isEqualToString:@"luvocracy"]) {
                    self.animationStyle = SidebarTransitionStyleLuvocracy;
                }
                else if ([animationTypeString isEqualToString:@"feedly"]) {
                    self.animationStyle = SidebarTransitionStyleFeedly;
                    
                    leftSideBarFrame.origin.x = self.view.frame.size.width - leftSideBarFrame.size.width;
                    self.leftViewController.view.frame = leftSideBarFrame;
                    
                    rightSideBarFrame.origin.x = 0;
                    self.rightViewController.view.frame = rightSideBarFrame;
                }
                else if ([animationTypeString isEqualToString:@"flipboard"]) {
                    self.animationStyle = SidebarTransitionStyleFlipboard;
                    
                    leftSideBarFrame.origin.x = self.view.frame.size.width - leftSideBarFrame.size.width;
                    self.leftViewController.view.frame = leftSideBarFrame;
                    
                    rightSideBarFrame.origin.x = 0;
                    self.rightViewController.view.frame = rightSideBarFrame;
                }
                else if ([animationTypeString isEqualToString:@"wunderlist"]) {
                    self.animationStyle = SidebarTransitionStyleWunderlist;
                }
                
            }
            
        });
        return;
    }
}


-(void)openSideMenu:(TheSideBarSide)side{
    
    RCCDrawerSide drawerSide;
    
    switch (side) {
        case TheSideBarSideLeft:
        {
            [self presentLeftSidebarViewControllerWithStyle:self.animationStyle];
            drawerSide = RCCDrawerSideLeft;
        }
            
            break;
        case TheSideBarSideRight:
        {
            [self presentRightSidebarViewControllerWithStyle:self.animationStyle];
            drawerSide = RCCDrawerSideRight;
        }
            
            break;
            
        default:
            break;
    }
    
    [RCCDrawerHelper addOnTopButtonToScreen:self.closeOnTopButton contextView:self.view side:drawerSide sideMenuWidth:self.visibleWidth animationDuration:self.animationDuration];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(BOOL)prefersStatusBarHidden {
    NSLog(@"self.shouldHideStatusBar:%d", self.shouldHideStatusBar);
    return self.shouldHideStatusBar;
}


-(void)onTopButtonPressed:(UIButton*)button {
    [self dismissSidebarViewController];
    [RCCDrawerHelper onTopButtonPressed:button animationDuration:self.animationDuration];
    self.isOpen = NO;
    self.shouldHideStatusBar = NO;
    
}

- (id) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}


@end
