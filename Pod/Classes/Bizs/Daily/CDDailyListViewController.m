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
- (void) loadView
{
    UITableView* tableView = self.tableView;
    self.view = [UIView new];
    [self.view addSubview:self.tableView];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    DZExtendShyNavigationBar(self.tableView, self);
    self.tableView.backgroundColor = [UIColor flatSkyBlueColor];

}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
