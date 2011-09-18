#import <Foundation/Foundation.h>
#import <Venmo/Venmo.h>

@interface HelperFunctions : NSObject

+ (NSString *)dateAsString;
+ (void)openVenmoAction:(UIViewController *)viewController
            venmoClient:(VenmoClient *)venmoClient 
       venmoTransaction:(VenmoTransaction *)venmoTransaction;

+ (void)openWebAction:(UIViewController *)viewController
          venmoClient:(VenmoClient *)venmoClient 
     venmoTransaction:(VenmoTransaction *)venmoTransaction;

@end