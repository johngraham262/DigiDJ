#import "VenuesGetter.h"
#import "HelperFunctions.h"

@implementation VenuesGetter

@synthesize delegate;
@synthesize userData;

- (void)getVenues:(id)theDelegate{
    self.delegate = theDelegate;
    userData = [[NSMutableData alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://192.168.201.21:5000/playlists"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url 
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                            timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(connection) {
        userData = [NSMutableData data];
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CONNECTION FAILED: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *dataContent = [[NSString alloc] initWithData:userData encoding:NSASCIIStringEncoding];
    [delegate didLoadVenues:dataContent];
}

@end
