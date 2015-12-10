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

var MoviesApp = Controllers.createClass({

  render: function() {
    return (
      <DrawerControllerIOS id="drawer" componentLeft="SideMenu" componentRight="SideMenu">
        <TabBarControllerIOS id="main">
          <TabBarControllerIOS.Item title="Movies" icon="home">
            <NavigationControllerIOS title="Welcome" component="MovieListScreen" id="movies" />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Search" icon="discover">
            <ViewControllerIOS component="SearchScreen" />
          </TabBarControllerIOS.Item>
          <TabBarControllerIOS.Item title="Favorites" icon="star">
            <NavigationControllerIOS title="Favorites" component="FavoritesScreen" id="favorites" />
          </TabBarControllerIOS.Item>
        </TabBarControllerIOS>
      </DrawerControllerIOS>
    );
  },

});

ControllerRegistry.registerController('MoviesApp', () => MoviesApp);

// this line makes the app actually start and initialize
ControllerRegistry.setRootController('MoviesApp');

module.exports = MoviesApp;
