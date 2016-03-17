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

var PushedModalScreen = React.createClass({

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
          <Text style={styles.button}>Pop</Text>
        </TouchableOpacity>
      </View>
    );
  },

  onButtonClick: function() {
    Controllers.NavigationControllerIOS("modal_nav").pop();
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

AppRegistry.registerComponent('PushedModalScreen', () => PushedModalScreen);

module.exports = PushedModalScreen;
