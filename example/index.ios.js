'use strict';

var Controllers = require('react-native-controllers');

var React = Controllers.hijackReact();
var {
  ControllerRegistry,
  TabBarControllerIOS,
  NavigationControllerIOS,
  ViewControllerIOS,
  DrawerControllerIOS
} = React;

// require all top level react components you refer to in the layout
require('./SideMenu');
require('./MovieListScreen');
require('./SearchScreen');
require('./FavoritesScreen');
require('./ModalScreen');

var MoviesApp = Controllers.createClass({

  render: function() {
    return (
      <DrawerControllerIOS id="drawer" componentLeft="SideMenu" componentRight="SideMenu">
        <TabBarControllerIOS id="main">
          <TabBarControllerIOS.Item title="Movies" icon={require('./img/home.png')} selectedIcon={require('./img/home_selected.png')}>
            <NavigationControllerIOS
              title="Red Title"
              component="MovieListScreen"
              id="movies"
              style={{navBarTextColor: '#ff0000', drawUnderNavBar: false, drawUnderTabBar: true}}
            />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Favorites" icon={require('./img/star.png')} selectedIcon={require('./img/star_selected.png')}>
            <NavigationControllerIOS
              title="Favorites"
              component="FavoritesScreen"
              id="favorites"
              passProps={{hidePop: true}}
            />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Search" icon={require('./img/discover.png')} selectedIcon={require('./img/discover_selected.png')}>
            <ViewControllerIOS component="SearchScreen" />
          </TabBarControllerIOS.Item>
        </TabBarControllerIOS>
      </DrawerControllerIOS>
    );
  },
});

var ModalScreenTester = Controllers.createClass({
  render: function() {
    return (
      <NavigationControllerIOS
        title="Modal"
        component="ModalScreen"
        id="modal"
        leftButtons={[{
          title: "Close",
          onPress: function() {
            Controllers.Modal.dismissController();
          }
        }]}
      />
    );
  },
});

ControllerRegistry.registerController('MoviesApp', () => MoviesApp);
ControllerRegistry.registerController('ModalScreenTester', () => ModalScreenTester);

// this line makes the app actually start and initialize
ControllerRegistry.setRootController('MoviesApp');

module.exports = MoviesApp;
module.exports = ModalScreenTester;
