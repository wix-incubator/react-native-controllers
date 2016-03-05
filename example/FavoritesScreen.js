'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  ScrollView,
  TouchableOpacity
} = React;

var Controllers = require('react-native-controllers');

var FavoritesScreen = React.createClass({

  render: function() {
    return (
      <ScrollView style={styles.container}>

        <Image style={{width: undefined, height: 100}} source={require('./img/colors.png')} />

        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 50}}>
          Styling Example
        </Text>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 20}}>
          There are a lot of styling options supported, scroll down to see them all in action. The images are here to help visualize colorful content with these styles.
        </Text>

        {
          this.props.hidePop ? false :
          <TouchableOpacity onPress={ this.onPopClick }>
            <Text style={styles.button}>Pop</Text>
          </TouchableOpacity>
        }

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'plain') }>
          <Text style={styles.button}>Push Plain Screen</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navcolors') }>
          <Text style={styles.button}>NavBar Colors</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'underboth') }>
          <Text style={styles.button}>Draw Under NavBar & TabBar</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'blurstatus') }>
          <Text style={styles.button}>Blur StatusBar (& hide NavBar)</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'blurnav') }>
          <Text style={styles.button}>Blur Entire NavBar (& draw under it)</Text>
        </TouchableOpacity>

        <Text style={{fontSize: 16, textAlign: 'center', marginHorizontal: 30, marginBottom: 10, marginTop: 20}}>
          More styles under the image
        </Text>

        <Image style={{width: undefined, height: 100}} source={require('./img/colors.png')} />

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'undernav') }>
          <Text style={styles.button}>Draw Under NavBar Only</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'undertab') }>
          <Text style={styles.button}>Draw Under TabBar Only</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navhidden') }>
          <Text style={styles.button}>NavBar Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navnothidden') }>
          <Text style={styles.button}>NavBar Not Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navstatushidden') }>
          <Text style={styles.button}>NavBar & StatusBar Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navscrollhidden') }>
          <Text style={styles.button}>NavBar Hide On Scroll</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'navstatusscrollhidden') }>
          <Text style={styles.button}>NavBar & StatusBar Hide On Scroll</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'tabhidden') }>
          <Text style={styles.button}>TabBar Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'tabnothidden') }>
          <Text style={styles.button}>TabBar Not Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'backnotext') }>
          <Text style={styles.button}>Empty Back Button Text</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'backcustomtext') }>
          <Text style={styles.button}>Custom Back Button Text</Text>
        </TouchableOpacity>

        <Image style={{width: undefined, height: 100}} source={require('./img/colors.png')} />

      </ScrollView>
    );
  },

  onPopClick: function() {
    Controllers.NavigationControllerIOS("favorites").pop();
  },

  onButtonClick: function(cmd) {
    switch (cmd) {
      case 'plain':
        require('./PushedScreen'); // help the react bundler understand we want this file included
        Controllers.NavigationControllerIOS("favorites").push({
          title: "Pushed screen",
          component: "PushedScreen",
          animated: true
        });
        break;
      case 'navcolors':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarBackgroundColor: '#ffc0c0',
            navBarButtonColor: '#00a000',
            navBarTextColor: '#ffff00'
          }
        });
        break;
      case 'navhidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarHidden: true
          }
        });
        break;
      case 'navstatushidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarHidden: true,
            statusBarHideWithNavBar: true
          }
        });
        break;
      case 'navnothidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarHidden: false
          }
        });
        break;
      case 'navscrollhidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarHideOnScroll: true
          }
        });
        break;
      case 'navstatusscrollhidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarHideOnScroll: true,
            statusBarHideWithNavBar: true
          }
        });
        break;
      case 'tabhidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            tabBarHidden: true
          }
        });
        break;
      case 'tabnothidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            tabBarHidden: false
          }
        });
        break;
      case 'undernav':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            drawUnderNavBar: true,
            drawUnderTabBar: false
          }
        });
        break;
      case 'undertab':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            drawUnderNavBar: false,
            drawUnderTabBar: true
          }
        });
        break;
      case 'underboth':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            drawUnderNavBar: true,
            drawUnderTabBar: true
          }
        });
        break;
      case 'blurstatus':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            statusBarBlur: true,
            navBarHidden: true
          }
        });
        break;
      case 'blurnav':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            navBarBlur: true,
            drawUnderNavBar: true
          }
        });
        break;
      case 'backnotext':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          backButtonTitle: ""
        });
        break;
      case 'backcustomtext':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          backButtonTitle: "Hello"
        });
        break;
    }
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

AppRegistry.registerComponent('FavoritesScreen', () => FavoritesScreen);

module.exports = FavoritesScreen;
