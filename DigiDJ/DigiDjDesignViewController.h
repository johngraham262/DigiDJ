#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <AVFoundation/AVFoundation.h>

@protocol DigiDjDelegate;

@interface DigiDjDesignViewController : UIViewController {
    UIButton *connectButton;
}

@property (strong, nonatomic) UIButton *connectButton;
@property (assign, nonatomic) id <DigiDjDelegate> delegate;


@end

@protocol DigiDjDelegate <NSObject>

@optional
- (void)didOpenApp;

@end
