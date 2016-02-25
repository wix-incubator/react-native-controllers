#import "RCCNavigationController.h"
#import "RCCViewController.h"
#import "RCCManager.h"
#import "RCTEventDispatcher.h"


@implementation RCCNavigationController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge
{
  NSString *component = props[@"component"];
  if (!component) return nil;

  NSDictionary *passProps = props[@"passProps"];
  UIViewController *viewController = [[RCCViewController alloc] initWithComponent:component passProps:passProps bridge:bridge];
  if (!viewController) return nil;

  NSString *title = props[@"title"];
  if (title) viewController.title = title;

  self = [super initWithRootViewController:viewController];
  if (!self) return nil;

  /*
  // blur background
  [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationBar.shadowImage = [UIImage new];

  UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
  blur.frame = CGRectMake(0, -20, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + 20);
  [self.navigationBar insertSubview:blur atIndex:0];
  */

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
      UIViewController *viewController = [[RCCViewController alloc] initWithComponent:component passProps:passProps bridge:bridge];

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
