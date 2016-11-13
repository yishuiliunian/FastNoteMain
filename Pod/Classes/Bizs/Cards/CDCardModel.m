//
//  CDCardModel.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardModel.h"

@implementation CDCardModel
+ (NSString*) getPrimaryKey{
    return @"uuid";
}

+ (CDCardModel*) newCardWithType:(CDCardType)type
{
    CDCardModel* model = [[CDCardModel alloc] init];
    model.updateTime = model.createTime = [NSDate new];
    model.uuid = [NSUUID UUID].UUIDString;
    model.type = type;
    return model;
}
@end
