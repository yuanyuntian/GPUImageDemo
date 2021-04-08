//
//  PTHaacEncoder.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import "PTHaacEncoder.h"

@interface PTHaacEncoder()
{
    
}

@property (nonatomic) AudioConverterRef audioConverter;

@property (nonatomic) uint8_t *aacBuffer;
@property (nonatomic) NSUInteger aacBufferSize;

@property (nonatomic) char *pcmBuffer;
@property (nonatomic) size_t pcmBufferSize;


@end

@implementation PTHaacEncoder

-(instancetype)init {
    if (self = [super init]) {
        _callbackQueue = dispatch_queue_create("AAC Encoder Callback Queue", DISPATCH_QUEUE_SERIAL);
        
        _audioConverter = NULL;
        
        _pcmBufferSize = 0;
        _pcmBuffer = NULL;
        
        _aacBufferSize = 1024;
        _aacBuffer = malloc(_aacBufferSize * sizeof(uint8_t));
        
        memset(_aacBuffer, 0, _aacBufferSize);
    }
    return self;
}

- (void) encode:(CMSampleBufferRef)sampleBuffer {
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if (!_audioConverter) {
        [self setupEncoderFromSampleBuffer:sampleBuffer];
    }
    
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    if (blockBuffer == nil) {
        return;
    }
    
    CFRetain(blockBuffer);
    OSStatus status = CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &_pcmBufferSize, &_pcmBuffer);
    NSError *error = nil;
    if (status != kCMBlockBufferNoErr) {
        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
    
    memset(_aacBuffer, 0, _aacBufferSize);
    AudioBufferList outAudioBufferList = {0};
    outAudioBufferList.mNumberBuffers = 1;
    outAudioBufferList.mBuffers[0].mNumberChannels = 2;
    outAudioBufferList.mBuffers[0].mDataByteSize = (UInt32)_aacBufferSize;
    outAudioBufferList.mBuffers[0].mData = _aacBuffer;
    AudioStreamPacketDescription *outPacketDescription = NULL;
    UInt32 ioOutputDataPacketSize = 1;
    status = AudioConverterFillComplexBuffer(_audioConverter,
                                             inInputDataProc,
                                             (__bridge void *)(self),
                                             &ioOutputDataPacketSize,
                                             &outAudioBufferList,
                                             outPacketDescription);
    NSData *data = nil;
    if (status == 0) {
        NSData *rawAAC = [NSData dataWithBytes:outAudioBufferList.mBuffers[0].mData length:outAudioBufferList.mBuffers[0].mDataByteSize];
//            NSData *adtsHeader = [self adtsDataForPacketLength:rawAAC.length];
//            NSMutableData *fullData = [NSMutableData dataWithData:adtsHeader];
//            [fullData appendData:rawAAC];
        data = rawAAC;
    } else {
        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
    
    if (self.delegate != nil) {
        dispatch_async(_callbackQueue, ^{
            [self.delegate gotAACEncodedData:data timestamp:timestamp error:error];
        });
    }
    
    CFRelease(blockBuffer);
}

#pragma mark - 设置属性

- (void) setupEncoderFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    AudioStreamBasicDescription inAudioStreamBasicDescription = *CMAudioFormatDescriptionGetStreamBasicDescription((CMAudioFormatDescriptionRef) CMSampleBufferGetFormatDescription(sampleBuffer));
    
//    inAudioStreamBasicDescription.mFormatID = kAudioFormatLinearPCM;
    inAudioStreamBasicDescription.mSampleRate = 44100;
//    inAudioStreamBasicDescription.mChannelsPerFrame = 1;
////    inAudioStreamBasicDescription.mBitsPerChannel = 16;
////    inAudioStreamBasicDescription.mBytesPerFrame = 2;
//    inAudioStreamBasicDescription.mBytesPerPacket = inAudioStreamBasicDescription.mBytesPerFrame * inAudioStreamBasicDescription.mFramesPerPacket;
//    inAudioStreamBasicDescription.mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsNonInterleaved;
//    inAudioStreamBasicDescription.mReserved = 0;
    
    AudioStreamBasicDescription outAudioStreamBasicDescription = {0}; // Always initialize the fields of a new audio stream basic description structure to zero, as shown here: ...
    outAudioStreamBasicDescription.mSampleRate = inAudioStreamBasicDescription.mSampleRate; // The number of frames per second of the data in the stream, when the stream is played at normal speed. For compressed formats, this field indicates the number of frames per second of equivalent decompressed data. The mSampleRate field must be nonzero, except when this structure is used in a listing of supported formats (see “kAudioStreamAnyRate”).
    outAudioStreamBasicDescription.mFormatID = kAudioFormatMPEG4AAC; // kAudioFormatMPEG4AAC_HE does not work. Can't find `AudioClassDescription`. `mFormatFlags` is set to 0.
    outAudioStreamBasicDescription.mFormatFlags = kMPEG4Object_AAC_LC; // Format-specific flags to specify details of the format. Set to 0 to indicate no format flags. See “Audio Data Format Identifiers” for the flags that apply to each format.
    outAudioStreamBasicDescription.mBytesPerPacket = 0; // The number of bytes in a packet of audio data. To indicate variable packet size, set this field to 0. For a format that uses variable packet size, specify the size of each packet using an AudioStreamPacketDescription structure.
    outAudioStreamBasicDescription.mFramesPerPacket = 1024; // The number of frames in a packet of audio data. For uncompressed audio, the value is 1. For variable bit-rate formats, the value is a larger fixed number, such as 1024 for AAC. For formats with a variable number of frames per packet, such as Ogg Vorbis, set this field to 0.
    outAudioStreamBasicDescription.mBytesPerFrame = 0; // The number of bytes from the start of one frame to the start of the next frame in an audio buffer. Set this field to 0 for compressed formats. ...
    outAudioStreamBasicDescription.mChannelsPerFrame = 2; // The number of channels in each frame of audio data. This value must be nonzero.
    outAudioStreamBasicDescription.mBitsPerChannel = 0; // ... Set this field to 0 for compressed formats.
    outAudioStreamBasicDescription.mReserved = 0; // Pads the structure out to force an even 8-byte alignment. Must be set to 0.
    
    AudioClassDescription *description = [self getAudioClassDescriptionWithType:kAudioFormatMPEG4AAC
                                                               fromManufacturer:kAppleSoftwareAudioCodecManufacturer];
    OSStatus status = AudioConverterNewSpecific(&inAudioStreamBasicDescription,
                                                &outAudioStreamBasicDescription,
                                                1,
                                                description,
                                                &_audioConverter);
    if (status != 0) {
        NSLog(@"setup converter: %d", (int)status);
    }
    
//    UInt32 bitRate = 64000;
//    UInt32 uiSize = sizeof(bitRate);
//    status = AudioConverterSetProperty(_audioConverter, kAudioConverterEncodeBitRate, uiSize, &bitRate);
//
//    UInt32 value = 0;
//    uiSize = sizeof(value);
//    AudioConverterGetProperty(_audioConverter, kAudioConverterPropertyMaximumOutputPacketSize, &uiSize, &value);
//    NSLog(@"packet size = %d", value);
}

