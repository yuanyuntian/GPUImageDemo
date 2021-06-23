//
//  PTImageEditViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/15.
//

#import "PTImageEditViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TYCyclePagerView/TYCyclePagerView-umbrella.h>
#import <Masonry/Masonry.h>
#import "TYCyclePagerViewCell.h"
#import "PTImageEffectManager.h"
#import "PTViewEffectFilters.h"

@interface PTImageEditViewController ()<TZImagePickerControllerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
@property(nonatomic, strong) UIButton * add;
@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, strong) TYCyclePagerView * menu;
@property(nonatomic, strong) NSArray * items;
@property(nonatomic, strong) UIImage * sourceImage;

@property(nonatomic, strong) UISlider * slider1;

@property(nonatomic, strong) UISlider * slider2;

@property(nonatomic, strong) UISlider * slider3;

@property(nonatomic, assign) NSInteger  currentIndex;

@end

@implementation PTImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    self.slider1 = [[UISlider alloc] init];
    self.slider1.minimumValue = 0.0;
    self.slider1.tag = 0;
    [self.view addSubview:self.slider1];
    [self.slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(self.view).offset(20);
    }];
    [self.slider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider1 setContinuous:true];

    
    self.slider2 = [[UISlider alloc] init];
    self.slider2.minimumValue = 0.0;
    self.slider2.tag = 1;
    [self.view addSubview:self.slider2];
    [self.slider2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.slider1);
        make.top.equalTo(self.slider1.mas_bottom).offset(20);
    }];
    [self.slider2 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider2 setContinuous:true];

    self.slider3 = [[UISlider alloc] init];
    self.slider3.minimumValue = 0.0;
    self.slider3.tag = 2;
    [self.view addSubview:self.slider3];
    [self.slider3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.slider1);
        make.top.equalTo(self.slider2.mas_bottom).offset(20);
    }];
    [self.slider3 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider3 setContinuous:true];

    self.add = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.add setTitle:@"添加图片" forState:UIControlStateNormal];
    [self.add setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.add addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.add];
    [self.add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@100);
    }];
    
    self.items = @[@"素描",@"阀值素描，形成有噪点的素描",@"卡通效果（黑色粗线描边)",@"卡通效果平滑",@"桑原(Kuwahara)滤波,水粉画的模糊效果",@"漩涡",@"鱼眼效果",@"凹面镜",@"水晶球效果",@"浮雕效果3d",@"锐化",@"背景模糊",@"漫画反色"];//@"Instagram风格"];
    [self.view addSubview:self.menu];
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0,*)){
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
        make.height.mas_equalTo(80);
    }];
    self.currentIndex = INT_MAX;
    [self.menu reloadData];
}

-(void)sliderValueChanged:(UISlider *)slider
{
    if (self.sourceImage == nil || self.currentIndex == INT_MAX) {
        return;
    }
    [self processImage:self.currentIndex];
}


-(TYCyclePagerView*)menu {
    if (_menu == nil) {
        _menu = [TYCyclePagerView new];
        _menu.isInfiniteLoop = false;
        _menu.autoScrollInterval = 0;
        _menu.delegate = self;
        _menu.dataSource = self;
        [_menu registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _menu;
}


-(IBAction)addImageAction:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:0 columnNumber:4 delegate:self pushPhotoPickerVc:true];
    imagePickerVc.allowTakeVideo = false;
//    imagePickerVc.videoMaximumDuration = 20;
    imagePickerVc.allowPickingVideo = false;
    imagePickerVc.allowPickingImage = true;
    imagePickerVc.showSelectedIndex = true;
    imagePickerVc.allowPreview = false;
    imagePickerVc.maxImagesCount = 1;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.sourceImage = photos.firstObject;
        self.imageView.image = self.sourceImage;
        self.add.hidden = true;
    }];
}





- (nonnull TYCyclePagerViewLayout *)layoutForPagerView:(nonnull TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
    layout.itemSpacing = 4;
    //layout.minimumAlpha = 0.3;
    return layout;
}

- (NSInteger)numberOfItemsInPagerView:(nonnull TYCyclePagerView *)pageView {
    return self.items.count;
}

