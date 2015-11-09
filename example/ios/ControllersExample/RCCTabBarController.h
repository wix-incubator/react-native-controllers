#import <UIKit/UIKit.h>
#import "RCTBridge.h"

@interface RCCTabBarController : UITabBarController

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL;

@end