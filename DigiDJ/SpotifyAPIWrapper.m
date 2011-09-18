#import "SpotifyAPIWrapper.h"
#import "Song.h"

@implementation SpotifyAPIWrapper

@synthesize delegate;
@synthesize spotifyData;

- (void)searchSpotifySong:(id)theDelegate withQuery:(NSString *)query{
    
    self.delegate = theDelegate;
    NSString* escapedUrlString = [query stringByAddingPercentEscapesUsingEncoding:
                                  NSASCIIStringEncoding];
    
    spotifyData = [[NSMutableData alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://ws.spotify.com/search/1/track.json?q=%@", escapedUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        spotifyData = [NSMutableData data];        
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"%@", response);
    //[spotifyData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [spotifyData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:spotifyData encoding:NSASCIIStringEncoding];
    [delegate didFinishSpotifyRequest:dataContent];
}

@end