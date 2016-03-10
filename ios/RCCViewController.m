#import "RCCViewController.h"
#import "RCCNavigationController.h"
#import "RCCTabBarController.h"
#import "RCCDrawerController.h"
#import "RCTRootView.h"
#import "RCCManager.h"
#import "RCTConvert.h"

const NSInteger BLUR_STATUS_TAG = 78264801;
const NSInteger BLUR_NAVBAR_TAG = 78264802;

@interface RCCViewController()
@property (nonatomic) BOOL _hidesBottomBarWhenPushed;
@property (nonatomic) BOOL _statusBarHideWithNavBar;
@end

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
  self.view = reactView;
  
  self.edgesForExtendedLayout = UIRectEdgeNone; // default
  self.automaticallyAdjustsScrollViewInsets = NO; // default
  
  self.navigatorStyle = [NSMutableDictionary dictionaryWithDictionary:navigatorStyle];
  
  [self setStyleOnInit];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self setStyleOnAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

// most styles should be set here since when we pop a view controller that changed them
// we want to reset the style to what we expect (so we need to reset on every willAppear)
- (void)setStyleOnAppear
{
  NSString *navBarBackgroundColor = self.navigatorStyle[@"navBarBackgroundColor"];
  if (navBarBackgroundColor)
  {
    UIColor *color = [RCTConvert UIColor:navBarBackgroundColor];
    self.navigationController.navigationBar.barTintColor = color;
  }
  else
  {
    self.navigationController.navigationBar.barTintColor = nil;
  }
  
  NSString *navBarTextColor = self.navigatorStyle[@"navBarTextColor"];
  if (navBarTextColor)
  {
    UIColor *color = [RCTConvert UIColor:navBarTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
  }
  else
  {
    [self.navigationController.navigationBar setTitleTextAttributes:nil];
  }
  
  NSString *navBarButtonColor = self.navigatorStyle[@"navBarButtonColor"];
  if (navBarButtonColor)
  {
    UIColor *color = [RCTConvert UIColor:navBarButtonColor];
    self.navigationController.navigationBar.tintColor = color;
  }
  else
  {
    self.navigationController.navigationBar.tintColor = nil;
  }
  
  NSNumber *navBarHidden = self.navigatorStyle[@"navBarHidden"];
  BOOL navBarHiddenBool = navBarHidden ? [navBarHidden boolValue] : NO;
  if (self.navigationController.navigationBarHidden != navBarHiddenBool)
  {
    [self.navigationController setNavigationBarHidden:navBarHiddenBool animated:YES];
  }
  
  NSNumber *navBarHideOnScroll = self.navigatorStyle[@"navBarHideOnScroll"];
  BOOL navBarHideOnScrollBool = navBarHideOnScroll ? [navBarHideOnScroll boolValue] : NO;
  if (navBarHideOnScrollBool)
  {
    self.navigationController.hidesBarsOnSwipe = YES;
  }
  else
  {
    self.navigationController.hidesBarsOnSwipe = NO;
  }
  
  NSNumber *drawUnderNavBar = self.navigatorStyle[@"drawUnderNavBar"];
  BOOL drawUnderNavBarBool = drawUnderNavBar ? [drawUnderNavBar boolValue] : NO;
  if (drawUnderNavBarBool)
  {
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout |= UIRectEdgeTop;
  }
  else
  {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout &= ~UIRectEdgeTop;
  }
  
  NSNumber *drawUnderTabBar = self.navigatorStyle[@"drawUnderTabBar"];
  BOOL drawUnderTabBarBool = drawUnderTabBar ? [drawUnderTabBar boolValue] : NO;
  if (drawUnderTabBarBool)
  {
    self.edgesForExtendedLayout |= UIRectEdgeBottom;
  }
  else
  {
    self.edgesForExtendedLayout &= ~UIRectEdgeBottom;
  }
  
  NSNumber *statusBarBlur = self.navigatorStyle[@"statusBarBlur"];
  BOOL statusBarBlurBool = statusBarBlur ? [statusBarBlur boolValue] : NO;
  if (statusBarBlurBool)
  {
    if (![self.view viewWithTag:BLUR_STATUS_TAG])
    {
      UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
      blur.frame = [[UIApplication sharedApplication] statusBarFrame];
      blur.tag = BLUR_STATUS_TAG;
      [self.view addSubview:blur];
    }
  }
  
  NSNumber *navBarBlur = self.navigatorStyle[@"navBarBlur"];
  BOOL navBarBlurBool = navBarBlur ? [navBarBlur boolValue] : NO;
  if (navBarBlurBool)
  {
    if (![self.navigationController.navigationBar viewWithTag:BLUR_NAVBAR_TAG])
    {
      [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
      self.navigationController.navigationBar.shadowImage = [UIImage new];
      UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
      CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
      blur.frame = CGRectMake(0, -1 * statusBarFrame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + statusBarFrame.size.height);
      blur.userInteractionEnabled = NO;
      [self.navigationController.navigationBar insertSubview:blur atIndex:0];
    }
  }
  else
  {
    UIView *blur = [self.navigationController.navigationBar viewWithTag:BLUR_NAVBAR_TAG];
    if (blur)
    {
      [blur removeFromSuperview];
      [self.navigationController.navigationBar setShadowImage:nil];
      [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
  }
}

// only styles that can't be set on willAppear should be set here
- (void)setStyleOnInit
{
  NSNumber *tabBarHidden = self.navigatorStyle[@"tabBarHidden"];
  BOOL tabBarHiddenBool = tabBarHidden ? [tabBarHidden boolValue] : NO;
  if (tabBarHiddenBool)
  {
    self._hidesBottomBarWhenPushed = YES;
  }
  else
  {
    self._hidesBottomBarWhenPushed = NO;
  }
  
  NSNumber *statusBarHideWithNavBar = self.navigatorStyle[@"statusBarHideWithNavBar"];
  BOOL statusBarHideWithNavBarBool = statusBarHideWithNavBar ? [statusBarHideWithNavBar boolValue] : NO;
  if (statusBarHideWithNavBarBool)
  {
    self._statusBarHideWithNavBar = YES;
  }
  else
  {
    self._statusBarHideWithNavBar = NO;
  }
}

- (BOOL)hidesBottomBarWhenPushed
{
  if (!self._hidesBottomBarWhenPushed) return NO;
  return (self.navigationController.topViewController == self);
}

- (BOOL)prefersStatusBarHidden
{
  if (self._statusBarHideWithNavBar)
  {
    return self.navigationController.isNavigationBarHidden;
  }
  else
  {
    return NO;
  }
}

@end
