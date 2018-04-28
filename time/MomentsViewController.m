//
//  MomentsViewController.m
//  time
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "MomentsViewController.h"


@interface MomentsViewController ()

@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    switch (self.postType) {
        case UIMessageInputViewContentTypePhoto:
            self.title = @"图片";
            break;
        case UIMessageInputViewContentTypeVideo:
            self.title = @"视频";
            break;
        case UIMessageInputViewContentTypeForward:
            self.title = @"转发";
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
