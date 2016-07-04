# React Native Controllers

`react-native-controllers` is a [React Native](https://facebook.github.io/react-native/) npm extension package for iOS which provides a completely native skeleton for iOS apps, allowing you to easily wrap core native UI components without compromising on the native experience. Key benefits:

* Truly native navigation (instead of the JS-based [`Navigator`](https://facebook.github.io/react-native/docs/navigator-comparison.html) or the [deprecated `NavigatorIOS`](https://facebook.github.io/react-native/docs/navigatorios.html))
* Truly native side menu drawer (instead of the JS-based alternatives available today)
* Smoother animations, improved performance and look and feel that matches the OS for all iOS versions

*Versions 1.x.x support react-native 0.19.0-0.25.0*

*Versions 2.x.x support react-native 0.25.0+ (due to breaking changes in React Native)*

![Screenshots](http://i.imgur.com/2QyOm9a.png)

Without `react-native-controllers`, iOS skeleton components such as [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/) or a [side menu drawer](https://www.cocoacontrols.com/search?q=drawer) are challenging to implement natively. This forces developers to compromise on user experience to use React Native.
`react-native-controllers` simplifies this by re-introducing [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) into the React Native stack.

> Note: The main purpose of this package is to generate discussion around difficulties we found wrapping native iOS skeleton components with React Native. Look at this as a thought experiment with a proposed solution. If you have alternate ideas please share your feedback!

## Before you start

react-native-controllers is a low-level package with API that wasn't designed to be cross-platform (since it's optimized for native UX). We have another project called [react-native-navigation](https://github.com/wix/react-native-navigation) which is a syntactic sugar wrapper around react-native-controllers. It provides the *same* native goodness with API that is *much* simpler, cross-platform between iOS and Android, and supports redux!

## Table of contents

* [Why do we need this package?](#why-do-we-need-this-package)
* [What sacrifices did we make?](#what-sacrifices-did-we-make)
* [Installation](#installation)
* [Usage](#usage)
* [API](#api)
* [Available view controllers](#available-view-controllers)
* [Credits](#credits)
* [Release Notes](CHANGES.md)
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

> Important: Make sure you are using react-native version >= 0.25.1

1. Run `npm install react-native-controllers --save` in your project root
2. In Xcode, in Project Navigator (left pane), right-click on the `Libraries` > `Add files to [project name]` <br> Add `./node_modules/react-native-controllers/ios/ReactNativeControllers.xcodeproj` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-1))
3. In Xcode, in Project Navigator (left pane), click on your project (top) and select the `Build Phases` tab (right pane) <br> In the `Link Binary With Libraries` section add `libReactNativeControllers.a` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-2))
4. In Xcode, in Project Navigator (left pane), click on your project (top) and select the `Build Settings` tab (right pane) <br> In the `Header Search Paths` section add `$(SRCROOT)/../node_modules/react-native-controllers/ios` <br> Make sure on the right to mark this new path `recursive` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-3))

## Usage

Check out the iOS example project under [`./example`](example) to see everything in action. For a detailed explanation of how to modify your project, follow the 3 steps below:

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
  [[RCCManager sharedInstance] initBridgeWithBundleURL:jsCodeLocation];

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
          <TabBarControllerIOS.Item title="Movies" icon={require('./img/home.png')}>
            <NavigationControllerIOS title="Welcome" component="MovieListScreen" id="movies" />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Search" icon={require('./img/discover.png')}>
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

## API

#### `Controllers`

```js
var Controllers = require('react-native-controllers');
```

 * **hijackReact()** - change the React instance in this file so controllers can be defined (see explanation above)

```js
var React = Controllers.hijackReact();
var {
  TabBarControllerIOS,
  NavigationControllerIOS,
  ViewControllerIOS,
  DrawerControllerIOS
} = React;
```

 * **createClass(controllerClass)** - define a new controller using JSX (see explanation above)

```js
var MoviesApp = Controllers.createClass({
  render: function() {
    return (
      <DrawerControllerIOS id="drawer" componentLeft="SideMenu" componentRight="SideMenu">
      ...
      </DrawerControllerIOS>
    );
  }
});
```

> Note: Your render function can only contain supported controllers, see the full list under [available view controllers](#available-view-controllers).

#### `ControllerRegistry`

```js
var Controllers = require('react-native-controllers');
var { ControllerRegistry } = Controllers;
```

 * **registerController(controllerId, generator)** - register a unique id for a controller

```js
ControllerRegistry.registerController('MoviesApp', () => MoviesApp);
```

 * **setRootController(controllerId, animationType = 'none', passProps = {})** - start the app with a root controller

```js
// example without animation
// controllerId: a string id previously registered with ControllerRegistry.registerController
ControllerRegistry.setRootController('MoviesApp');

// example with animation, useful for changing your app root during runtime (from a different controller)
// animationType: 'none', 'slide-down', 'fade'
ControllerRegistry.setRootController('LoginApp', 'slide-down');

// example with props
// these props will be passed to all top components in the layout hierarchy (eg. all tabs, side menus, etc.)
ControllerRegistry.setRootController('MoviesApp', 'none', { greeting: 'hello world' });
```

#### `Modal`

```js
var Controllers = require('react-native-controllers');
var { Modal } = Controllers;
```

 * **showController(controllerId, animationType = 'slide-up', passProps = {})** - display a controller modally

```js
// example with default slide up animation
// controllerId: a string id previously registered with ControllerRegistry.registerController
Modal.showController('MoviesApp');

// example without animation
// animationType: 'none', 'slide-up'
Modal.showController('LoginApp', 'none');

// example with props
Modal.showController('MoviesApp', 'slide-up', { greeting: 'hello world' });

```

 * **dismissController(animationType = 'slide-down')** - dismiss the current modal controller

```js
// example with default slide down animation
Modal.dismissController();

// example without animation
// animationType: 'none', 'slide-down'
Modal.dismissController('none');
```

* **dismissAllControllers(animationType = 'slide-down')** - dismiss all displayed modal controllers

```js
// this will dismiss several displayed controllers at once
Modal.dismissAllControllers();
```

 * **showLightBox(params)** - display a component as a light box

```js
Modal.showLightBox({
  component: "LightBoxScreen", // the unique ID registered with AppRegistry.registerComponent (required)
  passProps: {}, // simple serializable object that will pass as props to lightbox component (optional)
  style: {
    backgroundBlur: "dark", // 'dark' / 'light' / 'xlight' / 'none' - the type of blur on the background
    backgroundColor: "#ff000080" // tint color for the background, you can specify alpha here (optional)
  }
});
```

 * **dismissLightBox()** - dismiss the current light box

```js
Modal.dismissLightBox();
```

#### Components

##### `NavigationToolBarIOS`

Helper component to assist with adding custom views to the bottom of the navigation bar. You can see this UI pattern in the native iOS Calendar app (week days in the day view) and the native iOS Health app (segmented control in the dashboard tab).

This pattern can be implemented by adding a React component in your **screen component's content** (not really on the nav bar) and making it stick to top (using absolute position). The illusion that this component is part of the nav bar is achieved by wrapping it with `NavigationToolBarIOS ` which provides a background with the same translucent effect the nav bar has.

You can see a working example of all this in the example project.

```js
var Controllers = require('react-native-controllers');
var { NavigationToolBarIOS } = Controllers;
```

###### Example (holding SegmentedControlIOS)

```js
<NavigationToolBarIOS key='segmented' style={{
  top: 44,
  width: width,
  height: 64,
  position: 'absolute'
}}>
  <SegmentedControlIOS
    values={['One', 'Two', 'Three']}
    selectedIndex={this.state.segmentIndexSelected}
    style={styles.segmentedControl}
    onChange={(event) => {
      this.setState({segmentIndexSelected : event.nativeEvent.selectedSegmentIndex});
    }}
  />
  <View style={styles.lineBorder} />
</NavigationToolBarIOS>
```

>Note: In order to position this component immediately below the navigation bar, we use `{position: 'absolute'}`. In addition, to make sure z-order is correct and this compoenent is rendered over the rest of the content, add it as the last component in your hierarchy (inside your screen component render method).

###### Props

```jsx
<NavigationToolBarIOS translucent={true} />
```

Attribute | Description
-------- | -----------
translucent | Boolean, whether the background has the same translucent effect as a nav bar with the `NavBarTranslucent` style. Default `true`.


## Available View Controllers

The package contains implementations for the following view controllers that you can use in your app skeleton:

 * [NavigationControllerIOS](#navigationcontrollerios) - Native navigator wrapper around [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/)
 * [DrawerControllerIOS](#drawercontrollerios) - Native side menu drawer wrapper around [`MMDrawerController`](https://github.com/mutualmobile/MMDrawerController)
 * [TabBarControllerIOS](#tabbarcontrollerios) - Native tabs wrapper around [`UITabBarController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITabBarController_Class/)
 * [ViewControllerIOS](#viewcontrollerios) - Generic empty view controller wrapper around [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/)

These wrappers are very simple. You can also add your own if you find missing React Native components that are based on `UIViewController` instead of `UIView`.

#### `NavigationControllerIOS`

Native navigator wrapper around [`UINavigationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/). This view controller is a replacement for React Native's [`NavigatorIOS`](https://facebook.github.io/react-native/docs/navigatorios.html#content) that is no longer maintained by Facebook.

##### Props

```jsx
<NavigationControllerIOS title="Welcome" component="MovieListScreen" id="movies" />
```

Attribute | Description
-------- | -----------
title | Title displayed on the navigation bar on the root view controller (initial route)
titleImage | Image to be displayed in the navigation bar instead of the title
component | [Registered name](https://github.com/wix/react-native-controllers#step-3---implement-all-top-level-components) of the component that provides the view for the root view controller (initial route)
id | Unique ID used to reference this view controller in future API calls
passProps | Simple serializable object that will pass as props to the pushed component
style | Style the navigation bar, see [Styling Navigation](#styling-navigation) below for all available styles
leftButtons | Array of left buttons to add in the nav bar, see `setLeftButtons` below for array format
rightButtons | Array of right buttons to add in the nav bar, see `setRightButtons` below for array format

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
  title: "New Screen", // nav bar title of the pushed screen (optional)
  titleImage: require('../img/title_image.png'), //nav bar title image of the pushed screen (optional)
  component: "PushedScreen", // the unique ID registered with AppRegistry.registerComponent (required)
  passProps: {}, // simple serializable object that will pass as props to the pushed component (optional)
  style: {}, // style the navigation bar for the pushed screen (optional, see "Styling Navigation" below)
  animated: true, // does the push have a transition animation (optional, default true)
  backButtonTitle: "Back", // override the nav bar back button title for the pushed screen (optional)
  backButtonHidden: true, // hide the nav bar back button for the pushed screen altogether (optional)
  leftButtons: [{ // buttons in the nav bar of the pushed screen (optional)
    title: "Button Title", // optional, title for a textual button
    icon: require('./img/navicon_camera.png'), // optional, image for an icon button
    onPress: function() {
      // on press event handler
    },
    testID: "e2e_is_awesome", // optional, used to locate this view in end-to-end tests
    disabled: true, // optional, disables the button (shown as faded without interaction)
    disableIconTint: true, // optional, by default the image colors are overridden and tinted to navBarButtonColor, set to true to keep the original image colors
  }],
  rightButtons: [] // similar format to leftButtons (optional)
});
```

> Important Note: Every pushed component should be registered with `AppRegistry.registerComponent()` like the top level component in a tradition React Native app. This is because every pushed component is actually a new React root under the hood.

 * **pop()** - pop the current screen

```js
navigationController.pop({
  animated: true // does the pop have a transition animation (optional, default true)
);
```

 * **popToRoot()** - pop all the screens from the navigation stack until we get to the root

```js
navigationController.popToRoot({
  animated: true // does the pop have a transition animation (optional, default true)
);
```

* **resetTo()** - replace the navigation stack root, all screens in the existing stack will be discarded

```js
navigationController.resetTo({
  title: "New Screen", // nav bar title of the new screen (optional)
  component: "PushedScreen", // the unique ID registered with AppRegistry.registerComponent (required)
  passProps: {}, // simple serializable object that will pass as props to the new component (optional)
  style: {}, // style the navigation bar for the new screen (optional, see "Styling Navigation" below)
  animated: true, // does the reset have a transition animation (optional, default true)
  leftButtons: [{ // buttons in the nav bar of the new screen (optional)
    title: "Button Title", // optional, title for a textual button
    icon: require('./img/navicon_camera.png'), // optional, image for an icon button
    onPress: function() {
      // on press event handler
    },
    testID: "e2e_is_awesome", // optional, used to locate this view in end-to-end tests
    disabled: true, // optional, disables the button (shown as faded without interaction)
    disableIconTint: true, // optional, by default the image colors are overridden and tinted to navBarButtonColor, set to true to keep the original image colors
  }],
  rightButtons: [] // similar format to leftButtons (optional)
);
```

 * **setLeftButtons(buttons, animated = false)** - set the left buttons of the navigation bar
 * **setRightButtons(buttons, animated = false)** - set the right buttons of the navigation bar

```js
navigationController.setRightButtons([
  {
    title: "Button Title", // title for a textual button
    onPress: function() {
      // on press event handler
    },
    testID: "e2e_is_awesome", // optional, used to locate this view in end-to-end tests
    disabled: true, // optional, disables the button (shown as faded without interaction)
    disableIconTint: true, // optional, by default the image colors are overridden and tinted to navBarButtonColor, set to true to keep the original image colors
  },
  {
    icon: require('./img/navicon_camera.png'), // image for an icon button
    onPress: function() {
      // on press event handler
    },
    testID: "e2e_is_awesome", // optional, used to locate this view in end-to-end tests
    disabled: true, // optional, disables the button (shown as faded without interaction)
    disableIconTint: true, // optional, by default the image colors are overridden and tinted to navBarButtonColor, set to true to keep the original image colors
  }
  ]);
```

* **setTitle(params)** - change the title in the navigation bar during runtime

```js
navigationController.setTitle({
  title: "New Title"
});
```

* **toggleNavBar(animated = true)** - toggle the navigation bar

```js
navigationController.toggleNavBar();
```

##### Styling Navigation

You can apply styling to the navigation bar appearance and behavior by setting the `style` property when defining your `NavigationControllerIOS` or by passing the `style` object when pushing a new screen.

Please note that some styles (usually color related) are remembered for future pushed screens. For example, if you change the navigation bar color, all future pushed screens will keep this style and have the same changed colors. If you wish to have different colors in a pushed screen, simply override the style by passing the `style` object when calling `push()`. Every style that is remembered across pushes is documented as such below.

All styles are optional, this is the format of the style object:

```js
{
  navBarTextColor: '#000000', // change the text color of the title (remembered across pushes)
  navBarBackgroundColor: '#f7f7f7', // change the background color of the nav bar (remembered across pushes)
  navBarButtonColor: '#007aff', // change the button colors of the nav bar (eg. the back button) (remembered across pushes)
  navBarHidden: false, // make the nav bar hidden
  navBarHideOnScroll: false, // make the nav bar hidden only after the user starts to scroll
  navBarTranslucent: false, // make the nav bar semi-translucent, works best with drawUnderNavBar:true
  navBarTransparent: false, // make the nav bar transparent, works best with drawUnderNavBar:true
  navBarNoBorder: false, // hide the navigation bar bottom border (hair line)
  drawUnderNavBar: false, // draw the screen content under the nav bar, works best with navBarTranslucent:true
  drawUnderTabBar: false, // draw the screen content under the tab bar (the tab bar is always translucent)
  statusBarBlur: false, // blur the area under the status bar, works best with navBarHidden:true
  navBarBlur: false, // blur the entire nav bar, works best with drawUnderNavBar:true
  tabBarHidden: false, // make the screen content hide the tab bar (remembered across pushes)
  statusBarHideWithNavBar: false // hide the status bar if the nav bar is also hidden, useful for navBarHidden:true
  statusBarHidden: false, // make the status bar hidden regardless of nav bar state
  statusBarTextColorScheme: 'dark' // text color of status bar, 'dark' / 'light' (remembered across pushes)
}
```

> Note: If you set any styles related to the Status Bar, make sure that in Xcode > project > Info.plist, the property `View controller-based status bar appearance` is set to `YES`.

See all the styles in action by running the [example](example) project in Xcode (under the "Favorites" tab).

##### Examples

[`FavoritesScreen.js`](example/FavoritesScreen.js), [`PushedScreen.js`](example/PushedScreen.js)

#### `DrawerControllerIOS`

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
passPropsLeft | Simple serializable object that will pass as props to the left component
passPropsRight | Simple serializable object that will pass as props to the right component
disableOpenGesture | Disable the open gesture
type | MMDrawer / TheSideBar (default is MMDrawer)
animationType | if type=MMDrawer animationTypes=door/parallax/slide/slide-and-scale. If type=TheSideBar animationType=airbnb/facebook/luvocracy/wunder-list (**Default** is type=MMDrawer animationType=slide)


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
##### Styling Drawer

You can apply styling to the Drawer appearance and behavior by setting the `style` property when defining your `DrawerControllerIOS `.

All styles are optional, this is the format of the style object:

```js
{
  contentOverlayColor: '#162D3D55', // change the text color of the title (support colors with alpha - last 2 digits)
  backgroundImage: 'icon={require('./img/background.png')}', // change the background image. Will be seen when Drawer animationType are slide-and-scale or airbnb/luvacracy
  leftDrawerWidth: '60' // change the left drawer width. Precentage value, 60% of screen width (default is 80%)
  rightDrawerWidth: '70' // change the left drawer width. Precentage value, 70% of screen width (default is 80%)
}
```

See all the styles in action by running the [example](example) project in Xcode (under the "Movies" tab, side menu section, try to press "More..." button in order to show more cool drawer options).



##### Examples

[`MovieListScreen.js`](example/MovieListScreen.js)

#### `TabBarControllerIOS`

Native tabs wrapper around [`UITabBarController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITabBarController_Class/). This view controller lets display native tabs in your app, much like React Native's [`TabBarIOS`](https://facebook.github.io/react-native/docs/tabbarios.html#content).

##### Props

```jsx
<TabBarControllerIOS id="main">
  <TabBarControllerIOS.Item title="Movies" icon={require('./img/home.png')}>
    // view controller here (the body of the tab)
  </TabBarControllerIOS.Item>
  <TabBarControllerIOS.Item title="Search" icon={require('./img/discover.png')}>
    // view controller here (the body of the tab)
  </TabBarControllerIOS.Item>
</TabBarControllerIOS>
```

Attribute | Description
-------- | -----------
id | Unique ID used to reference this view controller in future API calls
style | Style the tab bar, see [Styling Tab Bar](#styling-tab-bar) below for all available styles


Item Attribute | Description
-------- | -----------
title | Title displayed on the tab label
icon | Local asset image for the tab icon (unselected state), use `require` like with a [local image](https://facebook.github.io/react-native/docs/image.html)
selectedIcon | Local asset image for the tab icon (selected state), use `require` like with a [local image](https://facebook.github.io/react-native/docs/image.html)
badge | Badge displayed on tab icon. To keep item without badge set `none` or leave without `badge` property

> Note: For best results on iOS, supply icon images that are 50x50 pixels for retina screen, make sure you add the `@2x` suffix for the filename on disk (eg. `home@2x.png`)

##### Methods

Get the instance with `Controllers.TabBarControllerIOS(id)`

```js
var Controllers = require('react-native-controllers');
var tabController = Controllers.TabBarControllerIOS("main");
```

 * **switchTo(params)** - switch to one of the tabs

```js
tabController.switchTo({
  tabIndex: 0, // if you want to specify the tab by its index (option A)
  contentId: "movies_nav", // if instead of index you want to specify by the contained controller id (option B)
  contentType: "NavigationControllerIOS" // the type of the contained controller (option B)
});
```

 * **setHidden(params)** - manually hide/show the tab bar

```js
tabController.setHidden({
  hidden: true, // the new state of the tab bar
  animated: true
});
```

 * **setBadge(params)** - change the badge value on a tab

```js
tabController.setBadge({
  tabIndex: 0, // if you want to specify the tab by its index (option A)
  contentId: "movies_nav", // if instead of index you want to specify by the contained controller id (option B)
  contentType: "NavigationControllerIOS", // the type of the contained controller (option B)
  badge: "HOT" // badge value, null to remove badge
});
```

##### Styling Tab Bar

You can apply styling to the tab bar appearance by setting the `style` property when defining your `TabBarControllerIOS`.

All styles are optional, this is the format of the style object:

```js
{
  tabBarButtonColor: '#ffff00', // change the color of the tab icons and text (also unselected)
  tabBarSelectedButtonColor: '#ff9900', // change the color of the selected tab icon and text (only selected)
  tabBarBackgroundColor: '#551A8B' // change the background color of the tab bar
}
```

#### `ViewControllerIOS`

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
