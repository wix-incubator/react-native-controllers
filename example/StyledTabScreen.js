'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View
} = ReactNative;

var Controllers = require('react-native-controllers');
var {
  Modal,
  ControllerRegistry
} = Controllers;

var StyledTabScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Styled Tab Screen
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Notice how the tabs on this screen are styled differently
        </Text>

      </View>
    );
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

AppRegistry.registerComponent('StyledTabScreen', () => StyledTabScreen);

module.exports = StyledTabScreen;
