//
//  CDDailyListElement.h
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import <ElementKit/ElementKit.h>


@protocol CDDailyListViewControllerInterface <NSObject>

- (void) pullToRefresh;

@end
@interface CDDailyListViewController : EKTableViewController

@end
