'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} = React;

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
      <View style={{backgroundColor: '#ffffff', width: 300, height: 200}}>
        <Text style={styles.welcome}>
          This is a LightBox!
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
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
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