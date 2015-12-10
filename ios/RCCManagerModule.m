//
//  RCCManager.m
//  ControllersExample
//
//  Created by Artal Druk on 11/9/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import "RCCManagerModule.h"
#import "RCCManager.h"
#import <UIKit/UIKit.h>
#import "RCCNavigationController.h"
#import "RCCViewController.h"
#import "RCCDrawerController.h"


@implementation RCCManagerModule

RCT_EXPORT_MODULE(RCCManager);

RCT_EXPORT_METHOD(
setRootController:(NSDictionary*)layout)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    // create the new controller
    UIViewController *controller = [RCCViewController controllerWithLayout:layout bridge:[[RCCManager sharedIntance] getBridge]];
    if (controller == nil) return;
    
    // set this new controller as the root
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = controller;
    [appDelegate.window makeKeyAndVisible];
    
  });
}

RCT_EXPORT_METHOD(
NavigationControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCNavigationController* controller = [[RCCManager sharedIntance] getControllerWithId:controllerId componentType:@"NavigationControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCNavigationController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedIntance] getBridge]];
}

RCT_EXPORT_METHOD(
DrawerControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCDrawerController* controller = [[RCCManager sharedIntance] getControllerWithId:controllerId componentType:@"DrawerControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCDrawerController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedIntance] getBridge]];
}

@end
