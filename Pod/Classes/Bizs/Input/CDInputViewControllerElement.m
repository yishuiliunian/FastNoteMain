//
//  CDInputViewControllerElement.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import "CDInputViewControllerElement.h"
#import <DZChatUI/DZChatUI.h>
#import "CDDailyListElement.h"
#import "CDDailyListViewController.h"
@implementation CDInputViewControllerElement

- (UIResponder*) createResponser
{
    CDDailyListElement* listEle = [CDDailyListElement new];
    CDDailyListViewController* vc = [[CDDailyListViewController alloc] initWithElement:listEle];
    DZInputViewController* inputVC = [[DZInputViewController alloc] initWithElement:self contentViewController:vc];
    return inputVC;
}
@end
