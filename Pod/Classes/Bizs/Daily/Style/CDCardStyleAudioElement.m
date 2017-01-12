//
//  CDCardStyleAudioElement.m
//  Pods
//
//  Created by stonedong on 16/11/14.
//
//

#import "CDCardStyleAudioElement.h"
#import "YYModel.h"
#import "DZFileUtils.h"
#import "DZAudio.h"
#import <iflyMSC/IFlyMSC.h>

@interface CDCardStyleAudioElement () <K12AudioPlayerDelegate, IFlySpeechRecognizerDelegate>
{
    CDCardAudioData* _audioData;
    NSString* _filePath;
    K12AudioPlayer* _player;
    //
    CGRect _druationRect;
    //
    IFlySpeechRecognizer* _iFlySpeechRecognizer;

}
@property (nonatomic, strong, readonly) CDCardStyleAudioCell* activeAudioCell;
@end

static NSString* const kCDAudioStylePlay = @"kCDAudioStylePlay";

@implementation CDCardStyleAudioElement

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [CDCardStyleAudioCell class];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOtherPlay:) name:kCDAudioStylePlay object:nil];
    return self;
}
- (void) handleOtherPlay:(NSNotification*)nc
{
    NSString* uuid = nc.userInfo[@"uuid"];
    if (![uuid isEqualToString:self.cardModel.uuid]) {
        [self stop];
    }
}

- (CDCardStyleAudioCell*) activeAudioCell
{
    return (CDCardStyleAudioCell*)self.uiEventPool;
}
- (void) buildSubContentObjects
{
    _audioData = [CDCardAudioData yy_modelWithJSON:self.cardModel.data];
    _filePath = DZPathJoin(DZDocumentsPath(), _audioData.filePath);
}

- (void) prelayoutContent:(CGRect)contentRect height:(CGFloat *)height
{
    CGFloat contentHeight = 50;
    CGRectDivide(contentRect, &_druationRect, &contentRect, contentHeight, CGRectMinYEdge);
    *height += contentHeight;
}

- (void) layoutCell:(CDCardStyleAudioCell *)cell
{
    [super layoutCell:cell];
    cell.durationLabel.frame = _druationRect;
}

- (void) stop
{
    [_player stop];
    _player = nil;
    [self showStoping];

}

- (void) play
{
    _player = [[K12AudioPlayer alloc] initWithURL:[NSURL fileURLWithPath:_filePath]];
    _player.delegate = self;
    [_player play];
    [self showPlaying];
    NSMutableDictionary * info = [NSMutableDictionary new];
    if (self.cardModel.uuid) {
        info[@"uuid"] = self.cardModel.uuid;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kCDAudioStylePlay object:nil userInfo:info];
}
- (void) handleSelectedInViewController:(UIViewController *)vc
{
    [self startRecognize];
    if (_player.isPlaying) {
        [self stop];
    } else {
        [self play];
    }
}

- (void) k12AudioPlayer:(K12AudioPlayer *)player occurError:(NSError *)error
{
    NSLog(@"error %@", error);
}

- (void) showPlaying
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1);
    animation.toValue = @(0.5);
    animation.duration = 0.4;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    [self.activeAudioCell.backgroundContentView.layer addAnimation:animation forKey:@"xx"];
}

- (void) showStoping
{
    [self.activeAudioCell.backgroundContentView.layer removeAnimationForKey:@"xx"];
}

- (void) k12AudioPlayerDidStartPlay:(K12AudioPlayer *)player
{
    [self showPlaying];
}

- (void) k12AudioPlayerDidFinishPlay:(K12AudioPlayer *)player
{
    [self showStoping];
}

- (void) willBeginHandleResponser:(CDCardStyleAudioCell *)responser
{
    [super willBeginHandleResponser:responser];
    if (_player.isPlaying) {
        [self showPlaying];
    } else {
        [self showStoping];
    }
    responser.durationLabel.text = [NSString stringWithFormat:@"%d 's",(int)floor(_audioData.duration)];
}

- (void) startRecognize
{
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    _iFlySpeechRecognizer.delegate = self;
    
    
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //设置听写模式
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iFlySpeechRecognizer setParameter:(IFLY_AUDIO_SOURCE_STREAM) forKey:[IFlySpeechConstant AUDIO_SOURCE]];
    
    //
    //设置后端点
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
    //网络等待时间
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //设置采样率，推荐使用16K
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
//        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];

    //设置是否返回标点符号
    [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];


    //
    [_iFlySpeechRecognizer startListening];
    NSData* data = [NSData dataWithContentsOfFile:_filePath];
    [_iFlySpeechRecognizer writeAudio:data];
    [_iFlySpeechRecognizer stopListening];
}

- (void) onError:(IFlySpeechError *)errorCode
{
    
}

- (void) onResults:(NSArray *)results isLast:(BOOL)isLast
{
    
}

@end
