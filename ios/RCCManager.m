#import "RCCManager.h"
#import "RCTBridge.h"
#import "RCTRedBox.h"
#import <Foundation/Foundation.h>

@interface RCCManager() <RCTBridgeDelegate>
@property (nonatomic, strong) NSMutableDictionary *modulesRegistry;
@property (nonatomic, strong) RCTBridge *sharedBridge;
@property (nonatomic, strong) NSURL *bundleURL;
@end

@implementation RCCManager

+ (instancetype)sharedIntance
{
  static RCCManager *sharedIntance = nil;
  static dispatch_once_t onceToken = 0;

  dispatch_once(&onceToken,^{
    if (sharedIntance == nil)
    {
      sharedIntance = [[RCCManager alloc] init];
    }
  });

  return sharedIntance;
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.modulesRegistry = [@{} mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRNReload) name:RCTReloadNotification object:nil];
  }
  return self;
}

-(void)onRNReload
{
  id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
  appDelegate.window.rootViewController = nil;
  [self.modulesRegistry removeAllObjects];
}

-(void)registerController:(UIViewController*)controller componentId:(NSString*)componentId componentType:(NSString*)componentType
{
  if (controller == nil || componentId == nil)
  {
    return;
  }

  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic == nil)
  {
    componentsDic = [@{} mutableCopy];
    self.modulesRegistry[componentType] = componentsDic;
  }

  /*
  TODO: we really want this error, but we need to unregister controllers when they dealloc
  if (componentsDic[componentId])
  {
    [self.sharedBridge.redBox showErrorMessage:[NSString stringWithFormat:@"Controllers: controller with id %@ is already registered. Make sure all of the controller id's you use are unique.", componentId]];
  }
  */
   
  componentsDic[componentId] = controller;
}

-(void)unregisterController:(NSString*)componentId componentType:(NSString*)componentType
{
  if (componentType == nil || componentId == nil) return;
  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic != nil)
  {
    [componentsDic removeObjectForKey:componentId];
  }
}

-(id)getControllerWithId:(NSString*)componentId componentType:(NSString*)componentType
{
  if (componentId == nil)
  {
    return nil;
  }

  id component = nil;

  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic != nil)
  {
    component = componentsDic[componentId];
  }

  return component;
}

-(void)initBridgeWithBundleURL:(NSURL *)bundleURL
{
  if (self.sharedBridge) return;
  
  self.bundleURL = bundleURL;
  self.sharedBridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
}

-(RCTBridge*)getBridge
{
  return self.sharedBridge;
}

#pragma mark - RCTBridgeDelegate methods

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return self.bundleURL;
}

@end
