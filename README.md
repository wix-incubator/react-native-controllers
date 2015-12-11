# React Native Controllers

`react-native-controllers` is a [React Native](https://facebook.github.io/react-native/) extension package for for iOS which aims to provide a completely native skeleton to iOS apps. Skeleton components such as [`UINavigatorController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/) or a [side menu drawer](https://www.cocoacontrols.com/search?q=drawer) are traditionally challenging to wrap natively with React Native. `react-native-controllers` simplifies this by re-introducing [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/index.html) into the React Native stack.

> Note: The main purpose of this package is to generate discussion around difficulties we found wrapping native iOS skeleton components with React Native. Look at this as a thought experiment with a proposed solution. If you have alternate ideas please share your feedback!

## Why do we need this package?

If you're already convinced you need this package, you can skip straight to [Installation](#installation).

## Installation

You need an iOS React Native project ([instructions on how to create one](https://facebook.github.io/react-native/docs/getting-started.html#quick-start))

1. Run `npm install react-native-controllers` in your project root
2. In XCode, in Project Navigator (left pane), right-click on the `Libraries` > `Add files to [project name]` <br> Add `./node_modules/react-native-controllers/ios/ReactNativeControllers.xcodeproj` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-1))
3. In XCode, in Project Navigator (left pane), click on your project (top) and select the `Build Phases` tab (right pane) <br> In the `Link Binary With Libraries` section add `libReactNativeControllers.a` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-2))
4. In XCode, in Project Navigator (left pane), click on your project (top) and select the `Build Settings` tab (right pane) <br> In the `Header Search Paths` section add `$(SRCROOT)/../node_modules/react-native-controllers/ios` <br> Make sure on the right to mark this new path `recursive` ([screenshots](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#step-3))
