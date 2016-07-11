#import <Foundation/Foundation.h>
#import "PublishBaseOperation.h"
#import "CCBWarnings.h"

@class DateCache;
@class CCBDirectoryPublisher;
@class FCFormatConverter;
@protocol PublishFileLookupProtocol;
@class PlatformSettings;

@interface PublishImageOperation : PublishBaseOperation

@property (nonatomic, retain) PlatformSettings *platformSettings;
@property (nonatomic, copy) NSString *srcFilePath;
@property (nonatomic, copy) NSString *dstFilePath;
@property (nonatomic, copy) NSString *outputDir;
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, copy) NSString *platformName;

@property (nonatomic, strong) id<PublishFileLookupProtocol> fileLookup;

@property (nonatomic) BOOL isSpriteSheet;

@property (nonatomic, strong) DateCache *modifiedFileDateCache;

@property (nonatomic) BOOL intermediateProduct;

@end