'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} = ReactNative;

var Controllers = require('react-native-controllers');

var PushedScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Simple Pushed Screen
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Notice how the push was 100% native. This screen doesn't have any special styles applied.
        </Text>

        <TouchableOpacity onPress={ this.onPushClick }>
          <Text style={styles.button}>Push Another</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onPopClick }>
          <Text style={styles.button}>Pop</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onPopToRootClick }>
          <Text style={styles.button}>PopToRoot</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onResetToClick }>
          <Text style={styles.button}>ResetTo</Text>
        </TouchableOpacity>

      </View>
    );
  },

  onPushClick: function() {
    Controllers.NavigationControllerIOS("favorites_nav").push({
      component: 'PushedScreen',
      title: 'Another'
    });
  },

  onPopClick: function() {
    Controllers.NavigationControllerIOS("favorites_nav").pop();
  },

  onPopToRootClick: function() {
    Controllers.NavigationControllerIOS("favorites_nav").popToRoot();
  },

  onResetToClick: function() {
    Controllers.NavigationControllerIOS("favorites_nav").resetTo({
      component: 'PushedScreen',
      title: 'New Root'
    });
  }

});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF'
  },
  button: {
    textAlign: 'center',
    fontSize: 18,
    marginBottom: 10,
    marginTop: 10,
    color: 'blue'
  }
});

AppRegistry.registerComponent('PushedScreen', () => PushedScreen);

module.exports = PushedScreen;
