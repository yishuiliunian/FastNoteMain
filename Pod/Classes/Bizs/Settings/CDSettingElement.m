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
#import "IAPShare.h"
#import "DZAlertPool.h"

@interface CDSettingElement ()
@property (nonatomic, strong) NSArray* products;
@end

@implementation CDSettingElement
- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
#ifdef DEBUG
    [IAPShare sharedHelper].iap.production = NO;
#endif
    if(![IAPShare sharedHelper].iap) {
        
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.dzqpzb.fastdiary.doneta.2", nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        
    }
}
    
- (void) showProducts
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"捐赠" message:@"捐赠开发者，让他开发更好用的软件" preferredStyle:UIAlertControllerStyleActionSheet];
    for (SKProduct* product in self.products) {
        NSString* title = product.localizedTitle?:@"捐赠";
        UIAlertAction* action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[IAPShare sharedHelper].iap buyProduct:product
                                       onCompletion:^(SKPaymentTransaction* trans){
                                           if (trans.transactionState == SKPaymentTransactionStatePurchased) {
                                               DZAlertShowSuccess(@"成功捐助");
                                           }else {
                                               DZAlertShowError(@"购买出错了，请重试");
                                           }
                                           
                                       }];
        }];
        [alertController addAction:action];
    }
    __weak typeof(alertController) weakAlert = alertController;
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];
    
    [(UIViewController*)self.uiEventPool presentViewController:alertController animated:YES completion:nil];
}
    
- (void) willRegsinHandleResponser:(UIResponder *)responser
{
    [super willRegsinHandleResponser:responser];
    DZAlertHideLoading;
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
    
    EKIMGTextL_RElement* donate = [[EKIMGTextL_RElement alloc] initWithTitle:@"捐赠开发者" image:nil];
    donate.showRightArrow = YES;
    
    __weak typeof(self) weakSelf = self;
    [donate setEk_handleAction:^(UIViewController* vc) {
        DZAlertShowLoading(@"获取可捐赠品...");
        [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
         {
             weakSelf.products = response.products;
             DZAlertHideLoading;
             [weakSelf showProducts];
         }];
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
    [_dataController addObject:donate];
    AddSpace();
    [_dataController addObject:about];
    [super reloadData];
}
    

@end
