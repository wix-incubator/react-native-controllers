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

var FavoritesScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Favorites Screen
        </Text>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick.bind(this) }>
          <Text style={styles.button}>Push</Text>
        </TouchableHighlight>
      </View>
    );
  },

  onButtonClick: function() {
    require('./PushedScreen'); // help the react bundler understand we want this file included
    Controllers.NavigationControllerIOS("favorites").push({
      title: "Pushed screen",
      component: "PushedScreen",
      animated: true,
    });
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

AppRegistry.registerComponent('FavoritesScreen', () => FavoritesScreen);

module.exports = FavoritesScreen;
