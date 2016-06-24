#import "RCCManager.h"
#import "RCTBridge.h"
#import "RCTRedBox.h"
#import <Foundation/Foundation.h>

@interface RCCManager() <RCTBridgeDelegate>
@property (nonatomic, strong) NSMutableDictionary *modulesRegistry;
@property (nonatomic, strong) RCTBridge *sharedBridge;
@property (nonatomic, strong) NSURL *bundleURL;
@property (nonatomic, strong) NSMutableDictionary<String,id<UIViewControllerTransitioningDelegate>> *modalTransitioningDelegateRegistry;
@end

@implementation RCCManager

+ (instancetype)sharedInstance
{
  static RCCManager *sharedInstance = nil;
  static dispatch_once_t onceToken = 0;

  dispatch_once(&onceToken,^{
    if (sharedInstance == nil)
    {
      sharedInstance = [[RCCManager alloc] init];
    }
  });

  return sharedInstance;
}

+ (instancetype)sharedIntance
{
  return [RCCManager sharedInstance];
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

-(void)clearModuleRegistry
{
  [self.modulesRegistry removeAllObjects];
}

-(void)onRNReload
{
  id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
  appDelegate.window.rootViewController = nil;
  [self clearModuleRegistry];
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

-(void)unregisterController:(UIViewController*)vc
{
  if (vc == nil) return;
  
  for (NSString *key in [self.modulesRegistry allKeys])
  {
    NSMutableDictionary *componentsDic = self.modulesRegistry[key];
    for (NSString *componentID in [componentsDic allKeys])
    {
      UIViewController *tmpVc = componentsDic[componentID];
      if (tmpVc == vc)
      {
        [componentsDic removeObjectForKey:componentID];
      }
    }
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
  
  [self showSplashScreen];
}

-(void)showSplashScreen
{
  CGRect screenBounds = [UIScreen mainScreen].bounds;
  UIView *splashView = nil;
  
  NSString* launchStoryBoard = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchStoryboardName"];
  if (launchStoryBoard != nil)
  {//load the splash from the storyboard that's defined in the info.plist as the LaunchScreen
    @try
    {
      splashView = [[NSBundle mainBundle] loadNibNamed:launchStoryBoard owner:self options:nil][0];
      if (splashView != nil)
      {
        splashView.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
      }
    }
    @catch(NSException *e)
    {
      splashView = nil;
    }
  }
  else
  {//load the splash from the DEfault image or from LaunchImage in the xcassets
    CGFloat screenHeight = screenBounds.size.height;
    
    NSString* imageName = @"Default";
    if (screenHeight == 568)
      imageName = [imageName stringByAppendingString:@"-568h"];
    else if (screenHeight == 667)
      imageName = [imageName stringByAppendingString:@"-667h"];
    else if (screenHeight == 736)
      imageName = [imageName stringByAppendingString:@"-736h"];
    
    //xcassets LaunchImage files
    UIImage *image = [UIImage imageNamed:imageName];
    if (image == nil)
    {
      imageName = @"LaunchImage";
      
      if (screenHeight == 480)
        imageName = [imageName stringByAppendingString:@"-700"];
      if (screenHeight == 568)
        imageName = [imageName stringByAppendingString:@"-700-568h"];
      else if (screenHeight == 667)
        imageName = [imageName stringByAppendingString:@"-800-667h"];
      else if (screenHeight == 736)
        imageName = [imageName stringByAppendingString:@"-800-Portrait-736h"];
      
      image = [UIImage imageNamed:imageName];
    }
    
    if (image != nil)
    {
      splashView = [[UIImageView alloc] initWithImage:image];
    }
  }
  
  if (splashView != nil)
  {
    UIViewController *splashVC = [[UIViewController alloc] init];
    splashVC.view = splashView;
    
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = splashVC;
    [appDelegate.window makeKeyAndVisible];
  }
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

#pragma mark - custom transitioning delegates

- (id<UIViewControllerTransitioningDelegate>) getModalTransitioningDelegateForId:(NSString*) delegateId {
    return [self.modalTransitioningDelegateRegistry objectForKey:delegateId];
}
- (void)registerModalTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)delegate forDelegateId:(NSString *) component {
    if (self.modalTransitioningDelegateRegistry == nil) {
        self.modalTransitioningDelegateRegistry = [NSMutableDictionary dictionary];
    }
    self.modalTransitioningDelegateRegistry[component] = delegate;
}

@end
