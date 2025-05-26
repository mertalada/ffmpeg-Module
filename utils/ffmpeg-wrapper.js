import { NativeModules, Platform } from 'react-native';

let NativeFFmpeg;

if (Platform.OS === 'ios') {
  NativeFFmpeg = NativeModules.FfmpegKitIosFullGpl; // iOS için podspec'te verdiğin ad
} else if (Platform.OS === 'android') {
  NativeFFmpeg = NativeModules.FfmpegKitFullGpl; // Android için AAR ile verdiğin ad
}

if (!NativeFFmpeg) {
  console.error(`[FFmpegKit] Native module not found for platform: ${Platform.OS}`);
  throw new Error('FFmpegKit native module is not available.');
}

export const executeFFmpegCommand = async (command) => {
  try {
    console.log('🎬 Executing FFmpeg command:', command);
    const result = await NativeFFmpeg.execute(command);
    console.log('✅ FFmpeg execution finished:', result);
    return result;
  } catch (error) {
    console.error('❌ FFmpeg execution failed:', error);
    throw error;
  }
};
