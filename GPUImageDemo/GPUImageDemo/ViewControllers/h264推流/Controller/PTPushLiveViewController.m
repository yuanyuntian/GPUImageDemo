//
//  PTPushLiveViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/10.
//

#import "PTPushLiveViewController.h"
#import "LMLivePreview.h"
#import <Masonry/Masonry.h>

@interface PTPushLiveViewController ()
@property(nonatomic, strong)LMLivePreview * liveView;
@end

@implementation PTPushLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    self.liveView = [LMLivePreview new];
    [self.view addSubview:self.liveView];
    [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)){
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.left.right.equalTo(self.view);
    }];
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
