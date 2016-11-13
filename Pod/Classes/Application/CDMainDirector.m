//
//  CDMainDirector.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import "CDMainDirector.h"

@implementation CDMainDirector
- (void) makeKeyWindowAndVisible
{
    [super makeKeyWindowAndVisible];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
}
@end
