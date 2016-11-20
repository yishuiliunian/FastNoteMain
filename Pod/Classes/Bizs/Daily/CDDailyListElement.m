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
#import "YYModel.h"
#import "YHLocation.h"
#import <AVFoundation/AVFoundation.h>
#import "CDDailyListViewController.h"
#import "CDSettingElement.h"
#import <Chameleon.h>
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
    [_dataController sortUseBlock:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    [super reloadData];
    
    NSInteger section = _dataController.numberOfSections - 1 > 0 ? _dataController.numberOfSections -1 : 0;
    NSInteger row = [_dataController numberAtSection:section] -1 > 0 ?   [_dataController numberAtSection:section] -1 : 0;
    if (_dataController.numbersOfObject > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void) showSettings
{
    CDSettingElement* ele = [CDSettingElement new];
    EKTableViewController* tableVC = [[EKTableViewController alloc] initWithElement:ele];
    tableVC.view.backgroundColor = [UIColor colorWithHexString:@"f0eff5"];
    [[(UIViewController*)self.uiEventPool  navigationController] pushViewController:tableVC animated:YES];
}

- (void) willBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super willBeginHandleResponser:responser];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:DZCachedImageByName(@"ic_action_setup") style:UIBarButtonItemStyleDone target:self action:@selector(showSettings)];
    self.inputViewController.navigationItem.rightBarButtonItem = item;
}

- (void) pullToRefresh
{
    __block int64_t minIndex = INT64_MAX;
    [_dataController map:^(CDCardStyleElement*   _Nonnull e) {
        if ([e isKindOfClass:[CDCardStyleElement class]]) {
            minIndex = MIN(e.cardModel.cardIndex, minIndex);
        }
    }];
    if (minIndex != NSNotFound) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSArray* array = [CDShareDBConnection getCardsFromIndex:minIndex];
            NSMutableArray* eles = [NSMutableArray new];
            for (CDCardModel* model in array) {
                [eles addObject:[CDCardStyleElement elementWithModel:model]];
            }
            [_dataController updateObjects:eles];
            [_dataController sortUseBlock:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj2 compare:obj1];
            }];
            
            NSMutableArray* allIndex = [NSMutableArray new];
            for (CDCardStyleElement* ele in eles) {
                NSIndexPath * index = [_dataController indexPathOfObject:ele];
                if (index.row != NSNotFound) {
                    [allIndex addObject:index];
                }
            }
            
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView beginUpdates];
               [self.tableView insertRowsAtIndexPaths:allIndex withRowAnimation:UITableViewRowAnimationAutomatic];
               [self.tableView endUpdates];
           });
        });

    }
    [[(UITableViewController*)self.uiEventPool refreshControl] endRefreshing];
    
}
- (void) didBeginHandleResponser:(CDDailyListViewController *)responser
{
    [super didBeginHandleResponser:responser];
    [self.eventBus addHandler:self priority:1 port:@selector(pullToRefresh)];
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
        CDCardImageData* data = [CDCardImageData new];
        data.filePath = filepath;
        data.width = image.size.width;
        data.height = image.size.height;
        model.data = [data yy_modelToJSONData];
        return model;
    }];
}

- (void) inputVoice:(NSURL *)url
{
    [self insertNewCard:^CDCardModel *{
        CDCardModel* model = [CDCardModel newCardWithType:CDCardAudio];
        NSString* filepath = DZFileInSubPath(@"note-data", [NSString stringWithFormat:@"%@.acc",model.uuid]);
        NSURL* aimURL = [NSURL fileURLWithPath:filepath];
        NSError* error;
        [[NSFileManager defaultManager] moveItemAtURL:url toURL:aimURL error:&error];
        
        filepath = [filepath stringByReplacingOccurrencesOfString:DZDocumentsPath() withString:@""];
        CDCardAudioData* data = [CDCardAudioData new];
        data.filePath = filepath;
        
        data.duration = [[AVAudioPlayer alloc] initWithContentsOfURL:aimURL error:nil].duration;
        model.data = [data yy_modelToJSONData];
        return model;
    }];
}
- (void) inputLocation:(YHLocation *)location
{
    [self insertNewCard:^CDCardModel *{
        CDCardModel* model = [CDCardModel newCardWithType:CDCardMap];
        
        CDCardMapData* mapData = [CDCardMapData new];
        mapData.longtitude = location.longtitude;
        mapData.latitude = location.latitude;
        mapData.title = location.name;
        mapData.detail = location.address;
        
        model.data = [mapData yy_modelToJSONData];
        
        return model;
    }];
}
- (void) insertNewCard:(CDCardModel*(^)())buildBlock
{
    CDCardModel* model = buildBlock();
    [CDShareDBConnection updateCard:model];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDCardStyleElement* ele = [_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
        if ([ele respondsToSelector:@selector(deleteThisElement)]) {
            [ele deleteThisElement];
        }
    }
}

- (void) loadNextFrameOldCards
{
    
}
@end
