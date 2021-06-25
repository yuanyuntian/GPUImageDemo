//
//  ViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/15.
//

#import "ViewController.h"
#import "PTImageEditViewController.h"
#import "PTImageProcessController.h"
#import "PTColorProcessController.h"
#import "PTCustomFilterController.h"
//#import "PTVideoProcessController.h"
//#import "PTH264EncoderController.h"
#import "PTPushLiveViewController.h"
#import "PTImageBlendViewController.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak)IBOutlet UITableView * tableView;

@property(nonatomic, strong)NSArray *source;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GPUImageDemo";
    // Do any additional setup after loading the view.
    self.source = @[@"视觉效果",@"图像处理",@"颜色处理",@"混合模式",@"自定义滤镜",@"视频编辑",@"h264编码",@"h264推流"];
    [self.tableView reloadData];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.source[indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    if (indexPath.row == 0) {
        //视觉效果
        PTImageEditViewController * imageVC = [board instantiateViewControllerWithIdentifier:@"ImageEdit"];
        [self.navigationController pushViewController:imageVC animated:true];

    }else if (indexPath.row == 1) {
        //图像处理
        PTImageProcessController * imageVC = [board instantiateViewControllerWithIdentifier:@"PTImageProcessController"];
        [self.navigationController pushViewController:imageVC animated:true];
    }else if (indexPath.row == 2) {
        //颜色处理
        PTColorProcessController * imageVC = [board instantiateViewControllerWithIdentifier:@"PTColorProcessController"];
        [self.navigationController pushViewController:imageVC animated:true];
    }else if (indexPath.row == 4) {
        //自定义滤镜
        PTCustomFilterController * imageVC = [board instantiateViewControllerWithIdentifier:@"PTCustomFilterController"];
        [self.navigationController pushViewController:imageVC animated:true];
    }else if (indexPath.row == 3) {
        //
        PTImageBlendViewController * imageVC = [board instantiateViewControllerWithIdentifier:@"PTImageBlendViewController"];
        [self.navigationController pushViewController:imageVC animated:true];
    }else if (indexPath.row == 6) {
        //
//        PTH264EncoderController * imageVC = [board instantiateViewControllerWithIdentifier:@"PTH264EncoderController"];
//        [self.navigationController pushViewController:imageVC animated:true];
    }else if (indexPath.row == 7) {
        PTPushLiveViewController * vc = [board instantiateViewControllerWithIdentifier:@"PTPushLiveViewController"];
        [self.navigationController pushViewController:vc animated:true];
    }
}





@end
