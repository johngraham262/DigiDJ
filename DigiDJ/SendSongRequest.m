#import "SendSongRequest.h"

@implementation SendSongRequest

@synthesize delegate;
@synthesize  songData;

- (void)sendSongRequest:(id)theDelegate 
             playlistId:(NSString *)playlistId 
                trackId:(NSString *)trackId 
              dollarAmt:(NSString *)dollarAmt {
    
    self.delegate = theDelegate;
    songData = [[NSMutableData alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://192.168.201.21:5000/playlists/%@/tracks/new?track_id=%@&dollar_amount=%@",
                           playlistId, trackId, dollarAmt];
    NSLog(@"UUUUUUUUUURL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url 
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                            timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        songData = [NSMutableData data];
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [songData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [songData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:songData encoding:NSASCIIStringEncoding];
    NSLog(@"Song request sent to DJ.");
    [delegate sendSongFinished:dataContent];
}

@end