- (AudioClassDescription *)getAudioClassDescriptionWithType:(UInt32)type fromManufacturer:(UInt32)manufacturer {
    static AudioClassDescription desc;
    
    UInt32 encoderSpecifier = type;
    OSStatus st;
    
    UInt32 size;
    st = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders,
                                    sizeof(encoderSpecifier),
                                    &encoderSpecifier,
                                    &size);
    if (st) {
        NSLog(@"error getting audio format propery info: %d", (int)(st));
        return nil;
    }
    
    unsigned int count = size / sizeof(AudioClassDescription);
    AudioClassDescription descriptions[count];
    st = AudioFormatGetProperty(kAudioFormatProperty_Encoders,
                                sizeof(encoderSpecifier),
                                &encoderSpecifier,
                                &size,
                                descriptions);
    if (st) {
        NSLog(@"error getting audio format propery: %d", (int)(st));
        return nil;
    }
    
    for (unsigned int i = 0; i < count; i++) {
        if ((type == descriptions[i].mSubType) &&
            (manufacturer == descriptions[i].mManufacturer)) {
            memcpy(&desc, &(descriptions[i]), sizeof(desc));
            return &desc;
        }
    }
    
    return nil;
}

#pragma mark - 回调

static OSStatus inInputDataProc(AudioConverterRef inAudioConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription **outDataPacketDescription, void *inUserData) {
    PTHaacEncoder *encoder = (__bridge PTHaacEncoder *)(inUserData);
    UInt32 requestedPackets = *ioNumberDataPackets;
    NSLog(@"Number of packets requested: %d", (unsigned int)requestedPackets);
    size_t copiedSize = [encoder copyPCMBuffer:ioData];
    if (copiedSize < requestedPackets * 2) {
        NSLog(@"PCM buffer isn't full enough!");
        *ioNumberDataPackets = 0;
        return -1;
    }
    
    *ioNumberDataPackets = requestedPackets;
    
    NSLog(@"Copied %zu samples into ioData", copiedSize);
    return noErr;
}

- (size_t) copyPCMBuffer:(AudioBufferList*)ioData {
    size_t originalBufferSize = _pcmBufferSize;
    if (!originalBufferSize) {
        return 0;
    }
    ioData->mBuffers[0].mData = _pcmBuffer;
    ioData->mBuffers[0].mDataByteSize = (UInt32)_pcmBufferSize;
    _pcmBuffer = NULL;
    _pcmBufferSize = 0;
    return originalBufferSize;
}



- (void) dealloc {
    AudioConverterDispose(_audioConverter);
    free(_aacBuffer);
}

@end
