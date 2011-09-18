#import <Foundation/Foundation.h>
#import "HelperFunctions.h"

@protocol FoursquareDetailProtocol;

@interface FoursquareUserDetailGetter : NSURLConnection

@property (assign, nonatomic) id <FoursquareDetailProtocol> delegate;
@property (strong, nonatomic) NSMutableData *userData;

- (void)getFriendData:(id)tableViewController;

@end

@protocol FoursquareDetailProtocol <NSObject>

- (void)didLoadFoursquareDetails:(NSString *)jsonData;

@end