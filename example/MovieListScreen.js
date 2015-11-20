'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
} = React;

var Controllers = require('./react-native-controllers.js');

var MovieListScreen = React.createClass({

  componentDidMount: function() {
    Controllers.NavigationControllerIOS("movies").setLeftButton({
      title: "Burger",
      onPress: function() {
        Controllers.DrawerControllerIOS("drawer").toggle();
      }
    });
  },

  onButtonClick: function(val) {
    Controllers.DrawerControllerIOS("drawer").setStyle({
      animationType: val
    });
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Movie List Screen Screen
        </Text>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick.bind(this, "door") }>
          <Text style={styles.button}>Door</Text>
        </TouchableHighlight>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick.bind(this, "parallax") }>
          <Text style={styles.button}>Parallax</Text>
        </TouchableHighlight>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick.bind(this, "slide") }>
          <Text style={styles.button}>Slide</Text>
        </TouchableHighlight>

        <TouchableHighlight underlayColor="#cccccc" onPress={ this.onButtonClick.bind(this, "slideAndScale") }>
          <Text style={styles.button}>Slide & Scale</Text>
        </TouchableHighlight>
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
  },
});

AppRegistry.registerComponent('MovieListScreen', () => MovieListScreen);

module.exports = MovieListScreen;
