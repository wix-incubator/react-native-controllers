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

var ModalScreen = React.createClass({

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Simple Pushed Screen
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Notice how the push was 100% native. This screen doesn't have any special styles applied.
        </Text>

        <TouchableOpacity onPress={ this.onButtonClick }>
          <Text style={styles.button}>Push Plain Screen</Text>
        </TouchableOpacity>
      </View>
    );
  },

  onButtonClick: function() {
    require('./PushedScreen'); // help the react bundler understand we want this file included
    Controllers.NavigationControllerIOS("modal").push({
      title: "Pushed screen",
      component: "PushedScreen",
      animated: true
    });
  }

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
