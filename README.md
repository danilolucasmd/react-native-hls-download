# react-native-hls-download

Download hls for offline use

## Installation

```sh
npm install react-native-hls-download
```

## Usage

```js
import HlsDownload from "react-native-hls-download";

// ...

// Setup and download
HlsDownload.setupAssetDownload('http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8'); // void

// Return the path to the local asset
HlsDownload.playOfflineAsset().then(console.warn); // string
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
