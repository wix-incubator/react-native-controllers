#import "RCCTabBarController.h"
#import "RCCViewController.h"
#import "RCTConvert.h"

@implementation RCCTabBarController

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL
{
  id tabBarItems = [params objectForKey:@"TabBarControllerIOS.Item"];
  if (!tabBarItems) return nil;
  if (![tabBarItems isKindOfClass:[NSArray class]]) tabBarItems = [NSArray arrayWithObject:tabBarItems];
  
  self = [super init];
  if (!self) return nil;
  
  NSMutableArray *viewControllers = [NSMutableArray array];
  
  // go over all the tab bar items
  for (NSDictionary *itemParams in tabBarItems)
  {
    // create the view controller
    UIViewController *viewController = [self getItemViewController:itemParams
                                                            params:params
                                                            bridge:bridge
                                                         bundleURL:bundleURL];
    if (!viewController) continue;
    
    // create the tab icon and title
    NSString *title = [itemParams objectForKey:@"_title"];
    UIImage *iconImage = nil;
    UIImage *iconImageSelected = nil;
    NSString *icon = [itemParams objectForKey:@"_icon"];
    NSString *iconSelected = [NSString stringWithFormat:@"%@_selected", icon];

    if (icon) iconImage = [RCTConvert UIImage:icon];
    if (iconSelected) iconImageSelected = [RCTConvert UIImage:iconSelected];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:iconImage tag:0];
    viewController.tabBarItem.selectedImage = iconImageSelected;
    
    [viewControllers addObject:viewController];
  }
  
  // replace the tabs
  self.viewControllers = viewControllers;
  
  return self;
}

- (UIViewController *)getItemViewController:(NSDictionary *)itemParams
                                     params:(NSDictionary *)params
                                     bridge:(RCTBridge *)bridge
                                  bundleURL:(NSURL *)bundleURL
{
  for (NSString *key in itemParams)
  {
    if (![key hasPrefix:@"_"]) return [RCCViewController controllerWithType:key
                                                                     params:[itemParams objectForKey:key]
                                                                     bridge:bridge
                                                                  bundleURL:bundleURL];
  }
  
  // none found
  return nil;
}

@end