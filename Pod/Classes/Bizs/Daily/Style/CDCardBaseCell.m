//
//  CDCardBaseCell.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardBaseCell.h"
#import <DZProgrameDefines.h>
#import <Chameleon.h>
#import <QBPopupMenu/QBPopupMenu.h>

@interface CDCardBaseCell ()
{
    UILongPressGestureRecognizer* _longPressRecognizer;
}
@end
@implementation CDCardBaseCell
@synthesize backgroundContentView = _backgroundContentView;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    self.backgroundColor = [UIColor clearColor];
    INIT_SUBVIEW_UIImageView(self.contentView, _backgroundContentView);
    _backgroundContentView.backgroundColor = [UIColor flatWhiteColor];
    _backgroundContentView.layer.cornerRadius = 4;
    _backgroundContentView.layer.shouldRasterize = YES;
    _backgroundContentView.userInteractionEnabled = YES;
    _backgroundContentView.layer.masksToBounds = YES;
    INIT_SUBVIEW_UILabel(self.contentView, _timeLabel);
    _timeLabel.numberOfLines  = 1;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //
    
    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:_longPressRecognizer];
    _longPressRecognizer.delegate = self;
    
    return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _longPressRecognizer) {
        CGPoint point = [gestureRecognizer locationInView:self.contentView];
        if (CGRectContainsPoint(self.backgroundContentView.frame, point)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void) handleLongPress:(UILongPressGestureRecognizer*)r
{
    if (r.state == UIGestureRecognizerStateBegan) {
        NSLog(@"handle long press");
        
        
        NSArray* items = [self.interactDelegate messagePopUpMenus];
        if (items.count < 1) {
            return;
        }
        QBPopupMenu* menu = [[QBPopupMenu alloc] initWithItems:items];
        
        UIWindow* keywindow = [UIApplication sharedApplication].keyWindow;
        CGPoint point = [r locationInView:keywindow];
        CGRect rect = [self.contentView convertRect:self.bounds toView:keywindow];
        CGPoint pointInCell = [r locationInView:self];
        rect.origin.y = point.y - pointInCell.y/2;
        rect.origin.x = point.x;
        rect.size.width = 20;
        [menu showInView:keywindow targetRect:rect animated:YES];
    }
}
@end
