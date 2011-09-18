#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

#import "SpotifyAPIWrapper.h"
#import "Song.h"
#import "Venue.h"

@interface SpotifySearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SpotifyAPIProtocol, UIActionSheetDelegate>  {
    UITableView *spotifySearchResultsTable;
    UISearchBar *spotifySearchBar;
    NSMutableArray *spotifySearchResultsDataArray;
    Song *selectedSong;
}

@property (strong, nonatomic) UITableView *spotifySearchResultsTable; 
@property (strong, nonatomic) UISearchBar *spotifySearchBar;
@property (strong, nonatomic) NSMutableArray *spotifySearchResultsDataArray;
@property (strong, nonatomic) SpotifyAPIWrapper *spotifyAPIWrapper;
@property (strong, nonatomic) Song *selectedSong;
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;
@property (strong, nonatomic) Venue *venue;

@end
