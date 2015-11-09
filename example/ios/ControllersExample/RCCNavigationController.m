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
  
  self = [super initWithRootViewController:rootViewController];
  if (!self) return nil;
  
  NSString *title = [params objectForKey:@"_title"];
  if (title) self.title = title;
  
  return self;
}

@end