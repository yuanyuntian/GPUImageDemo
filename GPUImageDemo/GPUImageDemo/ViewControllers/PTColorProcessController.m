//
//  PTColorProcessController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/17.
//

#import "PTColorProcessController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TYCyclePagerView/TYCyclePagerView-umbrella.h>
#import <Masonry/Masonry.h>
#import "TYCyclePagerViewCell.h"
#import "PTImageEffectManager.h"



@interface PTColorProcessController ()<TZImagePickerControllerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
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

@property(nonatomic, assign) NSInteger  type;

@end

@implementation PTColorProcessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.menu];
    self.items = @[@"亮度",@"曝光",@"对比度",@"饱和度",@"伽马线",@"反色",@"褐色（怀旧）",@"色阶",@"灰度",@"色彩直方图，显示在图片上",@"色彩直方图",@"RGB",@"色调曲线",@"单色",@"不透明度",@"提亮阴影",@"色彩替换（替换亮部和暗部色彩",@"色度",@"色度键",@"白平横",@"像素平均色值",@"纯色",@"亮度平均",@"像素色值亮度平均，图像黑白（有类似漫画效果）",@"lookup色彩调整",@"Amatorka lookup",@"MissEtikate lookup",@"SoftElegance lookup"];//@"Instagram风格"];
    [self.menu reloadData];
    self.type = -1;
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

-(IBAction)changeValue1:(id)sender {
    self.imageView.image = [[PTImageEffectManager shareInstance] colorProcessImage:self.sourceImage withType:self.type value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value];
}

-(IBAction)changeValue2:(id)sender {
    self.imageView.image = [[PTImageEffectManager shareInstance] colorProcessImage:self.sourceImage withType:self.type value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value];
}

-(IBAction)changeValue3:(id)sender {
    self.imageView.image = [[PTImageEffectManager shareInstance] colorProcessImage:self.sourceImage withType:self.type value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value];
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
    self.type = index;
    [self setConfigSliderParma:index];
    self.imageView.image = [[PTImageEffectManager shareInstance] colorProcessImage:self.sourceImage withType:index value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value];
}


-(void)setConfigSliderParma:(NSInteger)type {
    switch (type) {
        case 0:{
            //亮度
            self.slider1.minimumValue = -1.0;
            self.slider1.maximumValue = 1.0;
            
            self.title1.text = @"亮度";
        }
            break;
        case 1:{
            //曝光
            self.slider1.minimumValue = -10.0;
            self.slider1.maximumValue = 10.0;
            self.title1.text = @"曝光";
        }
            break;
        case 2:{
            //对比度
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 4.0;
            self.title1.text = @"对比度";
        }
            break;
        case 3:{
            //饱和度
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 2.0;
            self.title1.text = @"饱和度";
        }
            break;
        case 4:{
            //伽马线
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 3.0;
            self.title1.text = @"伽马线";
        }
            break;
        case 5:{
            //反色
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 3.0;
            self.title1.text = @"反色";
        }
            break;
        case 6:{
            //怀旧
            self.title1.text = @"怀旧";
        }
            break;
        case 7:{
            //色阶
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"red";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"green";
            
            self.slider3.minimumValue = 0.0;
            self.slider3.maximumValue = 1.0;
            self.title3.text = @"blue";
        }
            break;
        case 8:{
            //灰度
            self.title1.text = @"灰度";
        }
            break;
        case 9:{
            //色彩直方图，显示在图片上
            self.slider1.minimumValue = 1.0;
            self.slider1.maximumValue = 20.0;
            self.title1.text = @"色彩直方图";
        }
            break;
        case 10:{
            //色彩直方图

        }
            break;
        case 11:{
            //RGB
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"red";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"green";
            
            self.slider3.minimumValue = 0.0;
            self.slider3.maximumValue = 1.0;
            self.title3.text = @"blue";
        }
            break;
        case 12:{
            //色调曲线

        }
            break;
        case 13:{
            //单色

        }
            break;
        case 14:{
            //不透明度
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"不透明度";
        }
            break;
        case 15:{
            //提亮阴影
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"show";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"heighlight";
        }
            break;
        case 16:{
            //色彩替换（替换亮部和暗部色彩）
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"red";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"green";
            
            self.slider3.minimumValue = 0.0;
            self.slider3.maximumValue = 1.0;
            self.title3.text = @"blue";
        }
            break;
        case 17:{
            //色度
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"色度";
        }
            break;
        case 18:{
            //色度键
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"red";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"green";
            
            self.slider3.minimumValue = 0.0;
            self.slider3.maximumValue = 1.0;
            self.title3.text = @"blue";
        }
            break;
        case 19:{
            //白平横
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 5000.0;
            self.title1.text = @"temperature";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1000.0;
            self.title2.text = @"tint";
        }
            break;
        case 20:{
            //像素平均色值

        }
            break;
        case 21:{
            //纯色
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 1.0;
            self.title1.text = @"red";
            
            self.slider2.minimumValue = 0.0;
            self.slider2.maximumValue = 1.0;
            self.title2.text = @"green";
            
            self.slider3.minimumValue = 0.0;
            self.slider3.maximumValue = 1.0;
            self.title3.text = @"blue";
        }
            break;
        case 22:{
            //亮度平均

        }
            break;
        case 23:{
            //像素色值亮度平均，图像黑白（有类似漫画效果）
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 5000.0;
//            self.title1.text = @"temperature";
        }
            break;
        case 24:{
            //lookup 色彩调整

        }
            break;
        case 25:{
            //Amatorka lookup

        }
            break;
        case 26:{
            //MissEtikate looku

        }
            break;
        case 27:{
            //SoftElegance looku

        }
            break;
        default:
            break;
    }
}

@end
