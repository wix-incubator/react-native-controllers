# React Native Controllers

`react-native-controllers` is a [React Native](https://facebook.github.io/react-native/) npm extension package for iOS which provides a completely native skeleton for iOS apps, allowing you to easily wrap core native UI components without compromising on the native experience. Key benefits:

* Truly native navigation (instead of the JS-based [`Navigator`](https://facebook.github.io/react-native/docs/navigator-comparison.html))
* Truly native side menu drawer (instead of the JS-based alternatives available today)
* Smoother animations, improved performance and look and feel that matches the OS for all iOS versions

Without `react-native-controllers`, iOS skeleton components such as [`UINavigatorController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/) or a [side menu drawer](https://www.cocoacontrols.com/search?q=drawer) are challenging to implement natively. This forces developers to compromise on user experience to use React Native.
`react-native-controllers` simplifies this by re-introducing [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) into the React Native stack.

> Note: The main purpose of this package is to generate discussion around difficulties we found wrapping native iOS skeleton components with React Native. Look at this as a thought experiment with a proposed solution. If you have alternate ideas please share your feedback!

## Table of contents

* [Why do we need this package?](#why-do-we-need-this-package)
* [What sacrifices did we make?](#what-sacrifices-did-we-make)
* [Installation](#installation)
* [Usage](#usage)
* [Available view controllers](#available-view-controllers)
* [Credits](#credits)
* [License](#license)

## Why do we need this package?

If you're already convinced you need this package, you can skip straight to [Installation](#installation). If not, brace yourself for a long read.

##### First, what's so great about React Native?

At Wix, we came to React Native from a codebase of two separate fully native stacks - one for iOS (ObjectiveC) and one for Android (Java). The main benefits React Native brings to such an environment are:

 * OTA business logic updates (fix bugs in the JS bundle without going through the app stores)
 * Sharing business logic between iOS, Android and even web counterparts ([demolishing silos](http://techcrunch.com/2015/08/26/facebook-react-native/))
 * Improving development velocity and introducing more people in the organization to app development
 * Maintaining our existing high level of UX since our entire UI is fully native and implemented separately

The last point is critical and what prevented us from adopting many of the cross-platform mobile technologies that popped up in recent years. One of the premises of React Native is that you can keep using any native UI component and won't be required to make UX compromises.

##### But wait.. the UX compromises did come

After working with React Native we noticed that we were encouraged to make UX compromises in several places. Here are two examples:

 * Navigator - Originally happy to see [`NavigatorIOS`](https://facebook.github.io/react-native/docs/navigatorios.html#content), we were soon disappointed to see that Facebook [gave up on maintaining it](https://facebook.github.io/react-native/docs/navigator-comparison.html#content) and the recommendation is to use the pure-JS alternative [`Navigator`](https://facebook.github.io/react-native/docs/navigator.html#content). That seemed peculiar since using the native component for such a key element as navigation is obviously the superior UX choice. <br> There's a limit to how well you can fake it with pure JS and the small details like side swipe for back get lost. Also consider what happens if Apple decides to revamp the design of the navigation bar like they did between iOS 6 and 7. Will we really go to the length of providing two separate experiences to owners of different OS versions with the pure JS implementation?
 * Side menu drawer - The side menu is a popular UI pattern and some of our iOS apps use it. We looked for a React Native wrapper around one of the [many native iOS implementations](https://www.cocoacontrols.com/search?q=drawer). We were surprised to see that we found none, although React Native for iOS has been out at the time for over a year. The React Native component community is [thriving](https://react.parts/native) and there's a native wrapper for everything. There must be some underlying reason why all implementations for such a popular component were pure JS.

It's interesting to see that both examples revolve around components that are parts of the app skeleton. Why are skeleton components so challenging to implement with native elements?

##### Looking for the underlying challenge

Our first instinct for both of the examples listed above was *"Hey, great! Let's make these components ourselves! It's a great void to fill for the community."*

We dived into the `NavigatorIOS` [implementation](https://github.com/facebook/react-native/blob/master/React/Views/RCTNavigator.m) but things weren't as simple as we've hoped. The implementation is surprisingly complex and seems to have been done by someone very much proficient with the inner workings of the [UIKit](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/).

We've hit similar walls with the side menu. One of the main problems was that side menus are based on [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) and not [`UIView`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/). React Native steered our component to return a view.

Furthermore, let's take a look at the standard way React Native hooks into `AppDelegate`:

```objc
RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                    moduleName:@"DefaultProject"
                                             initialProperties:nil
                                                 launchOptions:launchOptions];
self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
UIViewController *rootViewController = [[UIViewController alloc] init];
rootViewController.view = rootView;
self.window.rootViewController = rootViewController;
```

The entire React Native component hierarchy is contained inside a view and this view is wrapped manually in a view controller. That pretty much summed up our problem. App skeletons in iOS are built from view controllers, but it wasn't obvious to us how those fit in within the React Native world.

##### Giving view controllers a prominent seat at the table

If our assumption is correct, then giving view controllers a more prominent seat at the table might make skeleton components easier to implement.

There are many ways to approach this, we've decided to start with a way that won't interfere with the inner-workings of React Native. A good start would be an optional [npm](https://www.npmjs.com/) package that would add this functionality on top.

With the standard way to use React Native, `RCTRootView` starts at the very top of your app hierarchy (filling the content of `rootViewController`). We wanted to move `RCTRootView` a little lower. The top of the app hierarchy will be filled with natively implemented view controllers. Inside every view controller, the content view could be a separate `RCTRootView`.

This means that instead of a single `RCTRootView`, our app will have several ones running in parallel. It turns out that this isn't a problem and is [supported out of the box](https://github.com/facebook/react-native/blob/master/React/Base/RCTRootView.h) by the framework. All you need to do is have a single `RCTBridge` that all of them will share. This gives all of these views the same JS execution context, which means they will easily be able to share variables and singletons.

Let's compare the two approaches with a simple two-tab app. [`UITabBarController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITabBarController_Class/) is a good candidate for a skeleton component since it's based primarily on view controllers:

![Comparison Diagram](http://i.imgur.com/Siyx0JU.png)

##### A few implementation details

The basis of the proposed approach is that the view controller layer is not implemented as traditional React Native components. Instead, they are implemented natively. We also want to make layouting very flexible so instead of having to write native ObjectiveC code inside Xcode to specify which view controllers you want, we prefer a declarative way.

The natural choice to define layouts is using XML. This implies that we need to add an additional XML layout file to the project that will be saved right next to the React Native JS bundle. The native package code will then parse this XML file and instantiate the native view controllers when the app is loaded.

The drawbacks of this external XML is that it's more difficult to update. React Native developers are used to updating everything though the JS bundle. This means the natural place for our XML is to be embedded inside the bundle. This makes for another natural choice for the XML flavor. It should be [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) to keep things familiar.

It isn't straightforward to use JSX for layouting things that aren't React components since JSX is [tightly coupled](https://facebook.github.io/react/docs/jsx-in-depth.html#the-transform) with React. Our somewhat hackish solution was to override `React` in the JS modules dedicated for defining view controllers.

##### TL;DR

We need this package because it allows us to *easily* wrap native components that are part of the app skeleton and rely on `UIViewController` instead of `UIView`. Some examples of these skeleton components are navigation, tabs and side menu drawer. Using this package we are able to use the original native components instead of compromising on pure JS alternatives.

## What sacrifices did we make?

By using the proposed approach, we made several scarifices that you should be aware of:

* **Predictable state "leaks" outside the JS realm** - One of the powerful concepts of React is that components can rely only on `props` and `state` and render themselves accordingly. This means the entire app state can be made predictable and contained within these inputs. Pushing this concept further, using frameworks like [Redux](https://github.com/rackt/redux) you can [time travel](https://www.youtube.com/watch?v=xsSnOQynTHs) to previous states - a supercharged debugging tool.<br><br>This concept holds as long as the entire app state is located in the JS realm. As you can guess, what we're doing is "leaking" crucial app state - like the entire navigation stack - into native components like `UINavigationController`. Since this state is not owned anymore by JS, you will not be able to time travel.<br><br>In our defense, time travel is a very foreign concept to native mobile development. State is expected to be held by native OS components, that's how the entire world of native mobile development works.

* **Lack of state synchronization between JS and native** - The other side of the same coin is whether we go to the trouble of synchronizing this state between the JS and native realms. This is theoretically possible, see the locking mechanism implemented in [`NavigatorIOS`](https://github.com/facebook/react-native/blob/master/React/Views/RCTNavigator.m). We chose in favor of simplifying the implementation and ignored this problem altogether.<br><br>In our defense, we're not sure how big of an issue this actually is. The standard native API for navigation changes in [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/#//apple_ref/occ/instm/UINavigationController/pushViewController:animated:) is asynchronous due to transition animations. When a controller pushes another, the point in time when the second controller is mounted isn't very well defined. The standard API doesn't provide a completion handler for this event.<br><br>We believe this decision can hold well for most common straightforward cases of in-app navigation. If we face more complicated cases, adding a completion handler to our components' push/pop JS interface may be an elegant solution.


## Installation

You need an iOS React Native project ([instructions on how to create one](https://facebook.github.io/react-native/docs/getting-started.html#quick-start))

1. Run `npm install react-native-controllers` in your project root
2. In Xcode, in Project Navigator (left pane), right-click on the `Libraries` > `Add files to [project name]` <br> Add `./node_modules/react-native-controllers/ios/ReactNativeControllers.xcodeproj` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-1))
3. In Xcode, in Project Navigator (left pane), click on your project (top) and select the `Build Phases` tab (right pane) <br> In the `Link Binary With Libraries` section add `libReactNativeControllers.a` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-2))
4. In Xcode, in Project Navigator (left pane), click on your project (top) and select the `Build Settings` tab (right pane) <br> In the `Header Search Paths` section add `$(SRCROOT)/../node_modules/react-native-controllers/ios` <br> Make sure on the right to mark this new path `recursive` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-3))

## Usage

Check out the iOS example project under [`./example`](example) to see everything in action.

### Step 1 - Update AppDelegate

Since `react-native-controllers` takes over the skeleton of your app, we're first going to change how React Native is invoked in `AppDelegate.m`. In Xcode, change your AppDelegate to look like this:

```objc
#import "AppDelegate.h"
#import "RCCManager.h" // RCC stands for ReaCtControllers

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  // OPTION 1 - load JS code from development server
  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];

  // OPTION 2 - load JS from pre-bundled file on disk
  // jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  // this is your new React Native invocation
  [[RCCManager sharedIntance] initBridgeWithBundleURL:jsCodeLocation];

  return YES;
}

@end
```

### Step 2 - Update index.ios.js

With React Native, every JS file in your project is a module. With `react-native-controllers`, you can have JS modules that deal with `ViewControllers` and you can have JS modules that deal with `Views` (these are the React Native modules that you're used to). It's not recommended to deal with both in the same JS module.

Roughly speaking, `ViewControllers` make the skeleton of your app and `Views` make the actual content of every screen. Since `index.ios.js` is where your skeleton is defined, this module will be dedicated to deal with `ViewControllers`. Normally, this would be the only module that does that and the rest of your JS files will be regular React Native files.

You can see a complete example of `index.ios.js` [here](example/index.ios.js). If you don't want the full explanation of what's going on in there, just skip to the next step.

##### Making a module deal with ViewControllers instead of Views

To allow you to use [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) to define your view controller hierarchy, we're going to have to hijack `React`. Don't worry, this hijack is local to this module only. That's why we don't mix the two types. Your other regular JS modules (that deal with Views) won't have this hijack.

To perform the hijack, define `React` on the top of the module like this:

```js
var Controllers = require('react-native-controllers');
var React = Controllers.hijackReact();
```

> Note: The React instance here is irregular. It can't do many of the things that the original class can, so keep its usage pretty close to our purpose.

##### Defining the view controller hierarchy

We tried to keep the syntax familiar. Define your view controller skeleton like this:

```jsx
var MoviesApp = Controllers.createClass({
  render: function() {
    return (
      <DrawerControllerIOS id="drawer" componentLeft="SideMenu" componentRight="SideMenu">
        <TabBarControllerIOS id="main">
          <TabBarControllerIOS.Item title="Movies" icon="home">
            <NavigationControllerIOS title="Welcome" component="MovieListScreen" id="movies" />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Search" icon="discover">
            <ViewControllerIOS component="SearchScreen" />
          </TabBarControllerIOS.Item>
        </TabBarControllerIOS>
      </DrawerControllerIOS>
    );
  },
});
```

> Note: In this hierarchy you can only use view controllers. You can't use your traditional React Native components. For a full list of all supported view controllers see the rest of this doc.

Some of the view controllers in the hierarchy will have to contain your views. These views are the regular React Native components that you're used to. You will normally define these components in a dedicated JS module - where `React` wasn't hijacked and you can use all of its goodness.

To hook up a view, use the `component` attribute of the view controller in the JSX and provide the registered name of the component. Every view that you use has to be registered using `AppRegistry.registerComponent()`. For example, the movie list screen content is defined in [`MovieListScreen.js`](example/MovieListScreen.js) and there it's also registered with:

```js
AppRegistry.registerComponent('MovieListScreen', () => MovieListScreen);
```

##### Require all the view components that you referenced

We have to tell the React Native bundler that we need the components that we just referenced. The easiest way to do this and make sure their JS files are included in our bundle, is to `require` them. You can add this right before you define your view controller hierarchy:

```js
// require all top level react components you refer to in the layout
require('./SideMenu');
require('./MovieListScreen');
require('./SearchScreen');
```

##### Register your controller and set it as root

Just like we register regular React Native view modules, we'll need to register the view controller module we've just defined. In the end of `index.ios.js` add the following lines:

```js
ControllerRegistry.registerController('MoviesApp', () => MoviesApp);

// this line makes the app actually start and initialize
ControllerRegistry.setRootController('MoviesApp');
```

The last line is the magic line that bootstraps our entire app. When you set your controller (that you've just defined in JS) as root with `ControllerRegistry.setRootController()`, behind the scenes the native code sets it as `appDelegate.window.rootViewController`. Here you can see that the module that you've just defined is actually a [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) and not a [`UIView`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/).

### Step 3 - Implement all top level components

The view controller hierarchy we've defined in `index.ios.js` references the top level screens of your app. These screens are regular React Native views. They are the exact same components you've been writing up until now.

In the previous step we've referenced 3 top level components: `SideMenu`, `MovieListScreen`, `SearchScreen`. The best practice is to implement each of them as its own JS module. You can see them implemented here: [`SideMenu.js`](example/SideMenu.js), [`MovieListScreen.js`](example/MovieListScreen.js), [`SearchScreen.js`](example/SearchScreen.js).

As you can see, these are standard React Native components. They don't require any special changes due to our package. The only requirement is that all of them are registered using React Native's `AppRegistry.registerComponent()`. Only top level components referenced by the view controller hierarchy need to be registered. Register them by adding the following line at the end:

```js
AppRegistry.registerComponent('MovieListScreen', () => MovieListScreen);
```

When implementing your components, you may need to interact with one of the view controllers. For example, create a button that pushes a new screen to the navigation controller. You have simple JS API for this purpose available by `require('react-native-controllers')`. This API is documented under the list of [available view controllers](#available-view-controllers).

## Available View Controllers

The package contains implementations for the following view controllers that you can use in your app skeleton:

 * [NavigationControllerIOS](#navigationcontrollerios) - Native navigator wrapper around [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/)
 * [DrawerControllerIOS](#drawercontrollerios) - Native side menu drawer wrapper around [`MMDrawerController`](https://github.com/mutualmobile/MMDrawerController)
 * [TabBarControllerIOS](#tabbarcontrollerios) - Native tabs wrapper around [`UITabBarController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITabBarController_Class/)
 * [ViewControllerIOS](#viewcontrollerios) - Generic empty view controller wrapper around [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/)

These wrappers are very simple. You can also add your own if you find missing React Native components that are based on `UIViewController` instead of `UIView`.

### NavigationControllerIOS

Native navigator wrapper around [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/). This view controller is a replacement for React Native's [`NavigatorIOS`](https://facebook.github.io/react-native/docs/navigatorios.html#content) that is no longer maintained by Facebook.

##### Props

```jsx
<NavigationControllerIOS title="Welcome" component="MovieListScreen" id="movies" />
```

Attribute | Description
-------- | -----------
title | Title displayed on the navigation bar on the root view controller (initial route)
component | [Registered name](https://github.com/wix/react-native-controllers#step-3---implement-all-top-level-components) of the component that provides the view for the root view controller (initial route)
id | Unique ID used to reference this view controller in future API calls

##### Methods

Get the instance with `Controllers.NavigationControllerIOS(id)`

```js
var Controllers = require('react-native-controllers');
var navigationController = Controllers.NavigationControllerIOS("movies");
```

 * **push(params)** - push a new screen

```js
require('./PushedScreen');
navigationController.push({
  title: "New Screen",
  component: "PushedScreen",
  animated: true
});
```

> Note: The pushed component should also be registered with `AppRegistry.registerComponent()` like the top level components and should be required to make sure it's included by the React Native bundler.

 * **pop()** - pop the current screen

```js
navigationController.pop();
```

 * **setLeftButton(params)** - set the left button of the navigation bar

```js
navigationController.setLeftButton({
  title: "Button Title",
  onPress: function() {
    // on press event handler
  }
});
```

##### Examples

[`FavoritesScreen.js`](example/FavoritesScreen.js), [`PushedScreen.js`](example/PushedScreen.js)

### DrawerControllerIOS

Native side menu drawer wrapper around [`MMDrawerController`](https://github.com/mutualmobile/MMDrawerController). This view controller lets you add a configurable side menu to your app (either on the left, right or both). Unlike most side menu implementations available for React Native, this side menu isn't implemented in JS and is completely native.

##### Props

```jsx
<DrawerControllerIOS id="drawer" componentLeft="SideMenu" componentRight="SideMenu">
  // center view controller here (the body of the app)
</DrawerControllerIOS>
```

Attribute | Description
-------- | -----------
componentLeft | [Registered name](https://github.com/wix/react-native-controllers#step-3---implement-all-top-level-components) of the component that provides the view for the left side menu
componentRight | [Registered name](https://github.com/wix/react-native-controllers#step-3---implement-all-top-level-components) of the component that provides the view for the right side menu
id | Unique ID used to reference this view controller in future API calls

##### Methods

Get the instance with `Controllers.DrawerControllerIOS(id)`

```js
var Controllers = require('react-native-controllers');
var drawerController = Controllers.DrawerControllerIOS("drawer");
```

 * **open(params)** - open the side menu

```js
drawerController.open({
  side: "right",
  animated: true
});
```

 * **close(params)** - close the side menu

```js
drawerController.close({
  side: "right",
  animated: true
});
```

 * **toggle(params)** - toggle the side menu (open if close, close if open)

```js
drawerController.toggle({
  side: "left",
  animated: true
});
```

 * **setStyle(params)** - set the side menu animation type

```js
drawerController.setStyle({
  animationType: "slide" // slide, slideAndScale, parallax, door
});
```

##### Examples

[`MovieListScreen.js`](example/MovieListScreen.js)

### TabBarControllerIOS

Native tabs wrapper around [`UITabBarController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITabBarController_Class/). This view controller lets display native tabs in your app, much like React Native's [`TabBarIOS`](https://facebook.github.io/react-native/docs/tabbarios.html#content).

##### Props

```jsx
<TabBarControllerIOS id="main">
  <TabBarControllerIOS.Item title="Movies" icon="home">
    // view controller here (the body of the tab)
  </TabBarControllerIOS.Item>
  <TabBarControllerIOS.Item title="Search" icon="discover">
    // view controller here (the body of the tab)
  </TabBarControllerIOS.Item>
</TabBarControllerIOS>
```

Attribute | Description
-------- | -----------
id | Unique ID used to reference this view controller in future API calls


Item Attribute | Description
-------- | -----------
title | Title displayed on the tab label
icon | Name of the Xcode image asset with the icon for this tab <br> `_selected` suffix is added for the selected version of the icon

##### Methods

Currently not implemented

### ViewControllerIOS

Generic empty view controller wrapper around [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/). This view controller is useful when you need to specify a view controller but you don't want anything special except a holder for your view. For example, a tab body without a navigation controller.

##### Props

```jsx
<ViewControllerIOS component="SearchScreen" />
```

Attribute | Description
-------- | -----------
component | [Registered name](https://github.com/wix/react-native-controllers#step-3---implement-all-top-level-components) of the component that provides the view for this view controller

##### Methods

Currently not implemented

## Credits

* [React Native](https://github.com/facebook/react-native) framework by Facebook
* [MMDrawerController](https://github.com/mutualmobile/MMDrawerController) component by mutualmobile

## License

The MIT License.

See [LICENSE](LICENSE)
