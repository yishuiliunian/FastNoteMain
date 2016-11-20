//
//  CDSettingElement.m
//  Pods
//
//  Created by stonedong on 16/11/20.
//
//

#import "CDSettingElement.h"
#import "EKInputExtention.h"
#import "CTFeedbackViewController.h"
#import "YHAboutViewController.h"


@implementation CDSettingElement
- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
}
- (void) reloadData
{
    [_dataController clean];
    EKIMGTextL_RElement* about = [[EKIMGTextL_RElement alloc] initWithTitle:@"关于" image:nil];
    about.showRightArrow = YES;
    EKIMGTextL_RElement* feedback = [[EKIMGTextL_RElement alloc] initWithTitle:@"反馈" image:nil];
    feedback.showRightArrow = YES;
    [feedback setEk_handleAction:^(UIViewController* vc) {
        CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
        feedbackViewController.toRecipients = @[@"ctfeedback@example.com"];
        feedbackViewController.useHTML = NO;
        [vc.navigationController pushViewController:feedbackViewController animated:YES];
    }];
    
    [about setEk_handleAction:^(UIViewController* vc) {
        YHAboutViewController* aboutVC = [YHAboutViewController new];
        [vc.navigationController pushViewController:aboutVC animated:YES];
    }];
    void(^AddSpace)(void) = ^(void) {
        EKSpaceElement* space = [[EKSpaceElement alloc] init];
        space.cellHeight = 20;
        [_dataController addObject:space];
    };
    [_dataController addObject:feedback];
    AddSpace();
    [_dataController addObject:about];
    [super reloadData];
}
@end
