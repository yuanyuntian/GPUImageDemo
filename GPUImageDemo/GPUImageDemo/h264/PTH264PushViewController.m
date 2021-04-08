//
//  PTH264PushViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/4/8.
//

#import "PTH264PushViewController.h"
#import "PTH264Capture.h"

@interface PTH264PushViewController ()
@property(nonatomic, weak)IBOutlet UIButton * recordBtn;

@property(nonatomic, weak)IBOutlet UIView * pushView;
@property (nonatomic, strong) PTH264Capture *capture;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prev;

@end

@implementation PTH264PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self setupCature];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    // 设置窗口亮度大小  范围是0.1 - 1.0
    [[UIScreen mainScreen] setBrightness:0.8];
    // 设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;

}


-(void)setupCature {
    self.capture = [[PTH264Capture alloc] initCameraWithOutputSize:CGSizeMake(480, 640) resolution:AVCaptureSessionPreset640x480];
    self.capture.previewLayer.frame = self.view.bounds;
    self.capture.orientation = AVCaptureVideoOrientationPortrait;
    [self.pushView.layer addSublayer:self.capture.previewLayer];
    [self.capture startCapture];
}

- (IBAction)segmentSwitch:(id)sender {
    //推流的过程中禁止切换
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger index = segmentedControl.selectedSegmentIndex;
    [self.capture swapResolution:[self captureSessionPreset:index]];
    [self.capture setOutputSize:[self captureSessionSize:index]];
}

- (AVCaptureSessionPreset)captureSessionPreset:(NSInteger)index {
    if (index == 0) {
        return AVCaptureSessionPreset352x288;
    } else if (index == 1) {
        return AVCaptureSessionPreset640x480;
    } else if (index == 2) {
        return AVCaptureSessionPreset1280x720;
    } else{
        return AVCaptureSessionPreset1920x1080;
    }
}


- (CGSize)captureSessionSize:(NSInteger)index {
    if (index == 0) {
        return CGSizeMake(288, 352);
    } else if (index == 1) {
        return CGSizeMake(480, 640);
    } else if (index == 2) {
        return CGSizeMake(720, 1280);
    } else {
        return CGSizeMake(1080, 1920);
    }
}


-(IBAction)swapCameraAction:(id)sender {
    [self.capture swapFrontAndBackCameras];
}

-(IBAction)recordAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"录制"]) {
        [sender setTitle:@"保存" forState:UIControlStateNormal];
        [self.capture startRecord];
    }else{
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        [self.capture stopRecord];
    }
}

@end
