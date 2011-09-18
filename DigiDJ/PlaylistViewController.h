#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "Song.h"
#import "Venue.h"
#import "TracksGetter.h"

@interface PlaylistViewController : UITableViewController <TracksGetterDelegate, TotalSongsDelegate>

@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) UIBarButtonItem *addSongButton;
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) TracksGetter *tracksGetter;

@end
