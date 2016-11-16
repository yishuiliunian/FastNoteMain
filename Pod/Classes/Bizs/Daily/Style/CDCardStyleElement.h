//
//  CDCardStyleElement.h
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import <ElementKit/ElementKit.h>
#import "CDCardModel.h"
#import "QBPopupMenu.h"


@interface CDCardStyleElement : EKAdjustCellElement
{
    @protected
    CDCardModel* _cardModel;
}
@property (nonatomic, strong, readonly) CDCardModel* cardModel;

+ (CDCardStyleElement*) elementWithModel:(CDCardModel*)model;

- (instancetype) initWithModel:(CDCardModel*)model;

- (void) buildSubContentObjects;
- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat*)height;

- (NSArray*) customPopupMenu;
@end
