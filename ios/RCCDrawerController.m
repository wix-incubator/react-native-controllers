#import "RCCDrawerController.h"
#import "RCCViewController.h"
#import "MMExampleDrawerVisualStateManager.h"

@implementation RCCDrawerController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge
{
  // center
  if ([children count] < 1) return nil;
  UIViewController *centerViewController = [RCCViewController controllerWithLayout:children[0] bridge:bridge];

  // left
  UIViewController *leftViewController = nil;
  NSString *componentLeft = props[@"componentLeft"];
  NSDictionary *passPropsLeft = props[@"passPropsLeft"];
  if (componentLeft) leftViewController = [[RCCViewController alloc] initWithComponent:componentLeft passProps:passPropsLeft navigatorStyle:nil bridge:bridge];

  // right
  UIViewController *rightViewController = nil;
  NSString *componentRight = props[@"componentRight"];
  NSDictionary *passPropsRight = props[@"passPropsRight"];
  if (componentRight) rightViewController = [[RCCViewController alloc] initWithComponent:componentRight passProps:passPropsRight navigatorStyle:nil bridge:bridge];

  self = [super initWithCenterViewController:centerViewController
                    leftDrawerViewController:leftViewController
                   rightDrawerViewController:rightViewController];

  self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
  self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

  [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
    MMDrawerControllerDrawerVisualStateBlock block;
    block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
    if (block) {
      block(drawerController, drawerSide, percentVisible);
    }
  }];

  if (!self) return nil;
  return self;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge
{
  MMDrawerSide side = MMDrawerSideLeft;
  if ([actionParams[@"side"] isEqualToString:@"right"]) side = MMDrawerSideRight;
  BOOL animated = actionParams[@"animated"] ? [actionParams[@"animated"] boolValue] : YES;

  // open
  if ([performAction isEqualToString:@"open"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      [self openDrawerSide:side animated:animated completion:nil];

    });
    return;
  }

  // close
  if ([performAction isEqualToString:@"close"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      if (self.openSide == side) {
        [self closeDrawerAnimated:animated completion:nil];
      }

    });
    return;
  }

  // toggle
  if ([performAction isEqualToString:@"toggle"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      [self toggleDrawerSide:side animated:animated completion:nil];

    });
    return;
  }

  // setStyle
  if ([performAction isEqualToString:@"setStyle"])
  {
    dispatch_async(dispatch_get_main_queue(), ^{

      if (actionParams[@"animationType"]) {
        MMDrawerAnimationType animationType = MMDrawerAnimationTypeNone;
        NSString *animationTypeString = actionParams[@"animationType"];

        if ([animationTypeString isEqualToString:@"door"]) animationType = MMDrawerAnimationTypeSwingingDoor;
        else if ([animationTypeString isEqualToString:@"parallax"]) animationType = MMDrawerAnimationTypeParallax;
        else if ([animationTypeString isEqualToString:@"slide"]) animationType = MMDrawerAnimationTypeSlide;
        else if ([animationTypeString isEqualToString:@"slideAndScale"]) animationType = MMDrawerAnimationTypeSlideAndScale;

        [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = animationType;
        [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = animationType;
      }

    });
    return;
  }

}


@end
