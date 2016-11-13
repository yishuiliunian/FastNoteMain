//
//  CDApplicationDelegate.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import "CDApplicationDelegate.h"
#import "CDMainDirector.h"
#import "CDInputViewControllerElement.h"
@implementation CDApplicationDelegate

- (void) loadDirector
{
    self.director= [[CDMainDirector alloc] initWithRootScene:[CDInputViewControllerElement new]];
}
@end
