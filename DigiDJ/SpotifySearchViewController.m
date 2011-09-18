#import "SpotifySearchViewController.h"
#import "SBJson.h"
#import "Song.h"
#import "AppDelegate.h"

typedef enum {
    PLAY_QUEUE      = 0,
    PLAY_NEXT       = 1
} actionSheetButton;

@interface SpotifySearchViewController ()
- (void)openVenmoAction:(UIViewController *)viewController
            venmoClient:(VenmoClient *)venmoClient 
       venmoTransaction:(VenmoTransaction *)venmoTransaction;
@end

@implementation SpotifySearchViewController

@synthesize spotifySearchResultsTable;
@synthesize spotifySearchBar;
@synthesize spotifySearchResultsDataArray;
@synthesize spotifyAPIWrapper;
@synthesize selectedSong;
@synthesize venmoClient;
@synthesize venmoTransaction;
@synthesize venue;
@synthesize sendSongRequest;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //spotify search bar
    spotifySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    spotifySearchBar.placeholder = @"Search for your song";
    spotifySearchBar.delegate = self;
    
    //spotify uitableview
    spotifySearchResultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+40, 320, 480-44-40)];
    spotifySearchResultsTable.delegate = self;
    spotifySearchResultsTable.dataSource = self;
    

    //dummy data
    spotifySearchResultsDataArray = [[NSMutableArray alloc] init];
    /*
    NSArray *dk1 = [NSArray arrayWithObjects:@"name", @"id", @"artist",nil];
    NSArray *dv1 = [NSArray arrayWithObjects:@"Get on Up", @"XY1", @"James Brown", nil];
    
    NSArray *dk2 = [NSArray arrayWithObjects:@"name", @"id", @"artist",nil];
    NSArray *dv2 = [NSArray arrayWithObjects:@"Heal The World", @"XY47", @"Michael Jackson", nil];
    
    
    NSDictionary *dummyDict1 = [NSDictionary dictionaryWithObjects:dv1 forKeys:dk1];
    NSDictionary *dummyDict2 = [NSDictionary dictionaryWithObjects:dv2 forKeys:dk2];

    [spotifySearchResultsDataArray addObject:dummyDict1];
    [spotifySearchResultsDataArray addObject:dummyDict2];
    */
    
    [self.view addSubview:spotifySearchBar];
    [self.view addSubview:spotifySearchResultsTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [spotifySearchResultsDataArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];  
    } else {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
    }
    
    Song *currentSong = [spotifySearchResultsDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = currentSong.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"By %@ on %@", currentSong.artist, currentSong.album];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Song *currentSong = [spotifySearchResultsDataArray objectAtIndex:indexPath.row];
    selectedSong = currentSong;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[NSString stringWithFormat:@"Play \"%@\" by %@?", currentSong.name, currentSong.artist] 
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:@"Add to queue for $0.99", @"Play next for $5.00", nil];
    [actionSheet showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    CGFloat amount = 0.99f;
    NSString *dollar = @".99";
    
    if (buttonIndex == PLAY_QUEUE) {
        //initiate 99c payment
        amount = 0.99f;
    } else if (buttonIndex == PLAY_NEXT) {
        //initiate 5d payment
        amount = 5.00f;
        dollar = @"5.00";
    } else {
        return;
    }
    
    NSString *note = [NSString stringWithFormat:@"to play \"%@\" by %@ from the album %@", 
                      selectedSong.name, selectedSong.artist, selectedSong.album];
    
    venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.amount = amount;
    venmoTransaction.note = note;
    venmoTransaction.toUserHandle = venue.venmoUsername;
    [self openVenmoAction:self venmoClient:venmoClient venmoTransaction:venmoTransaction];
    
    //send the song request to the server
    sendSongRequest = [[SendSongRequest alloc] init];
    [sendSongRequest sendSongRequest:nil 
                          playlistId:venue.playlistId
                             trackId:selectedSong.url
                           dollarAmt:dollar];
}

- (void)openVenmoAction:(UIViewController *)theViewController
            venmoClient:(VenmoClient *)theVenmoClient 
       venmoTransaction:(VenmoTransaction *)theVenmoTransaction {
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    appDel.venue = venue;
    appDel.song = selectedSong;
    
    VenmoViewController *venmoViewController = [theVenmoClient viewControllerWithTransaction:
                                                theVenmoTransaction forceWeb:NO];
    if (venmoViewController) {
        [theViewController presentModalViewController:venmoViewController animated:YES];
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[spotifySearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [spotifySearchResultsDataArray removeAllObjects];
    [spotifySearchResultsTable reloadData];
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];	
    NSLog(@"Search for: %@", searchBar.text);
    //SEARCH HERE
    spotifyAPIWrapper = [[SpotifyAPIWrapper alloc] init];
    spotifyAPIWrapper.delegate = self;
    [spotifyAPIWrapper searchSpotifySong:self withQuery:searchBar.text];
}

#pragma mark -
#pragma mark Spotify API Request

- (void)didFinishSpotifyRequest:(NSString *)response {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = [jsonParser objectWithString:response error:&error];
    
    spotifyAPIWrapper = [[NSMutableArray alloc] init];
    NSArray *allSongs = [jsonObjects valueForKey:@"tracks"];
    
    NSEnumerator *e = [allSongs objectEnumerator];
    id song;
    int limit = 0;
    while (song = [e nextObject]) {
        if (limit==25) {
            break;
        }
        Song *newSong = [[Song alloc] init];
        newSong.name = [song valueForKey:@"name"];
        newSong.artist = [[[song valueForKey:@"artists"] valueForKey:@"name"] objectAtIndex:0];
        newSong.album = [[song valueForKey:@"album"] valueForKey:@"name"];
        NSString *oldURL = [song valueForKey:@"href"];
        newSong.url = [oldURL stringByReplacingOccurrencesOfString:@"spotify:track:" withString:@""];

        [spotifySearchResultsDataArray addObject:newSong];
        limit++;
    }
    [spotifySearchResultsTable reloadData];
}

@end
