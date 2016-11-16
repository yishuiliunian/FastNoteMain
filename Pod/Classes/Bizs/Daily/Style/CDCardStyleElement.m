//
//  CDCardStyleElement.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardStyleElement.h"
#import <DZGeometryTools.h>
#import "CDCardBaseCell.h"
#import "CDCardSingleTextElement.h"
#import "CDCardStyleImageElement.h"
#import "DateTools.h"
#import "CDCardStyleAudioElement.h"
#import "CDDBConnection.h"
#import "QBPopupMenu.h"
@interface CDCardStyleElement()
{
    CGRect _backgroundRect;
    CGRect _timeRect;
    //
}
@end
@implementation CDCardStyleElement

+ (CDCardStyleElement*) elementWithModel:(CDCardModel *)model
{
    switch (model.type) {
        case CDCardText:
            return [[CDCardSingleTextElement alloc] initWithModel:model];
            break;
        case CDCardImage:
            return [[CDCardStyleImageElement alloc] initWithModel:model];
        case CDCardAudio:
            return [[CDCardStyleAudioElement alloc] initWithModel:model];
        default:
            return [[CDCardStyleElement alloc] initWithModel:model];
            break;
    }
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardBaseCell class];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (instancetype) initWithModel:(CDCardModel *)model
{
    self = [self init];
    if (!self) {
        return self;
    }
    _cardModel = model;
    [self buildSubContentObjects];
    [self prelayout];
    return self;
}

- (void) prelayout
{
    CGRect contentRect = [UIScreen mainScreen].bounds;
    contentRect.size.height = CGFLOAT_MAX;
    CGFloat cellHeight = 0;

    CGSize subSize = {30,15};
    cellHeight += subSize.height/2;
    contentRect = CGRectCenterSubSize(contentRect, subSize);
    
    if (self.cardModel.showTime) {
        CGFloat timeHeight = 20;
        CGRectDivide(contentRect, &_timeRect, &contentRect, timeHeight, CGRectMinYEdge);
        cellHeight += timeHeight;
        cellHeight += 5;
        contentRect = CGRectShrink(contentRect, 5, CGRectMinYEdge);
    }
    
    CGFloat oldHeight = cellHeight;
    [self prelayoutContent:contentRect height:&cellHeight];
    CGFloat growHeight = cellHeight - oldHeight;
    
    CGRectDivide(contentRect, &_backgroundRect, &contentRect, growHeight, CGRectMinYEdge);
    
    cellHeight += subSize.height/2;
    
    self.cellHeight = cellHeight;
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat*)height
{
    
}

- (void) layoutCell:(CDCardBaseCell *)cell
{
    [super layoutCell:cell];
    cell.backgroundContentView.frame = _backgroundRect;
    cell.timeLabel.frame = _timeRect;
}
- (void) buildSubContentObjects
{
    
}

- (void) willBeginHandleResponser:(CDCardBaseCell *)responser
{
    [super willBeginHandleResponser:responser];
    if (self.cardModel.showTime) {
        responser.timeLabel.text = [self.cardModel.updateTime formattedDateWithStyle:NSDateFormatterShortStyle];
    }
    responser.interactDelegate = self;
}

- (void) onHandleDeleteEditing
{
    [CDShareDBConnection.dbhelper deleteToDB:self.cardModel];
}
- (NSArray*) customPopupMenu
{
    return nil;
}


- (void) deleteThisElement
{
    NSIndexPath* indexPath = [self.superTableView indexPathForCell:self.uiEventPool];
    if (indexPath && indexPath.row != NSNotFound) {
        [self onHandleDeleteEditing];
        [self notifyRemoveThisElement];
    }
}

- (NSArray*) messagePopUpMenus
{
    NSMutableArray* items = [NSMutableArray new];
    QBPopupMenuItem* item = [[QBPopupMenuItem alloc] initWithTitle:@"删除" target:self action:@selector(deleteThisElement)];
    [items addObject:item];
    NSArray* custom = [self customPopupMenu];
    [items addObjectsFromArray:custom];
    return items;
}

@end
