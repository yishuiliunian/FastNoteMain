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
#import "DZShyNavigationBar.h"

@implementation CDDailyListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    DZExtendShyNavigationBar(self.tableView, self);
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UIColor* beginColor = [UIColor colorWithHexString:@"647196" withAlpha:0.5];
    UIColor * centerColor = [UIColor colorWithHexString:@"7d7980" withAlpha:0.5];
    centerColor = [UIColor flatOrangeColor];

    UIColor* endColor = [UIColor colorWithHexString:@"7d7988" withAlpha:0.5];
    self.view.backgroundColor = [UIColor flatMintColor];
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
