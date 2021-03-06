//
//  LMLivePreview.m
//  LFLiveKit
//
//  Created by 倾慕 on 16/5/2.
//  Copyright © 2016年 live Interactive. All rights reserved.
//

#import "LMLivePreview.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"
#import "LFLiveSession.h"
#import <Masonry/Masonry.h>
@interface LMLivePreview ()<LFLiveSessionDelegate>

@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *startLiveButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) LFLiveDebug *debugInfo;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation LMLivePreview


-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];

        self.containerView = [UIView new];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
        self.stateLabel.text = @"未连接";
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [self.containerView addSubview:self.stateLabel];

        self.closeButton = [UIButton new];
        self.closeButton.size = CGSizeMake(44, 44);
        self.closeButton.left = self.width - 10 - _closeButton.width;
        self.closeButton.top = 20;
        [self.closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        self.closeButton.exclusiveTouch = YES;
        [self.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            
        }];
        [self.containerView addSubview:self.closeButton];

        self.cameraButton = [UIButton new];
        self.cameraButton.size = CGSizeMake(44, 44);
        self.cameraButton.origin = CGPointMake(_closeButton.left - 10 - _cameraButton.width, 20);
        [self.cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        self.cameraButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [self.cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        }];
        [self.containerView addSubview:self.cameraButton];

        
        self.beautyButton = [UIButton new];
        self.beautyButton.size = CGSizeMake(44, 44);
        self.beautyButton.origin = CGPointMake(_cameraButton.left - 10 - _beautyButton.width,20);
        [self.beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
        [self.beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
        self.beautyButton.exclusiveTouch = YES;
        [self.beautyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.session.beautyFace = !_self.session.beautyFace;
            _self.beautyButton.selected = !_self.session.beautyFace;
        }];
        [self.containerView addSubview:self.beautyButton];

        self.startLiveButton = [UIButton new];
        self.startLiveButton.size = CGSizeMake(self.width - 60, 44);
        self.startLiveButton.left = 30;
        self.startLiveButton.bottom = self.height - 50;
        self.startLiveButton.layer.cornerRadius = _startLiveButton.height/2;
        [self.startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [self.startLiveButton setBackgroundColor:[UIColor colorWithRed:50 green:32 blue:245 alpha:1]];
        self.startLiveButton.exclusiveTouch = YES;
        [self.startLiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.startLiveButton.selected = !_self.startLiveButton.selected;
            if(_self.startLiveButton.selected){
                [_self.startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
                LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
                stream.url = @"rtmp://172.18.12.79:2002/rtmplive/demo";
                //stream.url = @"rtmp://daniulive.com:1935/live/stream2399";
                [_self.session startLive:stream];
            }else{
                [_self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
                [_self.session stopLive];
            }
        }];
        [self.containerView addSubview:self.startLiveButton];

        [self requestAccessForVideo];
        [self requestAccessForAudio];
        
    }
    return self;
}

-(void)updateConstraints {
    [super updateConstraints];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.containerView).offset(20);
    }];
    
    [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).offset(-20);
        make.top.equalTo(self.containerView).offset(20);
        make.width.height.equalTo(@44);
    }];
    
    [self.cameraButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.closeButton.mas_left).offset(-10);
        make.top.equalTo(self.containerView).offset(20);
        make.width.height.equalTo(@44);
    }];
    
    [self.beautyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cameraButton.mas_left).offset(-10);
        make.top.equalTo(self.containerView).offset(20);
        make.width.height.equalTo(@44);
    }];
    
    [self.startLiveButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).offset(-20);
        make.left.equalTo(self.containerView).offset(20);
        make.height.equalTo(@50);
        if (@available(iOS 11.0,*)){
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            
        }else{
            make.bottom.equalTo(self.containerView).offset(-20);
        }
    }];
    
    
}



#pragma mark -- Public Method
- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            //dispatch_async(dispatch_get_main_queue(), ^{
            [_self.session setRunning:YES];
            //});
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}


#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"liveStateDidChange: %ld", state);
    switch (state) {
        case LFLiveReady:
            _stateLabel.text = @"未连接";
            break;
        case LFLivePending:
            _stateLabel.text = @"连接中";
            break;
        case LFLiveStart:
            _stateLabel.text = @"已连接";
            break;
        case LFLiveError:
            _stateLabel.text = @"连接错误";
            break;
        case LFLiveStop:
            _stateLabel.text = @"未连接";
            break;
        default:
            break;
    }
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    NSLog(@"debugInfo: %lf", debugInfo.dataFlow);
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark -- Getter Setter
- (LFLiveSession*)session{
    if(!_session){
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        
        
        
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2 outputImageOrientation:UIInterfaceOrientationPortrait]];
        

        /**    自己定制单声道  */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 1;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_64Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K 分辨率设置为540*960 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(540, 960);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 24;
         videoConfiguration.videoMaxKeyframeInterval = 48;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向横屏  */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(1280, 720);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = YES;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        _session.delegate = self;
        _session.preView = self;
    }
    return _session;
}


@end
