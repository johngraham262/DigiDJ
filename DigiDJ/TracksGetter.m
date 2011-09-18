#import "TracksGetter.h"

//http://192.168.201.21:5000/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks

@implementation TracksGetter

@synthesize delegate;
@synthesize tracksData;

- (void)getVenues:(id)theDelegate playlistId:(NSString *)playlistId {
    self.delegate = theDelegate;
    tracksData = [[NSMutableData alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://ec2-174-129-69-210.compute-1.amazonaws.com/playlists/%@/tracks", playlistId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url 
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                            timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        tracksData = [NSMutableData data];
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [tracksData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [tracksData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:tracksData encoding:NSASCIIStringEncoding];
    [delegate didGetTracks:dataContent];
}

@end
