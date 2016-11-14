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
