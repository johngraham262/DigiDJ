#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (copy, nonatomic) NSString *album;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *artist;
@property (copy, nonatomic) NSString *url;

@end
