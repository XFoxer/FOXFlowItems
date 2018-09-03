//
//  ViewController.m
//  FOXFlowItems
//
//  Created by XFoxer on 2018/9/3.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "FOXFlow.h"

@interface ViewController ()<FOXFlowHorizontalItemViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *itemArray = @[@"回到家啊",@"可好看",@"接口",@"啊",@"囧囧",@"露露",@"茉莉刷单大",@"sgj是",@"shkk",@"啊哈哈哈",@"撸起",@"柚子",@"干大",@"到底大大好快大",@"哒哒哒哒大大大",@"回到家啊",@"a可好看",@"n接口",@"s啊",@"sd囧囧",@"adad露露",@"茉莉刷单大",@"asgj是",@"sshkk",@"啊哈s哈哈",@"撸d起",@"柚子f",@"h干大",@"h到底大大好快大",@"哒哒哒哒大w大大daidhakdakd",@"回到家啊",@"可好看",@"接口",@"回到家啊",@"可好看",@"接口",@"啊",@"囧囧",@"露露",@"茉莉刷单大",@"sgj是",@"shkk",@"啊哈哈哈",@"撸起",@"柚子",@"干大",@"到底大大好快大",@"哒哒哒哒大大大",@"回到家啊",@"a可好看",@"n接口",@"s啊",@"sd囧囧",@"adad露露",@"茉莉刷单大",@"asgj是",@"sshkk",@"啊哈s哈哈",@"撸d起",@"柚子f",@"h干大",@"h到底大大好快大",@"哒哒哒哒大w大大daidhakdakd",@"回到家啊",@"可好看",@"接口"];

    FOXFlowHorizontalItemView *horizontalView = [[FOXFlowHorizontalItemView alloc] init];
    horizontalView.horizontalDataSource = itemArray;
    horizontalView.delegate = self;
    horizontalView.defaultSelectIndex = 2;
    [self.view addSubview:horizontalView];

    [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20.0f));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(44.0f));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
