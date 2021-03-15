//
//  ViewController.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/15.
//

#import "ViewController.h"
#import "PTImageEditViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak)IBOutlet UITableView * tableView;

@property(nonatomic, strong)NSArray *source;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GPUImageDemo";
    // Do any additional setup after loading the view.
    self.source = @[@"图片编辑",@"视频编辑"];
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
        //图片处理
        PTImageEditViewController * imageVC = [board instantiateViewControllerWithIdentifier:@"ImageEdit"];
        [self.navigationController pushViewController:imageVC animated:true];

    }else if (indexPath.row == 1) {
        
    }
}





@end
