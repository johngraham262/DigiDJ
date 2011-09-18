#import <Foundation/Foundation.h>

@protocol SpotifyAPIProtocol;

@interface SpotifyAPIWrapper : NSURLConnection

@property (strong, nonatomic) id <SpotifyAPIProtocol> delegate;
@property (strong, nonatomic) NSMutableData *spotifyData;

- (void)searchSpotifySong:(id)theDelegate withQuery:(NSString *)query;

@end

@protocol SpotifyAPIProtocol <NSObject>

-(void)didFinishSpotifyRequest:(NSString *)response;

@end