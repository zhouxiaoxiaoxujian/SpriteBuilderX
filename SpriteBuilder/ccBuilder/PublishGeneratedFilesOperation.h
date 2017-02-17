#import <Foundation/Foundation.h>
#import "PublishBaseOperation.h"
#import "CCBWarnings.h"

@class PublishRenamedFilesLookup;

@interface PublishGeneratedFilesOperation : PublishBaseOperation

@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, copy) NSString *outputDir;
@property (nonatomic, strong) NSMutableSet *publishedSpriteSheetFiles;
@property (nonatomic, strong) PublishRenamedFilesLookup *fileLookup;
@property (nonatomic, copy) NSString *packet;

@end
