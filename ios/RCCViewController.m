#import "RCCViewController.h"
#import "RCCNavigationController.h"
#import "RCCTabBarController.h"
#import "RCCDrawerController.h"
#import "RCTRootView.h"
#import "RCCManager.h"

@implementation RCCViewController

+ (UIViewController*)controllerWithLayout:(NSDictionary *)layout bridge:(RCTBridge *)bridge
{
  UIViewController* controller = nil;
  if (!layout) return nil;

  // get props
  if (!layout[@"props"]) return nil;
  if (![layout[@"props"] isKindOfClass:[NSDictionary class]]) return nil;
  NSDictionary *props = layout[@"props"];

  // get children
  if (!layout[@"children"]) return nil;
  if (![layout[@"children"] isKindOfClass:[NSArray class]]) return nil;
  NSArray *children = layout[@"children"];

  // create according to type
  NSString *type = layout[@"type"];
  if (!type) return nil;

  // regular view controller
  if ([type isEqualToString:@"ViewControllerIOS"])
  {
    controller = [[RCCViewController alloc] initWithProps:props children:children bridge:bridge];
  }

  // navigation controller
  if ([type isEqualToString:@"NavigationControllerIOS"])
  {
    controller = [[RCCNavigationController alloc] initWithProps:props children:children bridge:bridge];
  }

  // tab bar controller
  if ([type isEqualToString:@"TabBarControllerIOS"])
  {
    controller = [[RCCTabBarController alloc] initWithProps:props children:children bridge:bridge];
  }

  // side menu controller
  if ([type isEqualToString:@"DrawerControllerIOS"])
  {
    controller = [[RCCDrawerController alloc] initWithProps:props children:children bridge:bridge];
  }

  // register the controller if we have an id
  NSString *componentId = props[@"id"];
  if (controller && componentId)
  {
    [[RCCManager sharedIntance] registerController:controller componentId:componentId componentType:type];
  }

  return controller;
}

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge
{
  NSString *component = props[@"component"];
  if (!component) return nil;

  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:nil];
  if (!reactView) return nil;

  self = [super init];
  if (!self) return nil;

  self.view = reactView;
  return self;
}

- (instancetype)initWithComponent:(NSString *)component passProps:(NSDictionary *)passProps bridge:(RCTBridge *)bridge
{
  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:passProps];
  if (!reactView) return nil;

  self = [super init];
  if (!self) return nil;

  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = YES;

  self.view = reactView;
  return self;
}

@end
