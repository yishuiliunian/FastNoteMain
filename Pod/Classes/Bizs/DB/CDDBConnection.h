//
//  CDDBConnection.h
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DZDBConnectionPool.h"

#define CDShareDBConnection ((CDDBConnection*)[DZDBConnectionPool shareCacheConnection])
@class CDCardModel;
@interface CDDBConnection : DZDBConnection
@property (nonatomic, assign, readonly) int64_t getNextStyleID;
- (void) updateCard:(CDCardModel*)model;
- (NSArray*) lastCards;
- (NSArray*) getCardsFromIndex:(int64_t)index;
@end
