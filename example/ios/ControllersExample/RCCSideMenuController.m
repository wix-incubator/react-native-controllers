//
//  RCCSideMenuController.m
//  ControllersExample
//
//  Created by Ran Greenberg on 11/9/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import "RCCSideMenuController.h"
#import "RCTRootView.h"
#import "RCCViewController.h"

@implementation RCCSideMenuController


- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL
{
  NSString *componentLeft = [params objectForKey:@"_componentLeft"];
  if (!componentLeft) return nil;
  
  RCTRootView *reactLeftView = [[RCTRootView alloc] initWithBridge:bridge moduleName:componentLeft initialProperties:nil];
  if (!reactLeftView) return nil;
  
  UIViewController *leftViewController = [[UIViewController alloc] init];
  leftViewController.view = reactLeftView;
  
  NSString *componentRight = [params objectForKey:@"_componentRight"];
  if (!componentRight) return nil;
  
  RCTRootView *reactRightView = [[RCTRootView alloc] initWithBridge:bridge moduleName:componentRight initialProperties:nil];
  if (!reactRightView) return nil;
  
  UIViewController *rightViewController = [[UIViewController alloc] init];
  rightViewController.view = reactRightView;
  
  UIViewController *centerViewController = [self getItemViewController:params
                                                                params:params
                                                                bridge:bridge
                                                             bundleURL:bundleURL];
  
  self = [super initWithCenterViewController:centerViewController
                    leftDrawerViewController:leftViewController
                   rightDrawerViewController:rightViewController];
  
  self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
  self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

  
  if (!self) return nil;
  
  
  
  return self;
}

- (UIViewController *)getItemViewController:(NSDictionary *)itemParams
                                     params:(NSDictionary *)params
                                     bridge:(RCTBridge *)bridge
                                  bundleURL:(NSURL *)bundleURL
{
  for (NSString *key in itemParams)
  {
    if (![key hasPrefix:@"_"]) return [RCCViewController controllerWithType:key
                                                                     params:[itemParams objectForKey:key]
                                                                     bridge:bridge
                                                                  bundleURL:bundleURL];
  }
  
  // none found
  return nil;
}

@end
