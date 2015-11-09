//
//  RCCManager.m
//  ControllersExample
//
//  Created by Artal Druk on 11/9/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import "RCCManager.h"
#import <UIKit/UIKit.h>
#import "RCTRootView.h"
#import "RCCSideMenuController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface RCControllersRegistry()
@property (nonatomic, strong) NSMutableDictionary *modulesRegistry;
@end

@implementation RCControllersRegistry

+ (instancetype)sharedIntance
{
  static RCControllersRegistry *sharedIntance = nil;
  static dispatch_once_t onceToken = 0;
  
  dispatch_once(&onceToken,^
                {
                  if (sharedIntance == nil)
                  {
                    sharedIntance = [[RCControllersRegistry alloc] init];
                  }
                });
  
  return sharedIntance;
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.modulesRegistry = [@{} mutableCopy];
  }
  return self;
}

-(void)registerController:(UIViewController*)controller componentID:(NSString*)componentID componentType:(NSString*)componentType
{
  if (controller == nil || componentID == nil)
  {
    return;
  }
  
  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic == nil)
  {
    componentsDic = [@{} mutableCopy];
    self.modulesRegistry[componentType] = componentsDic;
  }
  
  componentsDic[componentID] = controller;
}

-(id)getControllerWithID:(NSString*)componentID componentType:(NSString*)componentType
{
  if (componentID == nil)
  {
    return nil;
  }
  
  id component = nil;
  
  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic != nil)
  {
    component = componentsDic[componentID];
  }
  
  return component;
}

@end

@implementation RCCManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(NavigationControllerIOS:(NSString*)componentID performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (componentID == nil || performAction == nil || actionParams[@"component"] == nil)
  {
    return;
  }
  
  UIViewController* component = [[RCControllersRegistry sharedIntance] getControllerWithID:componentID componentType:@"NavigationControllerIOS"];
  if (component != nil && [component isKindOfClass:[UINavigationController class]])
  {
    UINavigationController *navigationController = (UINavigationController*)component;
    
    if (![navigationController.visibleViewController.view isKindOfClass:[RCTRootView class]])
    {
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                     RCTBridge *bridge = ((RCTRootView*)(navigationController.visibleViewController.view)).bridge;
                     RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:actionParams[@"component"] initialProperties:nil];
                     UIViewController *viewController = [[UIViewController alloc] init];
                     viewController.view = reactView;
                     viewController.title = actionParams[@"title"];
                     
                     BOOL animated = actionParams[@"animated"] ? [actionParams[@"animated"] boolValue] : YES;
                     if ([performAction isEqualToString:@"push"])
                     {
                       [navigationController pushViewController:viewController animated:animated];
                     }
                     else if ([performAction isEqualToString:@"pop"])
                     {
                       //TODO: implement
                     }
                   });
  }
}


////////////////////////////////////////////////////////////////


RCT_EXPORT_METHOD(SideMenuControllerIOS:(NSString*)componentID performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (componentID == nil || performAction == nil || actionParams[@"animationType"] == nil)
  {
    return;
  }
  
  UIViewController* component = [[RCControllersRegistry sharedIntance] getControllerWithID:componentID componentType:@"SideMenuControllerIOS"];
  if (component != nil && [component isKindOfClass:[RCCSideMenuController class]])
  {
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                     MMDrawerAnimationType animationType = MMDrawerAnimationTypeNone;
                     NSString *animationTypeString = actionParams[@"animationType"];
                     
                     if ([animationTypeString isEqualToString:@"door"]) animationType = MMDrawerAnimationTypeSwingingDoor;
                     else if ([animationTypeString isEqualToString:@"parallax"]) animationType = MMDrawerAnimationTypeParallax;
                     else if ([animationTypeString isEqualToString:@"slide"]) animationType = MMDrawerAnimationTypeSlide;
                     else if ([animationTypeString isEqualToString:@"slideAndScale"]) animationType = MMDrawerAnimationTypeSlideAndScale;
                     
                     [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = animationType;
                     [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = animationType;
                     
                   }
                   );
  }
}




@end
