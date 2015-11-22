#import "RCCViewController.h"
#import "RCCNavigationController.h"
#import "RCCTabBarController.h"
#import "RCCSideMenuController.h"
#import "RCTRootView.h"
#import "RCCManager.h"

@implementation RCCViewController

+ (UIViewController*)controllerWithType:(NSString *)type
                                 params:(NSDictionary *)params
                                 bridge:(RCTBridge *)bridge
                              bundleURL:(NSURL *)bundleURL
{
  UIViewController* controller = nil;
  
  // regular view controller
  if ([type isEqualToString:@"ViewControllerIOS"])
  {
    controller = [[RCCViewController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // navigation controller
  else if ([type isEqualToString:@"NavigationControllerIOS"])
  {
    controller = [[RCCNavigationController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // tab bar controller
  else if ([type isEqualToString:@"TabBarControllerIOS"])
  {
    controller = [[RCCTabBarController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // side menu controller
  else if ([type isEqualToString:@"SideMenuControllerIOS"])
  {
    controller = [[RCCSideMenuController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // unknown, error
  else {
    
    return nil;
  }
  
  [[RCControllersRegistry sharedIntance] registerController:controller componentID:params[@"_id"] componentType:type];
  
  return controller;
}

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL
{
  NSString *component = [params objectForKey:@"_component"];
  if (!component) return nil;
  
  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:nil];
  if (!reactView) return nil;
  
  self = [super init];
  if (!self) return nil;
  
  self.view = reactView;
  return self;
}

@end