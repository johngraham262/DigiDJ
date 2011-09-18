#import "AppDelegate.h"

@interface AppDelegate ()

- (void)createLoginItems;

@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize loginViewController;
@synthesize logoutButton;
@synthesize venmoClient;
@synthesize digiDjDesignViewController;

@synthesize venue;
@synthesize song;

- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    // Create the Venmo Client object (used for sending a payment through venmo)
    self.venmoClient = [VenmoClient clientWithAppId:venmoAppId 
                                             secret:venmoAppSecret
                                            localId:venmoLocalAppId];
    venmoClient.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessTok = [defaults objectForKey:@"access_token"];

    NSLog(@"access tok: %@", accessTok);
    
    logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                    style:UIBarButtonItemStyleDone 
                                                   target:self 
                                                   action:@selector(logout)];
    
    if(!accessTok) {
        digiDjDesignViewController = [[DigiDjDesignViewController alloc] init];
        digiDjDesignViewController.delegate = self;
        window.rootViewController = digiDjDesignViewController;
    } else {
        [self createLoginItems];
    }
    
    
    [window makeKeyAndVisible];
    return YES;
}

- (void)didOpenApp {
    loginViewController = [[LoginViewController alloc] init];
    loginViewController.delegate = self;
    
    self.navigationController = [[NavigationController alloc]
                                 initWithRootViewController:loginViewController];
    navigationController.venmoClient = venmoClient;
//    window.rootViewController = navigationController;    
    
    [UIView transitionWithView:window duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        window.rootViewController = navigationController;
                    } completion:NULL];
}

- (void)didLogin {
    NSLog(@"Successfully logged into foursquare.");
    
    [self createLoginItems];

    [UIView transitionWithView:window duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        window.rootViewController = navigationController;
                    } completion:NULL];
    
    //    [self dismissModalViewControllerAnimated:YES];
}

- (void)logout {
    NSLog(@"logout pressed");
    
    // clear the access token from user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_token"];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }

    loginViewController = [[LoginViewController alloc] init];
    loginViewController.delegate = self;
    [UIView transitionWithView:self.window duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.window.rootViewController = loginViewController;
                    } completion:NULL];
    
    // show the login web view
    //    [self presentModalViewController:loginViewController animated:YES];
}

- (void)createLoginItems {
    VenueDJTableViewController *venueDJTableViewController = 
    [[VenueDJTableViewController alloc] init];
    venueDJTableViewController.logoutButton = logoutButton;
    venueDJTableViewController.venmoClient = venmoClient;
    navigationController = [[NavigationController alloc] 
                            initWithRootViewController:venueDJTableViewController];
    navigationController.venmoClient = venmoClient;
    navigationController.venueDJTableViewController = venueDJTableViewController;
    navigationController.viewControllers = [NSArray arrayWithObject:venueDJTableViewController];
    window.rootViewController = navigationController;
}


/**
 * Called when a payment finishes and the data is being sent back to DrinksOnMe.
 * - as an example, the data is displayed in a popup alert.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", url);
    return [venmoClient openURL:url completionHandler:^(VenmoTransaction *transaction, NSError *error) {
        if (transaction) {
            
            [navigationController popViewControllerAnimated:YES];
            
            NSString *title;
            NSString *message;
            if(transaction.success) {
                title = @"Rock on!";
                message = [NSString stringWithFormat:@"You're rolling deep with DJ %@'s playlist and jamming to \"%@\"!", venue.venmoName, song.name];
            } else {
                title = @"That stings...";
                message = [NSString stringWithFormat:@"We're sorry. Your jam was unable to be added to DJ %@'s playlist.", venue.venmoName];
            }
            
//            NSString *success = (transaction.success ? @"Success" : @"Failure");
//            NSString *title = [@"Transaction " stringByAppendingString:success];
//            NSString *message = [@"payment_id: " stringByAppendingFormat:@"%i. %i %@ %@ (%i) $%@ %@",
//                                 transaction.id,
//                                 transaction.fromUserId,
//                                 transaction.typeStringPast,
//                                 transaction.toUserHandle,
//                                 transaction.toUserId,
//                                 transaction.amountString,
//                                 transaction.note];    
//            NSString *message = (transaction.success ?
//                                 [NSString stringWithFormat:@"You paid %@ %@.", transaction.amountString, transaction.note] : 
//                                 [NSString stringWithFormat:@"Error paying %@ %@.", transaction.amountString, transaction.note]);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            NSLog(@"Playlist id: %@", venue.playlistId);
            NSLog(@"Foursquare id: %@", venue.foursquareId);
            NSLog(@"Song url: %@", song.url);
            [alertView show];
        } else { // error
            NSLog(@"transaction error code: %i", error.code);
        }
    }];
}

/**
 * Called when the device is running less than iOS 5
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#pragma mark - VenmoClientDelegate

- (id)venmoClient:(VenmoClient *)client JSONObjectWithData:(NSData *)data {
    return nil;
}
#endif

@end
