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
@interface CDCardStyleImageElement()
{
    NSString* _filePath;
    
    CGRect _imageRect;
}
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
    _filePath = [[NSString alloc] initWithData:self.cardModel.data encoding:NSUTF8StringEncoding];
    _filePath = DZPathJoin(DZDocumentsPath(), _filePath);
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    CGFloat contentHeight = CGRectGetWidth(contentRect) * 0.385;
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
@end
