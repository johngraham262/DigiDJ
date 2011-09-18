#import <Foundation/Foundation.h>

@protocol FoursquareDetailProtocol;

@interface FoursquareUserDetailGetter : NSURLConnection

@property (assign, nonatomic) id <FoursquareDetailProtocol> delegate;
@property (strong, nonatomic) NSMutableData *userData;

@end

@protocol FoursquareDetailProtocol <NSObject>

- (void)didLoadFoursquareDetails:(NSString *)jsonData;

@end