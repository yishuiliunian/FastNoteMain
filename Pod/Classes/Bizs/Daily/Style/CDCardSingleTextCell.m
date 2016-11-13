//
//  CDCardSingleTextCell.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardSingleTextCell.h"
#import <DZProgrameDefines.h>
@implementation CDCardSingleTextCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW(self.contentView, YYLabel, _contentLabel);
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.displaysAsynchronously = YES;
    _contentLabel.fadeOnAsynchronouslyDisplay = YES;
    return self;
}
@end
