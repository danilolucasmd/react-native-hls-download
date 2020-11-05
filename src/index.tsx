import { NativeModules } from 'react-native';

type HlsDownloadType = {
  multiply(a: number, b: number): Promise<number>;
};

const { HlsDownload } = NativeModules;

export default HlsDownload as HlsDownloadType;
