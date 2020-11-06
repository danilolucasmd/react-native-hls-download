import * as React from 'react';
import { StyleSheet, View, Button } from 'react-native';
import HlsDownload from 'react-native-hls-download';

export default function App() {
  const handleDownload = () => {
    HlsDownload.setupAssetDownload(
      'http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8'
    );
  };

  const handlePlay = () => {
    HlsDownload.playOfflineAsset().then(console.warn);
  };

  return (
    <View style={styles.container}>
      <Button onPress={handleDownload} title="Download" />
      <Button onPress={handlePlay} title="Play" />
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
