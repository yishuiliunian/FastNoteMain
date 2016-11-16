//
//  CDCardStyleAudioCell.m
//  Pods
//
//  Created by stonedong on 16/11/14.
//
//

#import "CDCardStyleAudioCell.h"
#import "DZProgrameDefines.h"
@implementation CDCardStyleAudioCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UILabel(self.contentView, _durationLabel);
    _durationLabel.numberOfLines = 1;
    _durationLabel.textAlignment = NSTextAlignmentCenter;
    return self;
}


@end
