//
//  CDDailyListElement.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import <Foundation/Foundation.h>
#import "CDDailyListElement.h"
#import "CDDailyListViewController.h"

@interface CDDailyListElement ()<DZInputProtocol>
@end

@implementation CDDailyListElement
@synthesize AIOToolbarType = _AIOToolbarType;
@synthesize inputViewController = _inputViewController;
- (void) reloadData
{
    [super reloadData];
}

- (void) willBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super willBeginHandleResponser:responser];
}

- (void) didBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(CDDailyListViewController *)responser
{
    [super willRegsinHandleResponser:responser];
}

- (void) didRegsinHandleResponser:(CDDailyListViewController *)responser
{
    [super didRegsinHandleResponser:responser];
}
@end