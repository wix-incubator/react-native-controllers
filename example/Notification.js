
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
  Notification,
} = Controllers;

var NotificationExample = React.createClass({
  _onButtonClick: function() {
    Notification.dismiss();
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          {this.props.greeting}
        </Text>
        <TouchableOpacity onPress={ this._onButtonClick }>
          <Text style={styles.button}>Dismiss</Text>
        </TouchableOpacity>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    width: Dimensions.get('window').width,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#d6e7ad'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
    paddingTop: 20
  },
  button: {
    textAlign: 'center',
    fontSize: 18,
    marginBottom: 10,
    marginTop:10,
    color: '#4692ad'
  }
});

AppRegistry.registerComponent('NotificationExample', () => NotificationExample);

module.exports = NotificationExample;
