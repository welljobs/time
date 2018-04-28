//
//  FHMessageMediaCell.m
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "FHMessageMediaCell.h"
#import <Masonry/Masonry.h>

@interface FHMessageMediaCell ()
@property (strong, nonatomic) NSObject *media;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *deleteBtn;
@end

@implementation FHMessageMediaCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 2.0;
        [self.contentView addSubview:_imgView];
        
    }
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_deleteBtn setImage:[UIImage imageNamed:@"btn_delete_tweetimage"] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor blackColor];
        _deleteBtn.layer.cornerRadius = 10;
        _deleteBtn.layer.masksToBounds = YES;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
    }
}

- (void)setupLayout {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setCurMedia:(NSObject *)curMedia totalCount:(NSInteger)totalCount {
   
    
}

- (void)deleteBtnClicked:(id)sender{
    assert(self.deleteBlock);
    self.deleteBlock(self.media);
}
@end
