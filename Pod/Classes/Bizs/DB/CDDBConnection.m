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
@interface CDDBConnection()
{
    NSRecursiveLock* _msgIDLock;
}
@property (nonatomic, assign) int frameCount;
@end
@implementation CDDBConnection
@synthesize getNextStyleID = _getNextStyleID;
+ (void) load
{
    [[DZDBConnectionPool sharePool] registerConnectionClass:self];
}

- (instancetype) initWithUID:(NSString *)uid
{
    self = [super initWithUID:uid];
    if (!self) {
        return self;
    }
    _msgIDLock = [NSRecursiveLock new];
    __block int64_t maxID = 0;
    [_dbhelper executeDB:^(FMDatabase *db) {
        FMResultSet* result = [db executeQuery:@"select  max(cardIndex) from CDCardModel"];
        if (result.next) {
            maxID = [result longLongIntForColumnIndex:0];
        } else {
            maxID = 3;
        }
        [result close];
    }];
    _getNextStyleID = maxID;
    _frameCount = 20;
    return self;
}
- (int64_t) getNextStyleID
{
    int64_t msgID = _getNextStyleID;
    [_msgIDLock lock];
    _getNextStyleID ++;
    msgID = _getNextStyleID;
    [_msgIDLock unlock];
    return msgID;
}

- (void) updateCard:(CDCardModel *)model
{
    if (model.cardIndex == 0) {
        model.cardIndex = self.getNextStyleID;
    }
    [self updateOrInsertObject:model];
}
- (NSArray*) lastCards
{
    return  [_dbhelper search:[CDCardModel class] where:nil orderBy:@"cardIndex DESC" offset:0 count:self.frameCount];
}

- (NSArray*) getCardsFromIndex:(int64_t)index
{
    return  [_dbhelper search:[CDCardModel class] where:[NSString stringWithFormat:@" cardIndex < %d ", index] orderBy:@"cardIndex DESC" offset:0 count:self.frameCount];
}
@end
