import * as React from 'react';
import { useState } from 'react';
import { StyleSheet, View, Button } from 'react-native';
import HlsDownload from 'react-native-hls-download';
import Video from 'react-native-video';

export default function App() {
  const [uri, setUri] = useState(
    'http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8'
  );

  const handleDownload = () => {
    HlsDownload.setupAssetDownload(
      'http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8'
    );
  };

  const handlePlay = () => {
    HlsDownload.playOfflineAsset().then((_uri) => {
      console.warn('file://' + _uri);
      setUri('file://' + _uri);
    });
  };

  return (
    <View style={styles.container}>
      <Button onPress={handleDownload} title="Download" />
      <Button onPress={handlePlay} title="Play" />
      <Video
        source={{ uri }}
        onError={console.warn}
        style={[StyleSheet.absoluteFill, { top: 400 }]}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
