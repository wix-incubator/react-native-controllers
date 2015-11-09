#import "RCCViewController.h"
#import "RCCNavigationController.h"
#import "RCCTabBarController.h"
#import "RCTRootView.h"

@implementation RCCViewController

+ (UIViewController*)controllerWithType:(NSString *)type
                                 params:(NSDictionary *)params
                                 bridge:(RCTBridge *)bridge
                              bundleURL:(NSURL *)bundleURL

{
  // regular view controller
  if ([type isEqualToString:@"ViewControllerIOS"])
  {
    return [[RCCViewController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // navigation controller
  if ([type isEqualToString:@"NavigationControllerIOS"])
  {
    return [[RCCNavigationController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // tab bar controller
  if ([type isEqualToString:@"TabBarControllerIOS"])
  {
    return [[RCCTabBarController alloc] initWithParams:params bridge:bridge bundleURL:bundleURL];
  }
  
  // unknown, error
  return nil;
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