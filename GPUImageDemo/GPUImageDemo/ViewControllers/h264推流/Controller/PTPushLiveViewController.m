//
//  PTPushLiveViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/6/10.
//

#import "PTPushLiveViewController.h"
#import "LMLivePreview.h"


@interface PTPushLiveViewController ()

@end

@implementation PTPushLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    UIView * liveView = [[LMLivePreview alloc] initWithFrame:self.view.bounds];
    liveView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:liveView];
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
