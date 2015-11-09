#import <UIKit/UIKit.h>

@interface RCCRootController : NSObject

+ (UIViewController*)controllerWithBundleURL:(NSURL *)bundleURL
                                   layoutURL:(NSURL *)layoutURL
                           initialProperties:(NSDictionary *)initialProperties
                               launchOptions:(NSDictionary *)launchOptions;

@end