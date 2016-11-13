//
//  CDDailyListElement.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import <Foundation/Foundation.h>
#import "CDDailyListElement.h"
#import "CDDailyListViewController.h"
#import "CDCardModel.h"
#import "CDCardStyleElement.h"
#import "CDDBConnection.h"
#import "DZImageCache.h"
#import "DZFileUtils.h"

@interface CDDailyListElement ()<DZInputProtocol>
@end

@implementation CDDailyListElement
@synthesize AIOToolbarType = _AIOToolbarType;
@synthesize inputViewController = _inputViewController;

- (void) reloadData
{
    NSArray* models = [CDShareDBConnection lastCards];
    NSMutableArray* array = [NSMutableArray new];
    for (CDCardModel* model in models) {
        model.showTime = YES;
        CDCardStyleElement* ele = [CDCardStyleElement elementWithModel:model];
        [array addObject:ele];
    }
    [_dataController updateObjects:array];
    [super reloadData];
    
    NSInteger section = _dataController.numberOfSections - 1 > 0 ? _dataController.numberOfSections -1 : 0;
    NSInteger row = [_dataController numberAtSection:section] -1 > 0 ?   [_dataController numberAtSection:section] -1 : 0;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) willBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super willBeginHandleResponser:responser];
}

- (void) didBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(CDDailyListViewController *)responser
{
    [super willRegsinHandleResponser:responser];
}

- (void) didRegsinHandleResponser:(CDDailyListViewController *)responser
{ 
    [super didRegsinHandleResponser:responser];
}

- (void) inputText:(NSString *)text
{
    NSLog(@"Get Text %@", text);
    [self insertNewCard:^CDCardModel *{
        CDCardModel* model = [CDCardModel newCardWithType:CDCardText];
        model.data = [text dataUsingEncoding:NSUTF8StringEncoding];
        return model;
    }];
}


- (void) inputImage:(UIImage *)image
{
    [self insertNewCard:^CDCardModel *{
        CDCardModel* model = [CDCardModel newCardWithType:CDCardImage];
        NSString* filepath = DZFileInSubPath(@"note-data", [NSString stringWithFormat:@"%@.jpg",model.uuid]);
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:filepath atomically:YES];
        filepath = [filepath stringByReplacingOccurrencesOfString:DZDocumentsPath() withString:@""];
        model.data = [filepath dataUsingEncoding:NSUTF8StringEncoding];
        return model;
    }];
}


- (void) insertNewCard:(CDCardModel*(^)())buildBlock
{
    CDCardModel* model = buildBlock();
    [CDShareDBConnection updateOrInsertObject:model];
    CDCardStyleElement* ele = [CDCardStyleElement elementWithModel:model];
    NSInteger section = _dataController.numberOfSections;
    EKIndexPath indexPath = [_dataController addObject:ele];
    if (section < _dataController.numberOfSections) {
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewScrollPositionBottom];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[NSIndexPathFromEK(indexPath)] withRowAnimation:UITableViewScrollPositionBottom];
        [self.tableView endUpdates];
    }

    [self.tableView scrollToRowAtIndexPath:NSIndexPathFromEK(indexPath) atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
