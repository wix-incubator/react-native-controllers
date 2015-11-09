#import <UIKit/UIKit.h>
#import "RCTBridge.h"

@interface RCCViewController : UIViewController

+ (UIViewController*)controllerWithType:(NSString *)type
                                 params:(NSDictionary *)params
                                 bridge:(RCTBridge *)bridge
                              bundleURL:(NSURL *)bundleURL;

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL;

@end