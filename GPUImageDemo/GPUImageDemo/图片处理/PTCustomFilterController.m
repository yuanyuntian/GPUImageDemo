//
//  PTCustomFilterController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/18.
//

#import "PTCustomFilterController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TYCyclePagerView/TYCyclePagerView-umbrella.h>
#import <Masonry/Masonry.h>
#import "TYCyclePagerViewCell.h"
#import "PTImageEffectManager.h"


@interface PTCustomFilterController ()<TZImagePickerControllerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
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

@implementation PTCustomFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.menu];
    self.items = @[@"3D"];//@"Instagram风格"];
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
    self.imageView.image = [[PTImageEffectManager shareInstance] Process3DImage:self.sourceImage withType:self.type value1:self.slider1.value value2:self.slider2.value value3:self.slider3.value];
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
    self.imageView.image = [[PTImageEffectManager shareInstance] Process3DImage:self.sourceImage withType:index value1:0 value2:0 value3:0];
}

-(void)setConfigSliderParma:(NSInteger)type {
    switch (type) {
        case 0:
            self.slider1.minimumValue = 0.0;
            self.slider1.maximumValue = 100.0;
            self.title1.text = @"3D";
            break;
        default:
            break;
    }
}

@end
