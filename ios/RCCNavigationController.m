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
  
  self.navigationBar.translucent = NO; // default

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
      
      // merge the navigatorStyle of our parent
      if ([self.topViewController isKindOfClass:[RCCViewController class]])
      {
        RCCViewController *parent = (RCCViewController*)self.topViewController;
        NSMutableDictionary *mergedStyle = [NSMutableDictionary dictionaryWithDictionary:parent.navigatorStyle];
        [mergedStyle addEntriesFromDictionary:navigatorStyle];
        navigatorStyle = mergedStyle;
      }

      RCCViewController *viewController = [[RCCViewController alloc] initWithComponent:component passProps:passProps navigatorStyle:navigatorStyle bridge:bridge];

      NSString *title = actionParams[@"title"];
      if (title) viewController.title = title;
      
      NSString *backButtonTitle = actionParams[@"backButtonTitle"];
      if (backButtonTitle)
      {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        
        self.topViewController.navigationItem.backBarButtonItem = backItem;
      }
      else
      {
        self.topViewController.navigationItem.backBarButtonItem = nil;
      }

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
