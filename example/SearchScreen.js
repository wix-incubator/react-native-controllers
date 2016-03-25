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

var Controllers = require('react-native-controllers');
var { Modal } = Controllers;

var badgeCounter = 1;

var SearchScreen = React.createClass({

  getInitialState: function() {
    return {
      tabBarHidden: false
    }
  },

  render: function() {
    return (
      <View style={styles.container}>

        <ScrollView>
          <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
            No NavBar Example
          </Text>

          <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
            This screen isn't wrapped with a UINavigationController at all, so there's no NavBar
          </Text>

          <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 30}}>
            Tabs Example
          </Text>

          <TouchableOpacity onPress={ this.onSwitchByIndexClick }>
            <Text style={styles.button}>Switch to Tab#1 (by tab index)</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={ this.onSwitchByIdClick }>
            <Text style={styles.button}>Switch to Tab#1 (by content id)</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={ this.onStyledTabsClick }>
            <Text style={styles.button}>Styled Tab Bar</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={ this.onToggleTabBarClick }>
            <Text style={styles.button}>Toggle tab-bar</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={ this.onBadgeByIndexClick }>
            <Text style={styles.button}>Set Badge (by tab index)</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={ this.onBadgeByIdClick }>
            <Text style={styles.button}>Set Badge (by content id)</Text>
          </TouchableOpacity>

        </ScrollView>

        <View style={{height: 30, position: 'absolute', bottom: 0, left: 0, right: 0}}>
          {
            this.state.tabBarHidden ?
            <Text style={{ height: 30, color: 'red', backgroundColor: '#ffcccc', textAlign: 'center'}}>Wink wink</Text>
            : false
          }
        </View>
      </View>
    );
  },
  onToggleTabBarClick: async function() {
    this.setState({
      tabBarHidden: !this.state.tabBarHidden
    });
    Controllers.TabBarControllerIOS("main").setHidden({hidden: this.state.tabBarHidden, animated: true});
  },
  onSwitchByIndexClick: function() {
    Controllers.TabBarControllerIOS("main").switchTo({
      tabIndex: 0
    });
  },
  onSwitchByIdClick: function() {
    Controllers.TabBarControllerIOS("main").switchTo({
      contentId: "movies_nav",
      contentType: "NavigationControllerIOS"
    });
  },
  onBadgeByIndexClick: function() {
    Controllers.TabBarControllerIOS("main").setBadge({
      tabIndex: 0,
      badge: badgeCounter++
    });
  },
  onBadgeByIdClick: function() {
    Controllers.TabBarControllerIOS("main").setBadge({
      contentId: "movies_nav",
      contentType: "NavigationControllerIOS",
      badge: badgeCounter++
    });
  },
  onStyledTabsClick: function() {
    Modal.showController('TabStyleTester');
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
    marginTop:10,
    color: 'blue'
  }
});

AppRegistry.registerComponent('SearchScreen', () => SearchScreen);

module.exports = SearchScreen;
