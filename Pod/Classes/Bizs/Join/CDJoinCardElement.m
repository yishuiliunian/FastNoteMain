//
//  CDJoinCardElement.m
//  Pods
//
//  Created by stonedong on 16/11/19.
//
//

#import "CDJoinCardElement.h"
#import "CDCardStyleElement.h"
#import "CDCardModel.h"
#import "CDURLRouteDefines.h"
@interface CDJoinCardElement ()
@property (nonatomic, strong) NSArray* models;
@end

@implementation CDJoinCardElement

+ (void) load
{
    [[DZURLRoute defaultRoute] addRoutePattern:kCDURLJoinCard handler:^DZURLRouteResponse *(DZURLRouteRequest *request) {
     
        NSArray* models = [request.context valueForKey:@"models"];
        CDJoinCardElement* tableEle = [[CDJoinCardElement alloc] initWithModels:models];
        EKTableViewController* controller = [[EKTableViewController alloc] initWithElement:tableEle];
        [request.context.topViewController presentViewController:controller animated:YES completion:^{
            
        }];
        return [DZURLRouteResponse successResponse];
    }];
}

- (instancetype) initWithModels:(NSArray *)models
{
    self = [super init];
    if (!self) {
        return self;
    }
    _models = models;
    return self;
}
- (void) setupInitializeData
{
    NSMutableArray* array = [NSMutableArray new];
    for (CDCardModel* model in _models) {
        CDCardStyleElement* ele = [CDCardStyleElement elementWithModel:model];
        [array addObject:ele];
    }
    [_dataController updateObjects:array];
}


@end
