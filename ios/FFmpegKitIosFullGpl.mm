#import <React/RCTBridgeModule.h>
#import <FFmpegKit/FFmpegKit.h>

@interface RCT_EXTERN_MODULE(FfmpegKitIosFullGpl, NSObject)
RCT_EXTERN_METHOD(execute:(NSString *)command
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
