#import "RCCNavigationController.h"
#import "RCCViewController.h"
#import "RCCManager.h"
#import "RCTEventDispatcher.h"
#import "RCTConvert.h"


@implementation RCCNavigationController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge
{
  NSString *component = props[@"component"];
  if (!component) return nil;

  NSDictionary *passProps = props[@"passProps"];
  NSDictionary *navigatorStyle = props[@"style"];

  RCCViewController *viewController = [[RCCViewController alloc] initWithComponent:component passProps:passProps navigatorStyle:navigatorStyle bridge:bridge];
  if (!viewController) return nil;

  NSString *title = props[@"title"];
  if (title) viewController.title = title;

  self = [super initWithRootViewController:viewController];
  if (!self) return nil;

  if (navigatorStyle)
  {
    NSNumber *navBarTranslucent = navigatorStyle[@"navBarTranslucent"];
    if (navBarTranslucent)
    {
      self.navigationBar.translucent = [navBarTranslucent boolValue];
    }

    NSString *navBarBackgroundColor = navigatorStyle[@"navBarBackgroundColor"];
    if (navBarBackgroundColor)
    {
      UIColor *color = [RCTConvert UIColor:navBarBackgroundColor];
      self.navigationBar.barTintColor = color;
    }

    NSString *navBarButtonColor = navigatorStyle[@"navBarButtonColor"];
    if (navBarButtonColor)
    {
      UIColor *color = [RCTConvert UIColor:navBarButtonColor];
      self.navigationBar.tintColor = color;
    }

    NSString *navBarTextColor = navigatorStyle[@"navBarTextColor"];
    if (navBarTextColor)
    {
      UIColor *color = [RCTConvert UIColor:navBarTextColor];
      [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
    }

    NSNumber *navBarBlur = navigatorStyle[@"navBarBlur"];
    if (navBarBlur && [navBarBlur boolValue])
    {
      [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
      self.navigationBar.shadowImage = [UIImage new];

      UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
      CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
      blur.frame = CGRectMake(0, -1 * statusBarFrame.size.height, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + statusBarFrame.size.height);
      [self.navigationBar insertSubview:blur atIndex:0];
    }
  }

  return self;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge
{
  BOOL animated = actionParams[@"animated"] ? [actionParams[@"animated"] boolValue] : YES;

  // push
  if ([performAction isEqualToString:@"push"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      NSString *component = actionParams[@"component"];
      if (!component) return;

      NSDictionary *passProps = actionParams[@"passProps"];
      NSDictionary *navigatorStyle = actionParams[@"style"];

      RCCViewController *viewController = [[RCCViewController alloc] initWithComponent:component passProps:passProps navigatorStyle:navigatorStyle bridge:bridge];

      NSString *title = actionParams[@"title"];
      if (title) viewController.title = title;

      [self pushViewController:viewController animated:animated];

    });
    return;
  }

  // pop
  if ([performAction isEqualToString:@"pop"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      [self popViewControllerAnimated:animated];

    });
    return;
  }

  // setLeftButton
  if ([performAction isEqualToString:@"setLeftButton"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      NSString *title = actionParams[@"title"];
      if (!title) return;

      UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButtonPresss:)];
      barButtonItem.accessibilityIdentifier = actionParams[@"onPress"];
      self.visibleViewController.navigationItem.leftBarButtonItem = barButtonItem;

    });
    return;
  }

}

-(void)onLeftButtonPresss:(UIBarButtonItem*)barButtonItem
{
  if (!barButtonItem.accessibilityIdentifier) return;
  [[[RCCManager sharedIntance] getBridge].eventDispatcher sendAppEventWithName:barButtonItem.accessibilityIdentifier body:@{}];
}

@end
