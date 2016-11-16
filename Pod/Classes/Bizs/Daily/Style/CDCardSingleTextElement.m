//
//  CDCardSingleTextElement.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardSingleTextElement.h"
#import "CDCardSingleTextCell.h"
#import <DZGeometryTools.h>
@interface CDCardSingleTextElement ()
{
    YYTextLayout* _textLayout;
    CGRect _contentLabelRect;
    
    //
    NSString* _contentStr;
}
@end
@implementation CDCardSingleTextElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardSingleTextCell class];
    return self;
}

- (void) buildSubContentObjects
{
    [super buildSubContentObjects];
    NSString* str = [[NSString alloc] initWithData:self.cardModel.data encoding:NSUTF8StringEncoding];
    _contentStr = str;
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    NSMutableAttributedString* mStr = [[NSMutableAttributedString alloc] initWithString:_contentStr];
    mStr.yy_font = [UIFont systemFontOfSize:18];
    mStr.yy_color = [UIColor blackColor];
    
    CGFloat contentHeight = 0;
    
    CGSize subSize = {20,20};
    contentHeight += subSize.height/2;
    contentRect = CGRectCenterSubSize(contentRect, subSize);
    
    _textLayout = [YYTextLayout layoutWithContainerSize:contentRect.size text:mStr];
    contentHeight += _textLayout.textBoundingSize.height;
    
    _contentLabelRect = contentRect;
    _contentLabelRect.size.height = _textLayout.textBoundingSize.height;
    contentHeight += subSize.height/2;
    
    
    *height += contentHeight;
}

- (void) layoutCell:(CDCardSingleTextCell *)cell
{
    [super layoutCell:cell];
    cell.contentLabel.frame = _contentLabelRect;
}

- (void) willBeginHandleResponser:(CDCardSingleTextCell *)cell
{
    [super willBeginHandleResponser:cell];
    cell.contentLabel.textLayout = _textLayout;
}

- (NSArray*) customPopupMenu
{
    QBPopupMenuItem* copyItem = [[QBPopupMenuItem alloc] initWithTitle:@"复制" target:self action:@selector(copyTheText)];
    return @[copyItem];
}

- (void) copyTheText
{
    [[UIPasteboard generalPasteboard]  setString:_contentStr];
}
@end
