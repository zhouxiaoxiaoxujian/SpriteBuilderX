#import <Foundation/Foundation.h>

#import "ProjectSettings.h"
#import "CCBWarnings.h"

@interface ProjectSettings (Convenience)

- (BOOL)isPublishEnvironmentRelease;
- (BOOL)isPublishEnvironmentDebug;

- (int)soundFormatForRelPath:(NSString *)relPath;

/*- (NSArray *)publishingResolutionsForOSType:(CCBPublisherOSType)osType;

- (NSString *)publishDirForOSType:(CCBPublisherOSType)osType;

- (BOOL)publishEnabledForOSType:(CCBPublisherOSType)osType;


- (NSInteger)audioQualityForOsType:(CCBPublisherOSType)osType;*/
@end