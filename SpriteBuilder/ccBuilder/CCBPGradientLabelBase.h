//
//  CCLabelTTF.h
//  SpriteBuilder
//
//  Created by Sergey on 09/01/17.
//
//

#import "CCLabelTTF.h"

typedef NS_ENUM(unsigned char, CCGradientLabelGradientType)
{
    CCGradientLabelGradientTypeHorizontal,
    CCGradientLabelGradientTypeVertical,
};

@interface CCBPGradientLabelBase : CCLabelTTF
@property (nonatomic,strong) CCColor* gradientColor1;
@property (nonatomic,strong) CCColor* gradientColor2;
@property (nonatomic,assign) CCGradientLabelGradientType gradientType;
@end
