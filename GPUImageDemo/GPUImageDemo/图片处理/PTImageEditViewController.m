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

@end

@implementation PTImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.menu];
    self.items = @[@"1",@"1",@"1",@"1"];
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
        self.imageView.image = photos.firstObject;
        self.add.hidden = true;
    }];
}





- (nonnull TYCyclePagerViewLayout *)layoutForPagerView:(nonnull TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(120, 80);
    layout.itemSpacing = 15;
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
            //中间突出  四周暗
            GPUImageVignetteFilter *filter = [GPUImageVignetteFilter new];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
        }
        break;
        default:
            break;
    }
    return nil;
}



@end
