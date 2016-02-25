'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
} = React;

var Controllers = require('react-native-controllers');

var PushedScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Pushed Screen 100% Native
        </Text>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick }>
          <Text style={styles.button}>Pop</Text>
        </TouchableHighlight>
      </View>
    );
  },

  onButtonClick: function() {
    Controllers.NavigationControllerIOS("favorites").pop();
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
  },
});

AppRegistry.registerComponent('PushedScreen', () => PushedScreen);

module.exports = PushedScreen;
