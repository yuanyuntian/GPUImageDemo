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
#import <GPUImage/GPUImage.h>

@interface PTImageEditViewController ()<TZImagePickerControllerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
@property(nonatomic, weak)IBOutlet UIButton * add;
@property(nonatomic, weak)IBOutlet UIImageView * imageView;
@property(nonatomic, strong) TYCyclePagerView * menu;
@property(nonatomic, strong) NSArray * items;
@property(nonatomic, strong) UIImage * sourceImage;

@end

@implementation PTImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.menu];
    self.items = @[@"素描",@"阀值素描，形成有噪点的素描",@"卡通效果（黑色粗线描边)",@"卡通效果平滑",@"桑原(Kuwahara)滤波,水粉画的模糊效果",@"黑白马赛克",@"像素化",@"同心圆像素化",@"交叉线阴影，形成黑白网状画面",@"色彩丢失，模糊（类似监控摄像效果",@"晕影，形成黑色圆形边缘，突出中间图像的效果",@"漩涡，中间形成卷曲的画面",@"凸起失真，鱼眼效果",@"收缩失真，凹面镜",@"伸展失真，哈哈镜",@"水晶球效果",@"球形折射，图形倒立",@"色调分离，形成噪点效果",@"CGA色彩滤镜，形成黑、浅蓝、紫色块的画面",@"柏林噪点，花边噪点",@"3x3卷积，高亮大色块变黑，加亮边缘、线条等",@"浮雕效果，带有点3d的感觉",@"像素圆点花样",@"点染,图像黑白化，由黑点构成原"];//@"Instagram风格"];
    [self.menu reloadData];
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

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0,*)){
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
        make.height.mas_equalTo(80);
    }];
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


-(UIImage*)hightLightImage:(UIImage*)image withType:(NSInteger)type {
    switch (type) {
        case 0:{
            //素描
            GPUImageSketchFilter *filter = [GPUImageSketchFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 1:{
            //阀值素描，形成有噪点的素描
            GPUImageThresholdSketchFilter *filter = [GPUImageThresholdSketchFilter new];

            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 2:{
            //卡通效果（黑色粗线描边）
            GPUImageToonFilter *filter = [GPUImageToonFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 3:{
            //平滑
            GPUImageSmoothToonFilter *filter = [GPUImageSmoothToonFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 4:{
            //桑原(Kuwahara)滤波,水粉画
            GPUImageKuwaharaFilter *filter = [GPUImageKuwaharaFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 5:{
            //黑白马赛克
            GPUImageMosaicFilter *filter = [GPUImageMosaicFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 6:{
            //像素化
            GPUImagePixellateFilter *filter = [GPUImagePixellateFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 7:{
            //同心圆像素化
            GPUImagePolarPixellateFilter *filter = [GPUImagePolarPixellateFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 8:{
            //交叉线阴影，形成黑白网状画面
            GPUImageCrosshatchFilter *filter = [GPUImageCrosshatchFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 9:{
            //色彩丢失，模糊（类似监控摄像效果）
            GPUImageColorPackingFilter *filter = [GPUImageColorPackingFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 10:{
            //晕影，形成黑色圆形边缘，突出中间图像的效果
            GPUImageVignetteFilter *filter = [GPUImageVignetteFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 11:{
            //漩涡，中间形成卷曲的画面
            GPUImageSwirlFilter *filter = [GPUImageSwirlFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 12:{
            //凸起失真，鱼眼效果
            GPUImageBulgeDistortionFilter *filter = [GPUImageBulgeDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 13:{
            //收缩失真，凹面镜
            GPUImagePinchDistortionFilter *filter = [GPUImagePinchDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 14:{
            //伸展失真，哈哈镜

            GPUImageStretchDistortionFilter *filter = [GPUImageStretchDistortionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 15:{
            //水晶球效果
            GPUImageGlassSphereFilter *filter = [GPUImageGlassSphereFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 16:{
            //球形折射，图形倒立
            GPUImageSphereRefractionFilter *filter = [GPUImageSphereRefractionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 17:{
            //色调分离，形成噪点效果
            GPUImagePosterizeFilter *filter = [GPUImagePosterizeFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 18:{
            //CGA色彩滤镜，形成黑、浅蓝、紫色块的画面
            GPUImageCGAColorspaceFilter *filter = [GPUImageCGAColorspaceFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 19:{
            //柏林噪点，花边噪点
            GPUImagePerlinNoiseFilter *filter = [GPUImagePerlinNoiseFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 20:{
            //3x3卷积，高亮大色块变黑，加亮边缘、线条等

            GPUImage3x3ConvolutionFilter *filter = [GPUImage3x3ConvolutionFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;

        case 21:{
            //浮雕效果，带有点3d的感觉
            GPUImageEmbossFilter *filter = [GPUImageEmbossFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 22:{
            //像素圆点花样
            GPUImagePolkaDotFilter *filter = [GPUImagePolkaDotFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        case 23:{
            //点染,图像黑白化，由黑点构成原图的大致图形
            GPUImageHalftoneFilter *filter = [GPUImageHalftoneFilter new];
//            GPUVector3()
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            
            [stillImageSource processImage];
            return [filter imageFromCurrentFramebuffer];
        }
        break;
        default:
            break;
    }
    return nil;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.sourceImage == nil) {
        return;
    }
    self.imageView.image = [self hightLightImage:self.sourceImage withType:index];
}


@end
