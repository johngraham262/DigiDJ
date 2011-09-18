#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "PlaylistViewController.h"
#import "FoursquareUserDetailGetter.h"
#import "VenuesGetter.h"
#import "Venue.h"

@interface VenueDJTableViewController : UITableViewController <FoursquareDetailProtocol, VenuesGetterDelegate>

@property (strong, nonatomic) NSMutableArray *venueDJList;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSString *foursquareId;
@property (strong, nonatomic) FoursquareUserDetailGetter *foursquareUserDetailGetter;
@property (strong, nonatomic) VenuesGetter *venuesGetter;
@property (strong, nonatomic) VenmoClient *venmoClient;

@end
