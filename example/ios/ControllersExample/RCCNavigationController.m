#import "RCCNavigationController.h"
#import "RCTRootView.h"

@implementation RCCNavigationController

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL
{
  NSString *component = [params objectForKey:@"_component"];
  if (!component) return nil;
  
  RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:nil];
  if (!reactView) return nil;
  
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = reactView;
  
  NSString *title = [params objectForKey:@"_title"];
  if (title) rootViewController.title = title;
  
  self = [super initWithRootViewController:rootViewController];
  if (!self) return nil;
  
  return self;
}

@end