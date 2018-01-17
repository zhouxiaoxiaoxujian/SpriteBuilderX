#import <Foundation/Foundation.h>

extern NSString *const RESOURCE_PROPERTY_TRIM_SPRITES;

extern NSString *const RESOURCE_PROPERTY_IMAGE_TABLET_SCALE;
extern NSString *const RESOURCE_PROPERTY_IMAGE_SCALE_FROM;

extern NSString *const RESOURCE_PROPERTY_IS_SMARTSHEET;
extern NSString *const RESOURCE_PROPERTY_LEGACY_KEEP_SPRITES_UNTRIMMED;

extern NSString *const RESOURCE_PROPERTY_IS_SKIPDIRECTORY;

extern NSString *const RESOURCE_PROPERTY_IMAGE_FORMAT;
extern NSString *const RESOURCE_PROPERTY_SOUND_FORMAT;

extern NSString *const RESOURCE_PROPERTY_FORMAT_PADDING;
extern NSString *const RESOURCE_PROPERTY_FORMAT_EXTRUDE;

extern NSString *const RESOURCE_PROPERTY_MODEL_FORMAT;
extern NSString *const RESOURCE_PROPERTY_MODEL_SKIP_NORMALS;

extern NSString *const RESOURCE_PROPERTY_CCB_TYPE;

typedef enum : NSUInteger {
    CCBTypeScene = 0,
    CCBTypePrefab
} CCBType;
