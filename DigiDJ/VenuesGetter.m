#import "VenuesGetter.h"
#import "HelperFunctions.h"

@implementation VenuesGetter

@synthesize delegate;
@synthesize venuesData;

- (void)getVenues:(id)theDelegate{
    self.delegate = theDelegate;
    venuesData = [[NSMutableData alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://ec2-174-129-69-210.compute-1.amazonaws.com/playlists"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url 
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                            timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        venuesData = [NSMutableData data];
    } else {
        NSLog(@"connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [venuesData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [venuesData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:venuesData encoding:NSASCIIStringEncoding];
    [delegate didLoadVenues:dataContent];
}

@end
