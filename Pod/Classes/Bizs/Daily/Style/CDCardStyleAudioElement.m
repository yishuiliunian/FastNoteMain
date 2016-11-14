//
//  CDCardStyleAudioElement.m
//  Pods
//
//  Created by stonedong on 16/11/14.
//
//

#import "CDCardStyleAudioElement.h"
#import "YYModel.h"

@interface CDCardStyleAudioElement ()
{
    CDCardAudioData* _audioData;
}
@end

@implementation CDCardStyleAudioElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardStyleAudioCell class];
    return self;
}


- (void) buildSubContentObjects
{
    _audioData = [CDCardAudioData yy_modelWithJSON:self.cardModel.data];
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    *height += 20;
}

@end
