#import "RCCRootController.h"
#import "RCCViewController.h"
#import "XMLDictionary.h"

@implementation RCCRootController

+ (UIViewController*)controllerWithBundleURL:(NSURL *)bundleURL
                                   layoutURL:(NSURL *)layoutURL
                           initialProperties:(NSDictionary *)initialProperties
                               launchOptions:(NSDictionary *)launchOptions
{
  // read the layout
  NSData *layoutData = [NSData dataWithContentsOfURL:layoutURL];
  if (!layoutData) return nil;
  NSDictionary *layout = [NSDictionary dictionaryWithXMLData:layoutData];
  if (!layout) return nil;
  
  // create the bridge
  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:bundleURL
                                            moduleProvider:nil
                                             launchOptions:launchOptions];
  
  // parse the layout
  for (NSString *key in layout)
  {
    if (![key hasPrefix:@"_"]) return [RCCViewController controllerWithType:key
                                                                     params:[layout objectForKey:key]
                                                                     bridge:bridge
                                                                  bundleURL:bundleURL];
  }
  
  // error
  return nil;
}

@end