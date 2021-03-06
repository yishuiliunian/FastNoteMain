//
//  CDCardStyleMapElement.m
//  Pods
//
//  Created by baidu on 2016/11/17.
//
//

#import "CDCardStyleMapElement.h"
#import <YYModel.h>
#import "CDCardStyleMapCell.h"
#import "DZGeometryTools.h"
#import "DZImageCache.h"
#import "YHMapViewController.h"

@interface CDCardStyleMapElement ()
{
    CDCardMapData* _mapData;
    
    CGRect _titleR;
    CGRect _detailR;
}
@end
@implementation CDCardStyleMapElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardStyleMapCell class];
    return self;
}

- (void) buildSubContentObjects
{
    [super buildSubContentObjects];
    _mapData = [CDCardMapData yy_modelWithJSON:self.cardModel.data];
    
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    [super prelayoutContent:contentRect height:height];
    
    CGRect dataR;
    CGRectDivide(contentRect, &dataR, &contentRect, 55, CGRectMinYEdge);
    
    CGRect rects[2];
    CGRectVerticalSplit(dataR, rects, 2, 2);
    _titleR = rects[0];
    _detailR = rects[1];

    *height += 55;
}

- (void) layoutCell:(CDCardStyleMapCell *)cell
{
    [super layoutCell:cell];
    cell.titleLabel.frame = _titleR;
    cell.addressLabel.frame = _detailR;
}

- (void) willBeginHandleResponser:(CDCardStyleMapCell *)responser
{
    [super willBeginHandleResponser:responser];
    
    responser.titleLabel.text = _mapData.title;
    responser.addressLabel.text = _mapData.detail;
    responser.backgroundContentView.image = DZCachedImageByName(@"map_background");
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    YHLocation* location = [YHLocation new];
    location.longtitude = _mapData.longtitude;
    location.latitude = _mapData.latitude;
    location.name = _mapData.title;
    location.address = _mapData.detail;
    YHMapViewController* locationVC = [[YHMapViewController alloc] initWithLocation:location];
    [vc.navigationController pushViewController:locationVC animated:YES];
}
@end
