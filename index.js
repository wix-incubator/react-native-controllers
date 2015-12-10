var OriginalReact = require('react-native');
var RCCManager = OriginalReact.NativeModules.RCCManager;
var NativeAppEventEmitter = OriginalReact.NativeAppEventEmitter;

var _controllerRegistry = {};

function _getRandomId() {
  return (Math.random()*1e20).toString(36);
}

var Controllers = {

  createClass: function (app) {
    return app;
  },

  hijackReact: function () {
    return {
      createElement: function(type, props) {
        return {
          'type': type.name,
          'props': props,
          'children': Array.prototype.slice.call(arguments, 2)
        };
      },

      ControllerRegistry: {
        registerController: function (appKey, getControllerFunc) {
          _controllerRegistry[appKey] = getControllerFunc();
        },
        setRootController: function (appKey) {
          var controller = _controllerRegistry[appKey];
          if (controller === undefined) return;
          var layout = controller.render();
          RCCManager.setRootController(layout);
        }
      },

      TabBarControllerIOS: {name: 'TabBarControllerIOS', Item: {name: 'TabBarControllerIOS.Item'}},
      NavigationControllerIOS: {name: 'NavigationControllerIOS'},
      ViewControllerIOS: {name: 'ViewControllerIOS'},
      DrawerControllerIOS: {name: 'DrawerControllerIOS'},
    };
  },

  NavigationControllerIOS: function (id) {
    return {
      push: function (params) {
        return RCCManager.NavigationControllerIOS(id, "push", params);
      },
      pop: function (params) {
        return RCCManager.NavigationControllerIOS(id, "pop", params);
      },
      setLeftButton: function (params) {
        if (typeof params.onPress === "function") {
          var onPressId = _getRandomId();
          var onPressFunc = params.onPress;
          params.onPress = onPressId;
          // where do we unsubscribe?
          NativeAppEventEmitter.addListener(onPressId, (event) => onPressFunc(event));
        }
        return RCCManager.NavigationControllerIOS(id, "setLeftButton", params);
      }
    };
  },

  DrawerControllerIOS: function (id) {
    return {
      open: function (params) {
        return RCCManager.DrawerControllerIOS(id, "open", params);
      },
      close: function (params) {
        return RCCManager.DrawerControllerIOS(id, "close", params);
      },
      toggle: function (params) {
        return RCCManager.DrawerControllerIOS(id, "toggle", params);
      },
      setStyle: function (params) {
        return RCCManager.DrawerControllerIOS(id, "setStyle", params);
      }
    };
  },

};

module.exports = Controllers;
