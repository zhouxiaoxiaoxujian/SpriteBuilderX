#import <Foundation/Foundation.h>
#import "CCBPublisherTypes.h"
#import "CCBWarnings.h"

@class ProjectSettings;
@protocol TaskStatusUpdaterProtocol;
@class CCBPublishingTarget;


@interface CCBPublisher : NSObject

@property (nonatomic, weak) id<TaskStatusUpdaterProtocol> taskStatusUpdater;

- (id)initWithProjectSettings:(ProjectSettings *)someProjectSettings
                     warnings:(CCBWarnings *)someWarnings
                finishedBlock:(PublisherFinishBlock)finishBlock;

- (bool)start;
- (void)startAsync;

- (void)cancel;

//- (void)addPublishingTarget:(CCBPublishingTarget *)target;

@end