- (nonnull __kindof UICollectionViewCell *)pagerView:(nonnull TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.backgroundColor = UIColor.redColor;
    cell.label.text =self.items[index];
    return cell;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    self.slider1.value = 0;
    self.slider2.value = 0;
    self.slider3.value = 0;

    if (self.sourceImage == nil) {
        return;
    }
    self.imageView.image = self.sourceImage;
    self.currentIndex = index;
    [self setSliderConfig:index];
//    self.imageView.image = [[PTImageEffectManager shareInstance] visualEffectImage:self.sourceImage withType:index];
}

-(void)setSliderConfig:(NSInteger)index {
    switch (index) {
        case 0:
            self.slider1.maximumValue = 0.01;
            self.slider2.maximumValue = 0.01;
            self.slider3.maximumValue = 10;
            break;
        case 1:
            self.slider1.maximumValue = 1;
            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;

            break;
        case 2:
            self.slider1.maximumValue = 1;
            self.slider2.maximumValue = 10;
            
            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = true;
            break;
        case 3:
            self.slider1.maximumValue = 5;
            self.slider2.maximumValue = 1;
            self.slider3.maximumValue = 100;
            
            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = false;
            break;
        case 4:
            self.slider1.maximumValue = 5;
            self.slider2.maximumValue = 1;
            self.slider3.maximumValue = 20;
            
            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;
            break;
        case 5:
            self.slider1.maximumValue = 1;
            self.slider2.maximumValue = 1;
            
            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = true;
            break;
        case 6:
            self.slider1.maximumValue = 1;
            self.slider2.maximumValue = 1;
            self.slider2.minimumValue = -1;

            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = true;
            break;
        case 7:
            self.slider1.maximumValue = 2;
            self.slider2.maximumValue = 2;
            self.slider2.minimumValue = -2;

            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = true;
            break;
        case 8:
            self.slider1.maximumValue = 1;
            self.slider2.maximumValue = 1;

            self.slider1.hidden = false;
            self.slider2.hidden = false;
            self.slider3.hidden = true;
            break;
        case 9:
            self.slider1.maximumValue = 4;

            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;
            break;
        case 10:
            self.slider1.maximumValue = 4;
            self.slider1.minimumValue = -4;

            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;
            break;
        case 11:
            self.slider1.maximumValue = 20;

            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;
            break;
        case 12:
            self.slider1.maximumValue = 10;

            self.slider1.hidden = false;
            self.slider2.hidden = true;
            self.slider3.hidden = true;
            break;
        default:
            break;
    }
}

-(void)processImage:(NSInteger)index {
    switch (index) {
        case 0:
            self.imageView.image = [PTViewEffectFilters sketchFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value isAuto:false];
            break;
        case 1:
            self.imageView.image = [PTViewEffectFilters thresholdSketchFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        case 2:
            self.imageView.image = [PTViewEffectFilters cartoonFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value isAuto:false];
            break;
        case 3:
            self.imageView.image = [PTViewEffectFilters smoothCartoonFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value isAuto:true];
            break;
        case 4:
            self.imageView.image = [PTViewEffectFilters kuwaharaFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        case 5:
            self.imageView.image = [PTViewEffectFilters swirlFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value isAuto:false];
            break;
        case 6:
            self.imageView.image = [PTViewEffectFilters bulgeDistortionFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value isAuto:false];
            break;
        case 7:
            self.imageView.image = [PTViewEffectFilters pinchDistortionFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value isAuto:false];
            break;
        case 8:
            self.imageView.image = [PTViewEffectFilters glassSphereFilter:self.sourceImage value1:self.slider1.value value2:self.slider2.value isAuto:false];
            break;
        case 9:
            self.imageView.image = [PTViewEffectFilters embossFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        case 10:
            self.imageView.image = [PTViewEffectFilters sharpenFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        case 11:
            self.imageView.image = [PTViewEffectFilters bilateralFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        case 12:
            self.imageView.image = [PTViewEffectFilters sobelEdgeDetectionFilter:self.sourceImage value1:self.slider1.value isAuto:false];
            break;
        default:
            break;
    }
}


@end
