#define kBOUNCE_DISTANCE  1.2f
#define kWAVE_DURATION   .5f

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WaveAnimation) {
    LeftToRightWaveAnimation = -1,
    RightToLeftWaveAnimation = 1
};


@interface UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;

@end
