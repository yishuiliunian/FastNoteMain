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
#import "MWPhotoBrowser.h"
#import <Bugly/Bugly.h>
#import <TalkingData.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
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

- (void) setupDirector
{
    [Bugly startWithAppId:@"e35021ccc5"];
    [AMapServices sharedServices].apiKey = @"640feccb852747765634398a6365a64d";
    
    [TalkingData sessionStarted:@"0E88CB8D3E834745AF05FCC3DEAA2156" withChannelId:@"appstore"];
    [[DZURLRoute defaultRoute] addRoutePattern:kCDURLSHowPhotos handler:^DZURLRouteResponse *(DZURLRouteRequest *request) {
      
        NSArray* originPhotos = [request.context valueForKey:@"photos"];
        MWPhotoBrowser* browser = [[MWPhotoBrowser alloc] initWithPhotos:originPhotos];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:browser];
        [request.context.topViewController presentViewController:nav animated:YES completion:^{
            
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
