#import <Foundation/Foundation.h>

@protocol VenuesGetterDelegate;

@interface VenuesGetter : NSURLConnection

@property (strong, nonatomic) NSMutableData *userData;
@property (strong, nonatomic) id <VenuesGetterDelegate> delegate;

- (void)getVenues:(id)theDelegate;

@end

@protocol VenuesGetterDelegate <NSObject>

@required
- (void)didLoadVenues:(NSString *)jsonData;

@end
