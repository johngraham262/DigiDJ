#import "Song.h"
#import "SBJson.h"

@implementation Song

@synthesize album;
@synthesize name;
@synthesize artist;
@synthesize url;

@synthesize totalSongsDelegate;
@synthesize songDelegate;
@synthesize songData;
@synthesize spotifyId;
@synthesize dollarAmt;

- (void)getSongData:(id)theDelegate 
      totalDelegate:(id)totalDelegate
            trackId:(NSString *)trackId {
    
    self.songDelegate = theDelegate;
    self.totalSongsDelegate = totalDelegate;
    songData = [[NSMutableData alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://ws.spotify.com/lookup/1/.json?uri=spotify:track:%@", trackId];
    NSURL *theUrl = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:theUrl 
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
    [songDelegate didLoadSongData:dataContent];
}

- (void)didLoadSongData:(NSString *)jsonData {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *spotifySong = [[jsonParser objectWithString:jsonData error:&error] valueForKey:@"track"];
    
    self.artist = [spotifySong valueForKey:@"name"];
    self.album = [[spotifySong valueForKey:@"album"] valueForKey:@"name"];
    self.name = [spotifySong valueForKey:@"name"];
    
    [totalSongsDelegate didCompleteSongs];
}

@end
