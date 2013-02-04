//
//  UIImageView+ASCIIConverter.h
//  ASCII
//
//  Created by Derek Selander on 8/26/12.
//  Copyright (c) 2012 Derek Selander. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ASCIIImageViewTypeDebugOnly,
    ASCIIImageViewTypeLogOnly,
    ASCIIImageViewTypeBoth,
} ASCIIImageViewType;

@interface UIImageView (ASCIIConverter)
- (NSString *)description;
- (NSString *)debugDescription;
@end
