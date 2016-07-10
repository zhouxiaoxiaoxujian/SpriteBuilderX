#import "ProjectSettings+Convenience.h"
#import "FCFormatConverter.h"
#import "CCBWarnings.h"
#import "NSString+RelativePath.h"
#import "MiscConstants.h"
#import "ResourcePropertyKeys.h"


@implementation ProjectSettings (Convenience)

- (BOOL)isPublishEnvironmentRelease
{
    return self.publishEnvironment == kCCBPublishEnvironmentRelease;
}

- (BOOL)isPublishEnvironmentDebug
{
    return self.publishEnvironment == kCCBPublishEnvironmentDevelop;
}

- (int)soundFormatForRelPath:(NSString *)relPath
{
    return [[self propertyForRelPath:relPath andKey:RESOURCE_PROPERTY_SOUND_FORMAT] intValue];
}

@end