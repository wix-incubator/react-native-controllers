#import <UIKit/UIKit.h>
#import "RCTBridge.h"

@interface RCCViewController : UIViewController

+ (UIViewController*)controllerWithLayout:(NSDictionary *)layout bridge:(RCTBridge *)bridge;

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge;
- (instancetype)initWithComponent:(NSString *)component bridge:(RCTBridge *)bridge;

@end