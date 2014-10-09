#import "OptimizeImageWithOptiPNGOperation.h"

#import "CCBWarnings.h"
#import "PublishingTaskStatusProgress.h"
#import "ProjectSettings+Convenience.h"
#import "NSString+RelativePath.h"


@interface OptimizeImageWithOptiPNGOperation()

@property (nonatomic, strong) NSTask *task;

@end


@implementation OptimizeImageWithOptiPNGOperation

- (void)main
{
    [super main];

    [self assertProperties];

    [self optimizeImageWithOptiPNG];

    [_publishingTaskStatusProgress taskFinished];
}

- (void)assertProperties
{
    NSAssert(_filePath != nil, @"filePath should not be nil");
    NSAssert(_optiPngPath != nil, @"optiPngPath should not be nil");
}

- (void)optimizeImageWithOptiPNG
{
    [_publishingTaskStatusProgress updateStatusText:[NSString stringWithFormat:@"Optimizing %@...", [_filePath lastPathComponent]]];
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil] fileSize];
    NSString *intString = [NSString stringWithFormat:@"%llu", fileSize];
    NSString *processedPatch = nil;
    NSString *keyString = nil;
    
    int targets[] = {kCCBPublisherTargetTypeIPhone,kCCBPublisherTargetTypeAndroid};
    
    for(int i=0;i<2;++i)
    {
        NSString *publishDir = [[_projectSettings publishDirForTargetType:targets[i]]
                                absolutePathFromBaseDirPath:[_projectSettings.projectPath stringByDeletingLastPathComponent]];
        if([_filePath hasPrefix:publishDir])
        {
            keyString = [[_filePath substringFromIndex:publishDir.length+1] stringByAppendingString:intString];
            processedPatch = self.optiPngCache[keyString];
            break;
        }
    }
    
    if(processedPatch)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        if (![[NSFileManager defaultManager] copyItemAtPath:processedPatch toPath:_filePath error:&error])
        {
            [_warnings addWarningWithDescription:[error localizedDescription]];
        }
        return;
    }

    self.task = [[NSTask alloc] init];
    [_task setLaunchPath:_optiPngPath];
    [_task setArguments:@[_filePath]];

    // NSPipe *pipe = [NSPipe pipe];
    NSPipe *pipeErr = [NSPipe pipe];
    [_task setStandardError:pipeErr];

    // [_task setStandardOutput:pipe];
    // NSFileHandle *file = [pipe fileHandleForReading];

    NSFileHandle *fileErr = [pipeErr fileHandleForReading];

    int status = 0;

    @try
    {
        [_task launch];
        [_task waitUntilExit];
        status = [_task terminationStatus];
    }
    @catch (NSException *ex)
    {
        NSLog(@"[%@] %@", [self class], ex);
        return;
    }

    if (status)
    {
        NSData *data = [fileErr readDataToEndOfFile];
        NSString *stdErrOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *warningDescription = [NSString stringWithFormat:@"optipng error: %@", stdErrOutput];
        [_warnings addWarningWithDescription:warningDescription];
    }
    else
    {
        if(keyString)
            self.optiPngCache[keyString] = _filePath;
    }
}

- (void)cancel
{
    @try
    {
        [super cancel];
        [_task terminate];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"file: %@, file full: %@, optipng: %@", [_filePath lastPathComponent], _filePath, _optiPngPath];
}

@end