'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity
} = React;

require('./LightBox');

var Controllers = require('react-native-controllers');
var {
  Modal,
  ControllerRegistry
} = Controllers;

var MovieListScreen = React.createClass({

  componentDidMount: function() {
    Controllers.NavigationControllerIOS("movies_nav").setLeftButtons([{
      title: "Burger",
      onPress: function() {
        Controllers.DrawerControllerIOS("drawer").toggle();
      }
    }]);
  },

  onButtonClick: function(val) {
    Controllers.DrawerControllerIOS("drawer").setStyle({
      animationType: val
    });
  },

  onShowLightBoxClick: function(backgroundBlur, backgroundColor = undefined) {
    Modal.showLightBox({
      component: 'LightBox',
      style: {
        backgroundBlur: backgroundBlur,
        backgroundColor: backgroundColor
      }
    });
  },

  onShowModalVcClick: async function() {
    Modal.showController('ModalScreenTester');
  },

  onReplaceRootAnimatedClick: function() {
    ControllerRegistry.setRootController('ModalScreenTester', 'slide-down');
  },

  render: function() {
    return (
      <ScrollView style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 30}}>
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

        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 30}}>
          Modal Example
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Use the various options below to bring up modal screens:
        </Text>

        <TouchableOpacity onPress={ this.onShowLightBoxClick.bind(this, "dark") }>
          <Text style={styles.button}>LightBox (dark blur)</Text>
        </TouchableOpacity>

	      <TouchableOpacity onPress={ this.onShowLightBoxClick.bind(this, "light") }>
          <Text style={styles.button}>LightBox (light blur)</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onShowLightBoxClick.bind(this, "light", "rgba(66, 141, 200, 0.2)") }>
          <Text style={styles.button}>LightBox (light blur + color overlay)</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onShowModalVcClick }>
          <Text style={styles.button}>Show Modal ViewController</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onReplaceRootAnimatedClick }>
          <Text style={styles.button}>Replace root animated</Text>
        </TouchableOpacity>

      </ScrollView>
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
