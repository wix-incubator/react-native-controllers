#import "RCCTabBarController.h"
#import "RCCViewController.h"
#import "RCTConvert.h"

@implementation RCCTabBarController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge
{
  self = [super init];
  if (!self) return nil;
  
  self.tabBar.translucent = YES; // default

  NSMutableArray *viewControllers = [NSMutableArray array];

  // go over all the tab bar items
  for (NSDictionary *tabItemLayout in children)
  {
    // make sure the layout is valid
    if (![tabItemLayout[@"type"] isEqualToString:@"TabBarControllerIOS.Item"]) continue;
    if (!tabItemLayout[@"props"]) continue;

    // get the view controller inside
    if (!tabItemLayout[@"children"]) continue;
    if (![tabItemLayout[@"children"] isKindOfClass:[NSArray class]]) continue;
    if ([tabItemLayout[@"children"] count] < 1) continue;
    NSDictionary *childLayout = tabItemLayout[@"children"][0];
    UIViewController *viewController = [RCCViewController controllerWithLayout:childLayout bridge:bridge];
    if (!viewController) continue;

    // create the tab icon and title
    NSString *title = tabItemLayout[@"props"][@"title"];
    UIImage *iconImage = nil;
    id icon = tabItemLayout[@"props"][@"icon"];
    if (icon) iconImage = [RCTConvert UIImage:icon];
    UIImage *iconImageSelected = nil;
    id selectedIcon = tabItemLayout[@"props"][@"selectedIcon"];
    if (selectedIcon) iconImageSelected = [RCTConvert UIImage:selectedIcon];

    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:iconImage tag:0];
    viewController.tabBarItem.selectedImage = iconImageSelected;

    // create badge
    NSObject *badge = tabItemLayout[@"props"][@"badge"];

    if(badge == nil || [badge isEqual:[NSNull null]]) {
      viewController.tabBarItem.badgeValue = nil;
    } else {
      viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", badge];
    }

    [viewControllers addObject:viewController];
  }

  // replace the tabs
  self.viewControllers = viewControllers;

  return self;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge completion:(void (^)(void))completion
{
    if ([performAction isEqualToString:@"setBadge"])
    {
      int i = [actionParams[@"tabIndex"] integerValue];
      
      if([self.viewControllers count] > i) {
        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
        
        NSObject *badge = actionParams[@"badge"];
        
        if(badge == nil || [badge isEqual:[NSNull null]]) {
          viewController.tabBarItem.badgeValue = nil;
        } else {
          viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", badge];
        }
      }
    }

    if ([performAction isEqualToString:@"setTabBarHidden"])
    {
        BOOL hidden = [actionParams[@"hidden"] boolValue];
        [UIView animateWithDuration: ([actionParams[@"animated"] boolValue] ? 0.45 : 0)
                              delay: 0
             usingSpringWithDamping: 0.75
              initialSpringVelocity: 0
                            options: (hidden ? UIViewAnimationOptionCurveEaseIn : UIViewAnimationOptionCurveEaseOut)
                         animations:^()
         {
             self.tabBar.transform = hidden ? CGAffineTransformMakeTranslation(0, self.tabBar.frame.size.height) : CGAffineTransformIdentity;
         }
                         completion:^(BOOL finished)
        {
            if (completion != nil)
            {
                completion();
            }
        }];
        return;
    }
}

@end
