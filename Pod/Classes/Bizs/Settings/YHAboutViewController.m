//
//  YHAboutViewController.m
//  YaoHe
//
//  Created by stonedong on 16/7/23.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHAboutViewController.h"
@interface YHAboutViewController ()
@property (nonatomic, weak) IBOutlet UILabel* versionLabel;
@end

@implementation YHAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* buildVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* v = [NSString stringWithFormat:@"版本号：%@_%@", version,buildVersion];
    self.versionLabel.text = v;
    self.title = @"关于";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
