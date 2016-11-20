//
//  CDCardStyleMapCell.m
//  Pods
//
//  Created by baidu on 2016/11/17.
//
//

#import "CDCardStyleMapCell.h"
#import <DZProgrameDefines.h>
@implementation CDCardStyleMapCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW(self.contentView, UILabel, _titleLabel);
    INIT_SUBVIEW_UILabel(self.contentView, _addressLabel);
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _addressLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textAlignment = _addressLabel.textAlignment = NSTextAlignmentCenter;
    return self;
}

@end
