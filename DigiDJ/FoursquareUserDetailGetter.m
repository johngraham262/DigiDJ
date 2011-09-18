#import "FoursquareUserDetailGetter.h"

@implementation FoursquareUserDetailGetter

@synthesize delegate;
@synthesize userData;

- (void)getFriendData:(id)tableViewController {
    self.delegate = tableViewController;
    userData = [[NSMutableData alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"access_token"];
    NSString *urlString = [NSString stringWithFormat:
                           @"https://api.foursquare.com/v2/users/self/friends?oauth_token=%@&v=%@", 
                           accessToken, [HelperFunctions dateAsString]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url 
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                            timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    if(connection) {
        friendData = [NSMutableData data];
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [userData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [userData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataContent = [[NSString alloc] initWithData:userData encoding:NSASCIIStringEncoding];
    [delegate didLoadFoursquareDetails:dataContent];
}

@end
