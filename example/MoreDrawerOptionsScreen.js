'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
} = React;

require('./LightBox');

var Controllers = require('react-native-controllers');
var {
  Modal,
  ControllerRegistry,
  Constants
} = Controllers;

var MoreDrawerOptionsScreen = React.createClass({

  getInitialState: function() {
    return {
      tabBarHidden: false
    }
  },

  componentDidMount: function() {
    Controllers.NavigationControllerIOS("more_nav").setLeftButtons([{
      title: "Burger",
      onPress: function() {
        Controllers.DrawerControllerIOS("drawer_options").toggle({side:"left"});
      }
    }]);

    Controllers.NavigationControllerIOS("more_nav").setRightButtons([{
      title: "MegaBurger",
      onPress: function() {
        Controllers.DrawerControllerIOS("drawer_options").toggle({side:"right"});
      }
    }]);
  },

  onButtonClick: function(val) {
    Controllers.DrawerControllerIOS("drawer_options").setStyle({
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

  onClosePressed: function() {
    ControllerRegistry.setRootController('MoviesApp', 'fade');
  },

  onShowModalVcClick: async function() {
    Modal.showController('ModalScreenTester');
  },

  onShowModalMoreDrawerOptionsVcClick: async function() {
    Modal.showController('MoreDrawerScreenTester');
  },

  onToggleTabBarClick: async function() {
    this.setState({
      tabBarHidden: !this.state.tabBarHidden
    });
    Controllers.TabBarControllerIOS("main").setHidden({hidden: this.state.tabBarHidden, animated: true});
  },

  onReplaceRootAnimatedClick: function() {
    ControllerRegistry.setRootController('ModalScreenTester', 'slide-down');
  },

  render: function() {
    return (
      <ScrollView style={styles.container}>
        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 30}}>
          Awesome drawer options
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          Select any awesome animation for the awesome drawer
        </Text>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, Constants.THE_SIDEBAR_AIRBNB) } >
          <Text style={styles.button}>Airbnb</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, Constants.THE_SIDEBAR_FACEBOOK) } >
          <Text style={styles.button}>Facebook</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, Constants.THE_SIDEBAR_LUVOCRACY) } >
          <Text style={styles.button}>Luvocracy</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, Constants.THE_SIDEBAR_WUNDER_LIST) } >
          <Text style={styles.button}>Wunder List</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onClosePressed } >
          <Text style={styles.closeButton}>Back to old</Text>
        </TouchableOpacity>


        <View style={{height: 50}}>
          {
            this.state.tabBarHidden ?
              <Text style={{position: 'absolute', bottom: 0, left: 0, right: 0, height: 30, color: 'red', backgroundColor: '#ffcccc', textAlign: 'center'}}>Wink wink</Text>
              : false
          }
        </View>
      </ScrollView>
    );
  },

});
3
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
    color:'blue'
  },
  closeButton: {
    textAlign: 'center',
    fontSize: 18,
    marginBottom: 10,
    marginTop:10,
    color:'red'
  },
  lineView: {
    height: 1,
    marginTop: 4,
    marginBottom: 4,
    marginLeft: 8,
    marginRight: 8,
    backgroundColor:'gray'
  }
});

AppRegistry.registerComponent('MoreDrawerOptionsScreen', () => MoreDrawerOptionsScreen);

module.exports = MoreDrawerOptionsScreen;
