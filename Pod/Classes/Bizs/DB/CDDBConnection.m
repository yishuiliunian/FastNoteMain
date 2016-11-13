//
//  CDDBConnection.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDDBConnection.h"
#import <DZDBConnectionPool.h>
#import "CDCardModel.h"
@implementation CDDBConnection
+ (void) load
{
    [[DZDBConnectionPool sharePool] registerConnectionClass:self];
}

- (void) updateCard:(CDCardModel *)model
{
    [self updateOrInsertObject:model];
}
- (NSArray*) lastCards
{
    return  [_dbhelper search:[CDCardModel class] where:nil orderBy:@"createTime" offset:0 count:100];
}
@end
