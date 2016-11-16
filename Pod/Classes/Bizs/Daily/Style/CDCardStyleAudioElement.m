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
@interface CDCardStyleAudioElement () <K12AudioPlayerDelegate>
{
    CDCardAudioData* _audioData;
    NSString* _filePath;
    K12AudioPlayer* _player;
    //
    CGRect _druationRect;

}
@property (nonatomic, strong, readonly) CDCardStyleAudioCell* activeAudioCell;
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

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    if (_player.isPlaying) {
        [_player stop];
        _player = nil;
    } else {
        _player = [[K12AudioPlayer alloc] initWithURL:[NSURL fileURLWithPath:_filePath]];
        _player.delegate = self;
        [_player play];
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

@end
