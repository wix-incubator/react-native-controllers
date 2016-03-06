'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} = React;

require('./LightBox');

var Controllers = require('react-native-controllers');
var {
  Modal,
} = Controllers;

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

  onShowLightBoxClick: function() {
    Modal.showLightBox('LightBox');
  },

  onShowModalVcClick: async function() {
    Modal.showController('ModalScreenTester', true);
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Side Menu Example
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          There's a right and a left side menu in this example. Control the side menu animation using the options below:
        </Text>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, "door") }>
          <Text style={styles.button}>Door</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, "parallax") }>
          <Text style={styles.button}>Parallax</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, "slide") }>
          <Text style={styles.button}>Slide</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, "slideAndScale") }>
          <Text style={styles.button}>Slide & Scale</Text>
        </TouchableOpacity>

	      <TouchableOpacity onPress={ this.onShowLightBoxClick }>
          <Text style={styles.button}>Show LightBox</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onShowModalVcClick }>
          <Text style={styles.button}>Show Modal ViewController</Text>
        </TouchableOpacity>
      </View>
    );
  },

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
    marginTop:10,
    color: 'blue'
  }
});

AppRegistry.registerComponent('MovieListScreen', () => MovieListScreen);

module.exports = MovieListScreen;
