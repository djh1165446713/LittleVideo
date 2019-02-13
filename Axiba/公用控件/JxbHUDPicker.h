//
//  JxbHUDPicker
//  iCoupon
//
//

#import <Foundation/Foundation.h>

typedef void(^JxbPickerSelect)(NSInteger index, NSString* text);

@interface JxbHUDPicker : NSObject

+  (instancetype)sharedInstance;
+  (void)showPicker:(NSArray*)data Title:(NSString*)title selectBlock:(JxbPickerSelect)selectBlock;
@end
