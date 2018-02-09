#import "PublishModelFileOperation.h"

#import "CCBFileUtil.h"
#import "FCFormatConverter.h"
#import "CCBWarnings.h"
#import "ProjectSettings.h"
#import "ResourceManagerUtil.h"
#import "PublishRenamedFilesLookup.h"
#import "PublishingTaskStatusProgress.h"


@interface PublishModelFileOperation ()

@property (nonatomic, strong) FCFormatConverter *formatConverter;

@end


@implementation PublishModelFileOperation

- (void)main
{
    [super main];

    [self assertProperties];

    [self publishModelFileOperation];

    [_publishingTaskStatusProgress taskFinished];
}

- (void)assertProperties
{
    NSAssert(_srcFilePath != nil, @"srcFilePath should not be nil");
    NSAssert(_dstFilePath != nil, @"dstFilePath should not be nil");
    NSAssert(_fileLookup != nil, @"fileLookup should not be nil");
}

- (void)publishModelFileOperation
{
    [_publishingTaskStatusProgress updateStatusText:[NSString stringWithFormat:@"Publishing %@...", [_dstFilePath lastPathComponent]]];

    NSString *relPath = [_projectSettings findRelativePathInPackagesForAbsolutePath:_srcFilePath];
    if (!relPath)
    {
        NSString *warningText = [NSString stringWithFormat:@"Sound could not be published, relative path could not be determined for \"%@\"", _srcFilePath];
        [_warnings addWarningWithDescription:warningText];
        return;
    }

    [_fileLookup addRenamingRuleFrom:relPath to:[[FCFormatConverter defaultConverter] proposedNameForConvertedModelAtPath:relPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.dstFilePath = [[FCFormatConverter defaultConverter] proposedNameForConvertedModelAtPath:_dstFilePath];
    BOOL isDirty = [_projectSettings isDirtyRelPath:relPath];
    
    NSDate *srcDate = [CCBFileUtil modificationDateForFile:_srcFilePath];
    NSDate *dstDate = [CCBFileUtil modificationDateForFile:_dstFilePath];
    
    // Check if file already exists and have same date
    if (isDirty || !dstDate || fabs([srcDate timeIntervalSinceDate:dstDate]) > 0.0001)
    {
        NSString *tempFile = [[_dstFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"fbx"];

        NSError  *error;
        [fileManager removeItemAtPath:tempFile error:NULL];
        if (![fileManager copyItemAtPath:_srcFilePath toPath:tempFile error:&error])
        {
            NSLog(@"[PUBLISH][MODEL] Error: couldn't copy file from \"%@\" to \"%@\" with error %@", _srcFilePath, tempFile, error);
            return;
        }

        self.formatConverter = [FCFormatConverter defaultConverter];
        self.dstFilePath = [_formatConverter convertModelAtPath:tempFile format:self.format skip_normals:self.skipNormals error:&error];
        if (!_dstFilePath)
        {
            [_warnings addWarningWithDescription:[NSString stringWithFormat:@"Failed to convert audio file %@", relPath] isFatal:NO];
            self.formatConverter = nil;
            return;
        }
        self.formatConverter = nil;

        [CCBFileUtil setModificationDate:[CCBFileUtil modificationDateForFile:_srcFilePath] forFile:_dstFilePath];
    }
}

- (void)cancel
{
    [super cancel];
    [_formatConverter cancel];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"src: %@, dst: %@, srcfull: %@, dstfull: %@",
                     [_srcFilePath lastPathComponent], [_dstFilePath lastPathComponent], _srcFilePath, _dstFilePath];
}

@end
