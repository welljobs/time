//
//  ViewController.m
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "ViewController.h"
#import "CircleViewController.h"
#import "BlurCommentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)timeline:(id)sender {
    [self.navigationController pushViewController:[CircleViewController new] animated:YES];
}
- (IBAction)comment:(id)sender {
    [BlurCommentView commentshowSuccess:^(NSString *commentText) {
        NSLog(@"正在评论。。。评论内容:%@",commentText);
    } withTitle:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
