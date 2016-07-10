#import <Foundation/Foundation.h>
#import "PublishBaseOperation.h"
#import "CCBWarnings.h"


@class CCBWarnings;
@class ProjectSettings;
@class PlatformSettings;

@interface PublishSpriteSheetOperation : PublishBaseOperation

@property (nonatomic, retain) PlatformSettings *platformSettings;
@property (nonatomic, copy) NSString *spriteSheetFile;
@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, copy) NSString *subPath;
@property (nonatomic, strong) NSArray *srcDirs;
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, copy) NSDate *srcSpriteSheetDate;
@property (nonatomic, copy) NSString *publishDirectory;
@property (nonatomic, strong) NSMutableSet *publishedPNGFiles;

// Prevents multiple creation of the same preview image of a spritesheet for different resolutions
// Call before a sprite sheet is generated for multiple resolutions
+ (void)resetSpriteSheetPreviewsGeneration;

@end

