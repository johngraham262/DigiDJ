#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "NavigationController.h"
#import "LoginViewController.h"
#import "VenueDJTableViewController.h"
#import "Venue.h"
#import "Song.h"

@class NavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate, VenmoClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) NavigationController *navigationController;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) VenmoClient *venmoClient;

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) Song *song;

@end
