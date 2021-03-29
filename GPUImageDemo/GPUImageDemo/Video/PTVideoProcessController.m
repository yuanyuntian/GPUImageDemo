//
//  PTVideoProcessController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/29.
//

#import "PTVideoProcessController.h"
#import <GPUImage/GPUImage.h>
//#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

@interface PTVideoProcessController ()<GPUImageMovieWriterDelegate>
{

}
@property(nonatomic, strong)GPUImageVideoCamera * videoCamera;
@property(nonatomic, strong)GPUImageOutput<GPUImageInput> * filter;
@property(nonatomic, strong)GPUImageMovieWriter * movieWriter;
@property(nonatomic, strong)NSString *pathToMovie;
@end

@implementation PTVideoProcessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频";
    self.view.backgroundColor = UIColor.whiteColor;
    [self configVideoCamera];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(IBAction)startAction:(id)sender {

    if (self.movieWriter.isPaused) {
        return;
    }
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [self.movieWriter startRecording];
    [self.videoCamera.inputCamera lockForConfiguration:nil];
    [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.videoCamera.inputCamera unlockForConfiguration];
}

-(IBAction)stopAction:(id)sender {
    if (self.movieWriter.isPaused) {
        return;
    }
    [self.filter removeTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [self.movieWriter finishRecording];

//    [self.videoCamera.inputCamera lockForConfiguration:nil];
//    [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
//    [self.videoCamera.inputCamera unlockForConfiguration];
}

- (void)writeVideoToAssetsLibrary:(NSURL *)videoURL completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler{
    
    NSString * collectionName = @"测试";
    
    
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:collectionName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                
//                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"保存视频成功!");
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
//                    [dict setObject:localIdentifier forKey:[self showFileNameFromPath:videoPath]];
//                    [self writeDicToPlist:dict];
                } else {
                    NSLog(@"保存视频失败:%@", error);
                }
            }];
        }
    }];
}

- (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
      
      // 1. 创建搜索集合
      PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
      // 2. 遍历搜索集合并取出对应的相册
      for (PHAssetCollection *assetCollection in result) {
          if ([assetCollection.localizedTitle containsString:collectionName]) {
              return assetCollection;
          }
      }
      return nil;
}


-(void)configVideoCamera {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
//    _filter = [[GPUImageSepiaFilter alloc] init];
    _filter = [GPUImageSketchFilter new];

    
    [_videoCamera addTarget:_filter];
    GPUImageView *filterView = (GPUImageView *)self.view;

    self.pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([self.pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:self.pathToMovie];
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    _movieWriter.delegate = self;
    _movieWriter.encodingLiveVideo = YES;
    [_filter addTarget:_movieWriter];
    [_filter addTarget:filterView];
    [_videoCamera startCameraCapture];
}

#pragma -Mark GPUImageMovieWriterDelegate
- (void)movieRecordingCompleted {
    NSURL *movieURL = [NSURL fileURLWithPath:self.pathToMovie];
    [self writeVideoToAssetsLibrary:movieURL completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

- (void)movieRecordingFailedWithError:(NSError*)error{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
