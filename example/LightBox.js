'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Dimensions
} = ReactNative;

var Controllers = require('react-native-controllers');
var {
  Modal,
} = Controllers;

var LightBox = React.createClass({
  _onButtonClick: function() {
    Modal.dismissLightBox();
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          This is a LightBox!
        </Text>
        <Text style={[styles.welcome, {fontSize: 16, marginTop: 20}]}>
          {this.props.greeting}
        </Text>
        <TouchableOpacity onPress={ this._onButtonClick }>
          <Text style={styles.button}>Dismiss</Text>
        </TouchableOpacity>
      </View>
    );
  },
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    width: Dimensions.get('window').width * 0.8,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'white',
    borderRadius: 10
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  button: {
    textAlign: 'center',
    fontSize: 18,
    marginBottom: 10,
    marginTop:10,
    color: 'blue'
  }
});

AppRegistry.registerComponent('LightBox', () => LightBox);

module.exports = LightBox;
