#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "DigiDjDesignViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController <UIWebViewDelegate>

@property (assign, nonatomic) id<LoginViewControllerDelegate> delegate;

- (UIWebView *)webView;

@end

@protocol LoginViewControllerDelegate <NSObject>

@required
- (void)didLogin; //called after the user successfully logs in to 3rd party app

@end