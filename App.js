import React, {useState} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  View,
  Text,
  StatusBar,
  NativeModules,
  TouchableOpacity,
} from 'react-native';

import {Icon} from 'react-native-elements';
// we import our native module
const {WebServerManager} = NativeModules;

const App: () => React$Node = () => {
  const [endpoint, setEndpint] = useState('');
  const [isServerRunning, setServerState] = useState(false);

  const startServer = () => {
    WebServerManager.startServer()
      .then(url => setEndpint(url))
      .then(() => setServerState(true))
      .catch(err => console.error(err));
  };

  const stopServer = () => {
    WebServerManager.stopServer();
    setEndpint('');
    setServerState(false);
  };

  return (
    <>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={styles.safeView}>
        <View style={styles.infoBlock}>
          <Text style={styles.text}>
            Press button to turn {isServerRunning ? 'Off' : 'On'} server
          </Text>
        </View>
        <View style={styles.container}>
          <TouchableOpacity>
            <Icon
              raised
              name="power-off"
              type="font-awesome"
              color={isServerRunning ? '#01b907' : '#f44336'}
              onPress={() => (isServerRunning ? stopServer() : startServer())}
            />
          </TouchableOpacity>
        </View>
        {isServerRunning ? (
          <View style={styles.container}>
            <Text style={{...styles.text, ...styles.urlEndpoint}}>
              Server is available at this Url : {endpoint}
            </Text>
          </View>
        ) : (
          <View style={styles.container} />
        )}
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  safeView: {
    backgroundColor: '#282c34',
    height: '100%',
  },
  urlEndpoint: {
    paddingTop: 20,
  },
  text: {
    color: '#FFF',
    fontWeight: '900',
    fontSize: 20,
    textAlign: 'center',
  },
  infoBlock: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default App;
