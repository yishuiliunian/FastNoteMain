//
//  CDDailyListViewController.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import <Foundation/Foundation.h>
#import "CDDailyListViewController.h"
#import <Chameleon.h>
#import <DZViewControllerLifeCircleAction.h>
@implementation CDDailyListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UIColor* beginColor = [UIColor colorWithHexString:@"647196" withAlpha:0.5];
    UIColor * centerColor = [UIColor colorWithHexString:@"7d7980" withAlpha:0.5];
    centerColor = [UIColor flatOrangeColor];

    UIColor* endColor = [UIColor colorWithHexString:@"7d7988" withAlpha:0.5];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.view.bounds andColors:@[beginColor, centerColor, endColor]];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

@end
