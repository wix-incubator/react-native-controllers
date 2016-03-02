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

  NSDictionary *passProps = props[@"passProps"];
  NSDictionary *navigatorStyle = props[@"style"];

  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:passProps];
  if (!reactView) return nil;

  self = [super init];
  if (!self) return nil;

  [self commonInit:reactView navigatorStyle:navigatorStyle];

  return self;
}

- (instancetype)initWithComponent:(NSString *)component passProps:(NSDictionary *)passProps navigatorStyle:(NSDictionary*)navigatorStyle bridge:(RCTBridge *)bridge
{
  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:passProps];
  if (!reactView) return nil;

  self = [super init];
  if (!self) return nil;

  [self commonInit:reactView navigatorStyle:navigatorStyle];

  return self;
}

- (void)commonInit:(RCTRootView*)reactView navigatorStyle:(NSDictionary*)navigatorStyle
{
  self.navBarHidden = NO;

  self.edgesForExtendedLayout = UIRectEdgeBottom;
  //self.automaticallyAdjustsScrollViewInsets = NO;

  self.view = reactView;

  if (navigatorStyle)
  {
    NSNumber *navBarBlur = navigatorStyle[@"navBarBlur"];
    if (navBarBlur && [navBarBlur boolValue])
    {
      self.edgesForExtendedLayout = UIRectEdgeAll;
    }

    NSNumber *statusBarBlur = navigatorStyle[@"statusBarBlur"];
    if (statusBarBlur)
    {
      if (!navBarBlur || ![navBarBlur boolValue])
      {
        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        blur.frame = [[UIApplication sharedApplication] statusBarFrame];
        [reactView addSubview:blur];
      }
    }

    NSNumber *navBarHidden = navigatorStyle[@"navBarHidden"];
    if (navBarHidden)
    {
      self.navBarHidden = [navBarHidden boolValue];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if (self.navigationController.navigationBarHidden != self.navBarHidden)
  {
    [self.navigationController setNavigationBarHidden:self.navBarHidden animated:YES];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

@end
