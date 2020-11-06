#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HlsDownload, NSObject)

RCT_EXTERN_METHOD(setupAssetDownload:(NSString *)url)

RCT_EXTERN_METHOD(playOfflineAsset:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)

@end
