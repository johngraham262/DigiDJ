#import "VenueDJTableViewController.h"
#import "SBJson.h"

@implementation VenueDJTableViewController

@synthesize venueDJList;
@synthesize logoutButton;
@synthesize foursquareId;
@synthesize foursquareUserDetailGetter;
@synthesize venuesGetter;
@synthesize venmoClient;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Digi DJ";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    foursquareUserDetailGetter = [[FoursquareUserDetailGetter alloc] init];
    [foursquareUserDetailGetter getFriendData:self];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    venuesGetter = [[VenuesGetter alloc] init];
    [venuesGetter getVenues:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venueDJList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
    }
    
    Venue *venueAtPath = [venueDJList objectAtIndex:[indexPath row]];
    
    //textLabel, detailTextLabel, imageView
    cell.textLabel.text = venueAtPath.venueName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"DJ %@ is spinnin'", venueAtPath.venmoName];
    UIImage *venuePic = [UIImage imageWithContentsOfFile:nil];
    cell.imageView.image = venuePic;

    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Venue *venueAtPath = [venueDJList objectAtIndex:[indexPath row]];
    PlaylistViewController *playlistViewController = [[PlaylistViewController alloc] init];
    playlistViewController.venmoClient = venmoClient;
    playlistViewController.venue = venueAtPath;
    playlistViewController.title = venueAtPath.venueName;
    [self.navigationController pushViewController:playlistViewController animated:YES];
}

- (void)didLoadFoursquareDetails:(NSString *)jsonData {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = [jsonParser objectWithString:jsonData error:&error];
    NSArray *userJSON = [[jsonObjects valueForKey:@"response"] valueForKey:@"user"];
    
    foursquareId = [userJSON valueForKey:@"id"];
    NSLog(@"4sq id is: %@", foursquareId);
}

- (void)didLoadVenues:(NSString *)jsonData {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *venues = [jsonParser objectWithString:jsonData error:&error];
    
    venueDJList = [[NSMutableArray alloc] init];
    
    NSEnumerator *e = [venues objectEnumerator];
    id venue;
    while (venue = [e nextObject]) {
        Venue *newVenue = [[Venue alloc] init];
        newVenue.playlistId = [venue valueForKey:@"playlist_id"];
        newVenue.foursquareId = [[venue valueForKey:@"foursquare_venue"] valueForKey:@"id"];
        newVenue.venueName = [[venue valueForKey:@"foursquare_venue"] valueForKey:@"name"];
        newVenue.venmoUsername = [[venue valueForKey:@"venmo_user"] valueForKey:@"username"];
        newVenue.venmoName = [[venue valueForKey:@"venmo_user"] valueForKey:@"name"];
        
        [venueDJList addObject:newVenue];
    }
    [self.tableView reloadData];
}

@end
