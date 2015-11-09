/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
} = React;

var ControllersExample = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
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
});

AppRegistry.registerComponent('ControllersExample', () => ControllersExample);

var MovieListScreen = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Movie List Screen Screen
        </Text>
      </View>
    );
  }
});

AppRegistry.registerComponent('MovieListScreen', () => MovieListScreen);

var SearchScreen = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Search Screen
        </Text>
      </View>
    );
  }
});

AppRegistry.registerComponent('SearchScreen', () => SearchScreen);

var FavoritesScreen = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Favorites Screen2
        </Text>
      </View>
    );
  }
});

AppRegistry.registerComponent('FavoritesScreen', () => FavoritesScreen);

var SearchScreen = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          SideMenuComponenet SideMenuComponenet 
        </Text>
      </View>
    );
  }
});

AppRegistry.registerComponent('SideMenuComponenet', () => SearchScreen);
