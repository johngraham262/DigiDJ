#import <Foundation/Foundation.h>

@protocol SongDelegate <NSObject>

@required
- (void)didLoadSongData:(NSString *)jsonData;

@end

@protocol TotalSongsDelegate;

@interface Song : NSURLConnection <SongDelegate>

@property (copy, nonatomic) NSString *album;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *artist;
@property (copy, nonatomic) NSString *url;

@property (strong, nonatomic) id <TotalSongsDelegate> totalSongsDelegate;
@property (strong, nonatomic) id <SongDelegate> songDelegate;
@property (strong, nonatomic) NSMutableData *songData;
@property (copy, nonatomic) NSString *spotifyId;
@property (copy, nonatomic) NSString *dollarAmt;

- (void)getSongData:(id)theDelegate 
      totalDelegate:(id)totalDelegate
            trackId:(NSString *)trackId;

@end


@protocol TotalSongsDelegate <NSObject>

- (void)didCompleteSongs;

@end