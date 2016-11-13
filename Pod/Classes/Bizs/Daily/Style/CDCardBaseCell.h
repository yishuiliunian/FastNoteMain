//
//  CDCardBaseCell.h
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import <ElementKit/ElementKit.h>

@interface CDCardBaseCell : EKAdjustTableViewCell
@property (nonatomic, strong, readonly) UILabel* timeLabel;
@property (nonatomic, strong, readonly) UIView* backgroundContentView;
@end
