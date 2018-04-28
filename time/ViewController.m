//
//  ViewController.m
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "ViewController.h"
#import "CircleViewController.h"
#import "MomentsViewController.h"
#import "BlurCommentView.h"
#import "CommandViewController.h"

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
//    [BlurCommentView commentshowSuccess:^(NSString *commentText) {
//        NSLog(@"正在评论。。。评论内容:%@",commentText);
//    } withTitle:@""];

    [[CommandViewController commandWithPlaceholder:@"说点什么吧！！！" success:^(NSString *commentText) {
        NSLog(@"正在评论。。。评论内容:%@",commentText);
    }] showInController:self];
    
}
- (IBAction)post:(id)sender {
    [self.navigationController pushViewController:[MomentsViewController new] animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
