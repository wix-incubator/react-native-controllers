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
  ControllerRegistry
} = Controllers;

var ModalScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Simple Modal Screen
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Notice how the show modal was 100% native. This screen doesn't have any special styles applied.
        </Text>

        {
          !this.props.greeting ? false :
          <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
            {this.props.greeting}
          </Text>
        }

        <TouchableOpacity onPress={ this.onPushClick }>
          <Text style={styles.button}>Push Plain Screen</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onReplaceRootClick }>
          <Text style={styles.button}>Replace Root</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onShowModalClick }>
          <Text style={styles.button}>Show another Modal</Text>
        </TouchableOpacity>

      </View>
    );
  },

  onPushClick: function() {
    require('./PushedModalScreen'); // help the react bundler understand we want this file included
    Controllers.NavigationControllerIOS("modal_nav").push({
      title: "Pushed screen",
      component: "PushedModalScreen",
      animated: true
    });
  },

  onReplaceRootClick: function() {
    ControllerRegistry.setRootController('ModalScreenTester', 'slide-down');
  },

  onShowModalClick: async function() {
    Modal.showController('ModalScreenTester');
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
    marginTop: 10,
    color: 'blue'
  }
});

AppRegistry.registerComponent('ModalScreen', () => ModalScreen);

module.exports = ModalScreen;
