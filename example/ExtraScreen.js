'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
	AppRegistry,
	StyleSheet,
	Text,
	View,
	Image,
	ScrollView,
	TouchableHighlight,
	TouchableOpacity,
	SegmentedControlIOS,
	Dimensions,
	TextInput
} = ReactNative;

var Controllers = require('react-native-controllers');
const {NavigationToolBarIOS} = Controllers;
var {height, width} = Dimensions.get('window');



var ExtraScreen = React.createClass({

	getInitialState: function() {
		return({
			isNavBarHidden : false,
			segmentIndexSelected: 0,
			renderOnToolBar: 'segmented'
		});
	},

	render: function() {
		return (
			<View style={styles.container}>

				<ScrollView style={styles.container} >
					<Image style={ styles.image }
					       source={require('./img/colors.png')} />

					<Text style={styles.textInList}
					>
						Extra Example
					</Text>
					<Text style={styles.text}>Segmented Index Selected: {this.state.segmentIndexSelected}</Text>

					<TouchableOpacity onPress={ this.onButtonClick.bind(this, 'surprise') }>
						<Text style={styles.listButton}>Surprise me</Text>
					</TouchableOpacity>

					<Image style={styles.image}
					       source={require('./img/colors.png')} />

					<Text style={styles.textInList}
					>
						Extra Cool
					</Text>

					<Image style={styles.image}
					       source={require('./img/colors.png')} />

				</ScrollView>
				{this.renderToolBar()}
			</View>
		);
	},

	renderToolBar: function() {
		if (this.state.renderOnToolBar === 'segmented') {
			return (
				<NavigationToolBarIOS key='segmented' translucent={true}
			                style={styles.toolBarStyle}>

					<SegmentedControlIOS
						values={['One', 'Two', 'Three']}
						selectedIndex={this.state.segmentIndexSelected}
						style={styles.segmentedControl}
						onChange={(event) => {
								                this.setState({segmentIndexSelected : event.nativeEvent.selectedSegmentIndex});
						}}
					/>
					<View style={styles.lineBorder}/>
				</NavigationToolBarIOS>
			)
		} else if(this.state.renderOnToolBar === 'search') {
			return (
				<NavigationToolBarIOS key='search' style={styles.searchBar }>
					<View style={{flex: 1, flexDirection: 'row'}}>
						<TextInput
							style={styles.textInput}
							onChangeText={(text) => this.setState({text})}
							value={this.state.text}
						/>
						<TouchableHighlight
							style={styles.toolBarButton}
							onChangeText={(text) => this.setState({text})}
							value={this.state.text}>
							<Text style={styles.textSearch}>Search</Text>
						</TouchableHighlight>
					</View>
					<View style={styles.lineBorder}/>
				</NavigationToolBarIOS>
			)
		}
	},

	onPopClick: function() {
		Controllers.NavigationControllerIOS("favorites_nav").pop();
	},

	onButtonClick: function(cmd) {
		switch (cmd) {
      case 'surprise':

				this.setState({renderOnToolBar: (this.state.renderOnToolBar === 'search') ? 'segmented' : 'search'});
        const isNavigationBarHidden = this.state.renderOnToolBar === 'search';
        Controllers.NavigationControllerIOS("favorites_nav").setHidden({
          hidden:isNavigationBarHidden,
          animated: true //default is true
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
	listButton: {
		textAlign: 'center',
		fontSize: 18,
		marginBottom: 10,
		marginTop:10,
		color: 'blue'
	},
	toolBarButton: {
		width: width*0.13,
		height: 28,
		marginBottom: 8,
		marginLeft: 8,
		marginRight: 8,
		marginTop: 28,
		alignItems: 'center'
	},
	text: {
		textAlign: 'center',
		fontSize: 18,
		marginBottom: 10,
		marginTop:10
	},
	toolBarStyle: {
		top: 44,
		width: width,
		height: 64,
		position: 'absolute',
	},
  searchBar:{
    top: 0,
    width: width,
    height: 64,
    position: 'absolute',
  },
	textInput: {
		width: width*0.87,
		height: 28,
		marginBottom: 8,
		marginLeft: 8,
		marginRight: 8,
		marginTop: 28,
		borderRadius: 8,
		flex: 1,
		paddingLeft: 10,
		fontSize: 17,
		backgroundColor: 'white',
		borderColor: '#c7c7cc',
		borderWidth: 0.5
	},
	textInList: {
		fontSize: 20,
		textAlign: 'center',
		margin: 10,
		fontWeight: '500',
		marginTop: 90,
		marginBottom: 90
	},
	segmentedControl: {
		marginBottom: 8,
		marginLeft: 8,
		marginRight: 8,
		marginTop: 28,
	},
	lineBorder: {
		height:0.5,
		backgroundColor:'#ABB0B2'
	},
	textSearch: {
		textAlign: 'center',
		color: 'blue'
	},
	image: {
		width: undefined,
		height: 120
	}
});

AppRegistry.registerComponent('ExtraScreen', () => ExtraScreen);

module.exports = ExtraScreen;
