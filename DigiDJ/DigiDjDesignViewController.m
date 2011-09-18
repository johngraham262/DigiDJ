#import "DigiDjDesignViewController.h"

@implementation DigiDjDesignViewController

@synthesize delegate;
@synthesize connectButton;

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
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeBackground.png"]];
    [self.view addSubview:backgroundImage];
    
    connectButton = [[UIButton alloc] initWithFrame:CGRectMake(320/3, 480/2, 110, 110)];

    [connectButton addTarget:self action:@selector(connectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:connectButton];
}

- (void)connectButtonClicked:id {

    NSLog(@"connect button clicked");
    [delegate didOpenApp];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
