#import <Foundation/Foundation.h>

@protocol TracksGetterDelegate;

@interface TracksGetter : NSURLConnection

@property (strong, nonatomic) id <TracksGetterDelegate> delegate;
@property (strong, nonatomic) NSMutableData *tracksData;

- (void)getVenues:(id)theDelegate playlistId:(NSString *)playlistId;

@end

@protocol TracksGetterDelegate <NSObject>

@required
- (void)didGetTracks:(NSString *)jsonData;

@end
