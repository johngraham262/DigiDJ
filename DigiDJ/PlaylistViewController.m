#import "PlaylistViewController.h"
#import "SpotifySearchViewController.h"

#import "SBJson.h"

@implementation PlaylistViewController

@synthesize songs;
@synthesize addSongButton;
@synthesize venmoClient;
@synthesize venue;
@synthesize tracksGetter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Playlist";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem.title = @"Back"; //these don't work
    
    addSongButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Song" 
                                                     style:UIBarButtonItemStyleDone
                                                    target:self 
                                                    action:@selector(addSongAction)];
    self.navigationItem.rightBarButtonItem = addSongButton;
    
    self.songs = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    tracksGetter = [[TracksGetter alloc] init];
    [tracksGetter getVenues:self playlistId:venue.playlistId];
}

- (void)addSongAction {
    NSLog(@"add song clicked");
    SpotifySearchViewController *spotifyView = [[SpotifySearchViewController alloc] init];
    spotifyView.venmoClient = venmoClient;
    spotifyView.venue = venue;
    [self.navigationController pushViewController:spotifyView animated:YES];
}

- (void)viewDidUnload
{
    self.songs  = nil;
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of tracks: %d", songs.count);
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Song *songAtPath = [songs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ($%@)", songAtPath.name, songAtPath.dollarAmt];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", songAtPath.artist, songAtPath.album];
    
    //textLabel, detailTextLabel, imageView
//    cell.textLabel.text = @"Song Name";
//    cell.detailTextLabel.text = @"James Brown";
//    UIImage *venuePic = [UIImage imageWithContentsOfFile:nil];
//    cell.imageView.image = venuePic;
//    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected a song from the playlist.");
}

//[{"track_id":"26nr9XnFCYWxBTIP7HyWXg","dollar_amount":"0.99"}]

- (void)didGetTracks:(NSString *)jsonData {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *trackIds = [jsonParser objectWithString:jsonData error:&error];
    
    [songs removeAllObjects];
    
    NSEnumerator *e = [trackIds objectEnumerator];
    id aTrack;
    while (aTrack = [e nextObject]) {
        Song *newSong = [[Song alloc] init];
        newSong.spotifyId = [aTrack valueForKey:@"track_id"];
        newSong.dollarAmt = [aTrack valueForKey:@"dollar_amount"];
        [songs addObject:newSong];
        
        NSLog(@"%@ - %@", newSong.spotifyId, newSong.dollarAmt);
        
        //get the meta data from the spotify api
        [newSong getSongData:newSong totalDelegate:self trackId:newSong.spotifyId];
    }
}

- (void)didCompleteSongs {
    [self.tableView reloadData];
}

@end
