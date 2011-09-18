#import <Foundation/Foundation.h>

@protocol CreateCheckinDelegate;

@interface CreateCheckin : NSURLConnection

@property (strong, nonatomic) NSMutableData *checkinData;
@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) id <CreateCheckinDelegate> delegate;

- (void)sendCheckin:(id)theDelegate theVenueId:(NSString *)theVenueId;

@end

@protocol CreateCheckinDelegate <NSObject>

@optional
- (void)didCheckin:(NSString *)jsonData;

@end
