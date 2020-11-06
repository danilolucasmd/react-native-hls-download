import { NativeModules } from 'react-native';

type HlsDownloadType = {
  setupAssetDownload(url: string): void;
  playOfflineAsset(): Promise<string>;
};

const { HlsDownload } = NativeModules;

export default HlsDownload as HlsDownloadType;
