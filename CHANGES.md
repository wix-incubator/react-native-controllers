# Breaking Changes

### 1.3.0

* `[RCCManager sharedIntance]` typo was fixed and renamed to `[RCCManager sharedInstance]`. When you bootstrap your project in `AppDelegate.m` you'll have to make this minor change:
```objc
[[RCCManager sharedInstance] initBridgeWithBundleURL:jsCodeLocation];
```
