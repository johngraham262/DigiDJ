#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "Venue.h"

@interface PlaylistViewController : UITableViewController

@property (strong, nonatomic) UIBarButtonItem *addSongButton;
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) Venue *venue;

@end
