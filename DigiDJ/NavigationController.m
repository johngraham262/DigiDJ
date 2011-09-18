#import "NavigationController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "HelperFunctions.h"

@implementation NavigationController

@synthesize venueDJTableViewController;
@synthesize logoutButton;
@synthesize venmoClient;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
