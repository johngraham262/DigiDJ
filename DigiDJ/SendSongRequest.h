#import <Foundation/Foundation.h>

@protocol SendSongDelegate;

@interface SendSongRequest : NSURLConnection

@property (strong, nonatomic) NSMutableData *songData;
@property (strong, nonatomic) id <SendSongDelegate> delegate;

- (void)sendSongRequest:(id)theDelegate 
             playlistId:(NSString *)playlistId 
                trackId:(NSString *)trackId 
              dollarAmt:(NSString *)dollarAmt;

@end

@protocol SendSongDelegate <NSObject>

@optional
- (void)sendSongFinished:(NSString *)jsonData;

@end
