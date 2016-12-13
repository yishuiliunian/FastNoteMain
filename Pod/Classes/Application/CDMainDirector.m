//
//  CDMainDirector.m
//  Pods
//
//  Created by stonedong on 16/8/20.
//
//

#import "CDMainDirector.h"
#import <DZURLRoute.h>
#import "CDURLRouteDefines.h"
#import <Bugly/Bugly.h>
#import <TalkingData.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <DZImageCache.h>
#import "CDJoinCardElement.h"
#import "CDCardStyleElement.h"
#import "DZFileUtils.h"
#import <YYModel/YYModel.h>
#import "YHLocation.h"
#import "CDDBConnection.h"
#import "DZPhotoBrowser.h"
#import <AVFoundation/AVFoundation.h>
@implementation CDMainDirector

- (instancetype) initWithRootScene:(EKElement *)rootScene
{
    self = [super initWithRootScene:rootScene];
    if (!self) {
        return self;
    }
    [self setupDirector];
    return self;
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
        [[NSFileManager defaultManager] copyItemAtURL:url toURL:aimURL error:&error];
        
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
}

- (void) buildDemoData
{
    [self inputText:@"FastDiary闪电般📝您的想法，快速记录身边一闪而过的瞬间。使用如同聊天一般的样式，向过去的自己诉说，向未来的自己倾诉。在熟悉的交互中，完成记录。"];
    [self inputText:@"您可以记录以下类型的信息："];
    [self inputText:@"文本和表情😜😜😜😜😜😜"];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"demoImageNote" ofType:@"jpg"];
    [self inputImage:[UIImage imageWithContentsOfFile:imagePath]];
    
    YHLocation* location = [YHLocation new];
    location.longtitude = 116.3343963623047;
    location.latitude = 40.06769943237305;
    location.name = @"新龙城";
    location.address = @"新龙城小区40号楼";
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"audioDemo" withExtension:@"acc"];
    [self inputVoice:url];
    [self inputLocation:location];
    
    [self inputText:@"上述Demo信息，您可以左划删除。点击信息，能够查看信息详情。长按有更多丰富的功能。现在，开始使用FastDiray。"];
}

- (void) setupDirector
{
    if (self.firstLanchAfterInstalled) {
        [self buildDemoData];
    }
    
    [DZImageShareCache setupAssetsSourceType];
    [Bugly startWithAppId:@"e35021ccc5"];
    [AMapServices sharedServices].apiKey = @"640feccb852747765634398a6365a64d";
    
    [TalkingData sessionStarted:@"0E88CB8D3E834745AF05FCC3DEAA2156" withChannelId:@"appstore"];
    [[DZURLRoute defaultRoute] addRoutePattern:kCDURLSHowPhotos handler:^DZURLRouteResponse *(DZURLRouteRequest *request) {
      
        NSArray* originPhotos = [request.context valueForKey:@"photos"];
        int index = [[request.paramters valueForKey:@"index"] intValue];
        DZPhotoBrowser * browser = [[DZPhotoBrowser alloc] initWithPhotos:originPhotos initializeIndex:index];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:browser];
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.transitioningDelegate = browser.transitionAnimator;
        [request.context.topNavigationController presentViewController:nav animated:YES completion:^{
            
        }];
        return [DZURLRouteResponse successResponse];
    }];
}
- (void) makeKeyWindowAndVisible
{
    [super makeKeyWindowAndVisible];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
}
@end
