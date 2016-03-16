'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  ScrollView,
  TouchableOpacity,
  AlertIOS,
  NativeAppEventEmitter
} = React;

var Controllers = require('react-native-controllers');

var FavoritesScreen = React.createClass({

  render: function() {
    return (
      <ScrollView style={styles.container}>

        <Image style={{width: undefined, height: 100}} source={require('./img/colors.png')} />

        <Text style={{fontSize: 20, textAlign: 'center', margin: 10, fontWeight: '500', marginTop: 30}}>
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

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'statushidden') }>
          <Text style={styles.button}>StatusBar Hidden</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'lightstatus') }>
          <Text style={styles.button}>Light StatusBar</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'darkstatus') }>
          <Text style={styles.button}>Dark StatusBar</Text>
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

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'rightbuttons') }>
          <Text style={styles.button}>Right NavBar Text Buttons</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'righticonbuttons') }>
          <Text style={styles.button}>Right NavBar Icon Buttons</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={ this.onButtonClick.bind(this, 'eventbuttons') }>
          <Text style={styles.button}>Event Based NavBar Buttons</Text>
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
      case 'statushidden':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            statusBarHidden: true
          }
        });
        break;
      case 'lightstatus':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          style: {
            statusBarTextColorScheme: 'light'
          }
        });
        break;
        case 'darkstatus':
          Controllers.NavigationControllerIOS("favorites").push({
            title: "More",
            component: "FavoritesScreen",
            style: {
              statusBarTextColorScheme: 'dark'
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
            navBarTranslucent: true,
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
            navBarTranslucent: true,
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
      case 'rightbuttons':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          rightButtons: [
            {
              title: "Edit",
              onPress: function() {
                AlertIOS.alert('Button', 'Edit pressed');
              }
            },
            {
              title: "Save",
              onPress: function() {
                AlertIOS.alert('Button', 'Save pressed');
              }
            }
          ]
        });
        break;
      case 'righticonbuttons':
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          rightButtons: [
            {
              icon: require('./img/navicon_edit.png'),
              onPress: function() {
                AlertIOS.alert('Button', 'Edit pressed');
              }
            },
            {
              icon: require('./img/navicon_add.png'),
              onPress: function() {
                AlertIOS.alert('Button', 'Add pressed');
              }
            }
          ]
        });
        break;
      case 'eventbuttons':
        const eventId = 'MY_UNIQUE_EVENT_ID';
        NativeAppEventEmitter.addListener(eventId, function (event) {
          switch (event.id) {
            case 'edit':
              AlertIOS.alert('Button', 'Edit pressed');
              break;
            case 'add':
              AlertIOS.alert('Button', 'Add pressed');
              break;
          }
        });
        Controllers.NavigationControllerIOS("favorites").push({
          title: "More",
          component: "FavoritesScreen",
          rightButtons: [
            {
              icon: require('./img/navicon_edit.png'),
              id: 'edit',
              onPress: eventId
            },
            {
              icon: require('./img/navicon_add.png'),
              id: 'add',
              onPress: eventId
            }
          ]
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
