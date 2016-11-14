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
    return self;
}
@end
