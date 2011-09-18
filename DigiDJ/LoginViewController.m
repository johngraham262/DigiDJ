#import "LoginViewController.h"

@implementation LoginViewController

@synthesize delegate;

#pragma mark - webView

- (UIWebView *)webView {
    return (UIWebView *)self.view;
}

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Digi DJ";
    }
    return self;
}

- (void)setupLoadView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    webView.delegate = self;
    self.view = webView;
}

- (void)loadView {
    [self setupLoadView];
}

/**
 * Go to the 4sq authentication site so the user can enter credentials.
 */
- (void) setupViewDidLoad {
    
    // Delete any previous cookies and access tokens.
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [cookieJar cookies]) {
//        [cookieJar deleteCookie:cookie];
//    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"access_token"];
    
    // Load the web view.
    NSString *authURLString = [NSString stringWithFormat:
                               @"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@&display=touch", 
                               foursquareClientId, foursquareCallbackURL];
    NSURL *authURL = [NSURL URLWithString:authURLString];
    NSLog(@"\nauthURLString: %@", authURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    
    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"<-- %@", requestString);

    //catch the access_token before webView has a chance to error out, then close webview 
    if([requestString rangeOfString:@"access_token="].location != NSNotFound) {
        
        //store the access token in NSUserDefaults
        NSString *accessToken = [[requestString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
        
        NSLog(@"*** returning to DrinksOnMe with token: %@", accessToken);
        [delegate didLogin]; //this also closes the webView (from navigationController)
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"--> %@", [[self.webView.request URL] absoluteString]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@", [error debugDescription]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
    
    NSString *URLString = [[self.webView.request URL] absoluteString];
    NSLog(@"<-- %@", URLString);
}

@end
