#import <UIKit/UIKit.h>
#import "RCTBridge.h"

@interface RCCTabBarController : UITabBarController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge;
- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge completion:(void (^)(void))completion;

@end

@interface RCCTabBarController (UITabBarDelegate) <UITabBarDelegate>
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end

