#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    LoginViewController *loginViewController = [[LoginViewController alloc] init];
//    VenueDJTableViewController *venueDJTableViewController = 
//        [[VenueDJTableViewController alloc] init];
    self.navigationController = [[NavigationController alloc] 
//                                 initWithRootViewController:venueDJTableViewController];
                                 initWithRootViewController:loginViewController];
    loginViewController.delegate = navigationController;
    
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    return YES;
}

@end
