//
//  PTImageProcessController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/17.
//

#import "PTImageProcessController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TYCyclePagerView/TYCyclePagerView-umbrella.h>
#import <Masonry/Masonry.h>
#import "TYCyclePagerViewCell.h"
#import "PTImageEffectManager.h"


@interface PTImageProcessController ()<TZImagePickerControllerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
@property(nonatomic, weak)IBOutlet UIButton * add;
@property(nonatomic, weak)IBOutlet UIImageView * imageView;

@property(nonatomic, weak)IBOutlet UILabel * title1;
@property(nonatomic, weak)IBOutlet UISlider * slider1;
@property(nonatomic, weak)IBOutlet UILabel * title2;
@property(nonatomic, weak)IBOutlet UISlider * slider2;
@property(nonatomic, weak)IBOutlet UILabel * title3;
@property(nonatomic, weak)IBOutlet UISlider * slider3;

@property(nonatomic, strong) TYCyclePagerView * menu;
@property(nonatomic, strong) NSArray * items;
@property(nonatomic, strong) UIImage * sourceImage;


@end

@implementation PTImageProcessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.menu];
    self.items = @[@"十字",@"线条",@"形状变化",@"剪裁",@"锐化",@"反遮罩锐化",@"模糊",@"高斯模糊",@"高斯模糊，选择部分清晰",@"盒状模糊",@"条纹模糊，中间清晰，上下两端模糊",@"中间值，有种稍微模糊边缘的效果",@"双边模糊",@"侵蚀边缘模糊，变黑白",@"RGB侵蚀边缘模糊，有色彩",@"RGB侵蚀边缘模糊，有色彩",@"扩展边缘模糊，变黑白",@"RGB扩展边缘模糊，有色彩",@"黑白色调模糊",@"彩色模糊",@"黑白色调模糊，暗色会被提亮",@"彩色模糊，暗色会被提亮",@"Lanczos重取样，模糊效果",@"非最大抑制，只显示亮度最高的像素，其他为黑",@"Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果)",@"Canny边缘检测算法（比上更强烈的黑白对比度",@"阈值边缘检测（效果与上差别不大）",@"普瑞维特(Prewitt)边缘检测(效果与Sobel差不多，貌似更平滑)",@"/XYDerivative边缘检测，画面以蓝色为主，绿色为边缘，带彩色",@"Harris角点检测，会有绿色小十字显示在图片角点处",@"Noble角点检测，检测点更多",@"ShiTomasi角点检测，与上差别不大",@"图像黑白化，并有大量噪点",@"用于图像加亮",@"图像低于某值时显示为黑"];//@"Instagram风格"];
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

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.sourceImage == nil) {
        return;
    }
    self.imageView.image = [[PTImageEffectManager shareInstance] visualProcessImage:self.sourceImage withType:index];
}

@end
