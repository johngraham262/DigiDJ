#import "PlaylistViewController.h"
#import "SpotifySearchViewController.h"

@implementation PlaylistViewController

@synthesize addSongButton;
@synthesize venmoClient;
@synthesize venue;

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
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    addSongButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Song" 
                                                     style:UIBarButtonItemStyleDone
                                                    target:self 
                                                    action:@selector(addSongAction)];
    self.navigationItem.rightBarButtonItem = addSongButton;
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
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //textLabel, detailTextLabel, imageView
    cell.textLabel.text = @"Song Name";
    cell.detailTextLabel.text = @"James Brown";
    UIImage *venuePic = [UIImage imageWithContentsOfFile:nil];
    cell.imageView.image = venuePic;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected a song from the playlist.");
}

@end
