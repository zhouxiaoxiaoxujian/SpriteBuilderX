#import <Foundation/Foundation.h>
#import "PublishBaseOperation.h"

@class CCBWarnings;
@class FCFormatConverter;
@protocol PublishFileLookupProtocol;

@interface PublishModelFileOperation : PublishBaseOperation

@property (nonatomic, copy) NSString *srcFilePath;
@property (nonatomic, copy) NSString *dstFilePath;
@property (nonatomic, strong) id<PublishFileLookupProtocol>  fileLookup;

@end