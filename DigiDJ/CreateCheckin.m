#import "CreateCheckin.h"

@implementation CreateCheckin

@synthesize delegate;
@synthesize checkinData;
@synthesize venueId;

- (void)sendCheckin:(id)theDelegate theVenueId:(NSString *)theVenueId {
    
    self.delegate = theDelegate;
    checkinData = [NSMutableData data];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"access_token"];
    NSString *urlString = [NSString stringWithFormat:
                           @"https://api.foursquare.com/v2/checkins/add?oauth_token=%@&venueId=%@", accessToken, theVenueId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url 
                            cachePolicy:NSURLRequestReloadIgnoringCacheData 
                        timeoutInterval:10.0];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        checkinData = [NSMutableData data];
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [checkinData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [checkinData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:checkinData encoding:NSASCIIStringEncoding];
    NSLog(@"Song request sent to DJ.");
    [delegate didCheckin:dataContent];
}

@end
