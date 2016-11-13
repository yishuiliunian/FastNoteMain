//
//  CDCardStyleImageCell.m
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import "CDCardStyleImageCell.h"
#import <DZGeometryTools.h>
#import <DZProgrameDefines.h>
@implementation CDCardStyleImageCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _contentImageView);
    _contentImageView.layer.masksToBounds = YES;
    _contentImageView.layer.shouldRasterize = YES;
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}
@end
