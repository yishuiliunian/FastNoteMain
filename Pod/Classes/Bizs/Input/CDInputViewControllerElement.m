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
#import <DZViewControllerLifeCircleAction.h>
#import <GTScrollNavigationBar.h>

@implementation CDInputViewControllerElement

- (UIResponder*) createResponser
{
    CDDailyListElement* listEle = [CDDailyListElement new];
    CDDailyListViewController* vc = [[CDDailyListViewController alloc] initWithElement:listEle];
    DZInputViewController* inputVC = [[DZInputViewController alloc] initWithElement:self contentViewController:vc];
    DZVCOnceLifeCircleAction* onceAction = [DZVCOnceLifeCircleAction actionWithOnceBlock:^(UIViewController *vc, BOOL animated) {
        DZInputViewController* inputVC = (DZInputViewController*)vc;
        [inputVC showTextInputWithPlaceholder:nil];
    }];
    [inputVC registerLifeCircleAction:onceAction];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:inputVC];
    inputVC.title = @"FastDiary";
    return nav;
}
@end
