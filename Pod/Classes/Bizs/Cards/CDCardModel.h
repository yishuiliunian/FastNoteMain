//
//  CDCardModel.h
//  Pods
//
//  Created by stonedong on 16/11/13.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, CDCardType) {
    CDCardText,
    CDCardImage,
    CDCardAudio
};

@interface CDCardModel : NSObject
@property (nonatomic, strong) NSDate* createTime;
@property (nonatomic, strong) NSDate* updateTime;
@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, assign) CDCardType type;
@property (nonatomic, strong) NSData* data;
@property (nonatomic, assign) int cardIndex;
@property (nonatomic, assign) BOOL showTime;

+ (CDCardModel*) newCardWithType:(CDCardType)type;
@end


@interface CDCardImageData : NSObject
@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@end


@interface CDCardAudioData : NSObject
@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, assign) float duration;
@end
