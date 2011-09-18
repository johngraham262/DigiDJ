#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "LoginViewController.h"
#import "VenueDJTableViewController.h"
#import "FoursquareUserDetailGetter.h"

@interface NavigationController : UINavigationController

@property (strong, nonatomic) VenueDJTableViewController *venueDJTableViewController;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) VenmoClient *venmoClient;

@end
