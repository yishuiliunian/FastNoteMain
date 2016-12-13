//
//  CDCardStyleImageElement.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardStyleImageElement.h"
#import "CDCardStyleImageCell.h"
#import <DZImageCache.h>
#import <DZFileUtils.h>
#import "CDURLRouteDefines.h"
#import <YYModel.h>
#import "DZPhotoBrowser.h"

@interface CDCardStyleImageElement()
{
    CDCardImageData* _imageData;
    
    CGRect _imageRect;
    NSString* _filePath;
}
@property (nonatomic, weak, readonly) CDCardStyleImageCell* cell;
@end

@implementation CDCardStyleImageElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardStyleImageCell class];
    return self;
}

- (void) buildSubContentObjects
{
    [super buildSubContentObjects];
    _imageData = [CDCardImageData yy_modelWithJSON:self.cardModel.data];
    _filePath = _imageData.filePath;
    _filePath = DZPathJoin(DZDocumentsPath(), _filePath);
}

- (CDCardStyleImageCell*) cell
{
    return (CDCardStyleImageCell*)self.uiEventPool;
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    
    CGFloat rotaio = 0;
    if (_imageData.width != 0) {
        rotaio = _imageData.height/(CGFloat)_imageData.width;
    }
    CGFloat contentHeight = CGRectGetWidth(contentRect) * rotaio;
    if (contentHeight == 0) {
        contentHeight == 33;
    }
    CGRectDivide(contentRect, &_imageRect, &contentRect, contentHeight, CGRectMinYEdge);
    
    *height += contentHeight;
}

- (void) layoutCell:(CDCardStyleImageCell *)cell
{
    [super layoutCell:cell];
    cell.contentImageView.frame = _imageRect;
}

- (void) willBeginHandleResponser:(CDCardStyleImageCell *)responser
{
    [super willBeginHandleResponser:responser];
    responser.contentImageView.image = DZCachedImageByPath(_filePath);
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    NSMutableArray* array = [NSMutableArray new];
    DZPhoto* photo = [[DZPhoto alloc] init];
    photo.image = DZCachedImageByPath(_filePath);
    photo.sourceImageView = self.cell.contentImageView;
    DZRouteRequestContext* context = [DZRouteRequestContext new];
    [context setValue:@[photo] forKey:@"photos"];
    
    NSURL* url = DZURLRouteQueryLink(kCDURLSHowPhotos, @{});
    [[DZURLRoute  defaultRoute] routeURL:url context:context];
}
@end
