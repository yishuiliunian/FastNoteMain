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
#import "CBStoreHouseRefreshControl.h"
#import "DZObjectProxy.h"
#import "DZImageCache.h"
#import "CDSettingElement.h"
#import "DZChatUI.h"
@interface CDDailyListViewController ()
@property (nonatomic, strong) DZDelegateMiddleProxy* delegateProxy;
@end
@implementation CDDailyListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    DZExtendShyNavigationBar(self.tableView, self);
    self.tableView.backgroundColor = [UIColor flatSkyBlueColor];
    UIRefreshControl* refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(pullToReferesh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void) pullToReferesh
{
    [self.eventBus performSelector:@selector(pullToRefresh)];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
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
