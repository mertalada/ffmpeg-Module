import Foundation
import ffmpegkit

@objc(FfmpegKitIosFullGpl)
class FfmpegKitIosFullGpl: NSObject {

  @objc
  func execute(_ command: String,
               resolver resolve: @escaping RCTPromiseResolveBlock,
               rejecter reject: @escaping RCTPromiseRejectBlock) {
    FFmpegKit.executeAsync(command) { session in
      let returnCode = session?.getReturnCode()
      if returnCode?.isValueSuccess() == true {
        resolve("success")
      } else {
        reject("FFMPEG_ERROR", "iOS FFmpeg failed", nil)
      }
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
}
