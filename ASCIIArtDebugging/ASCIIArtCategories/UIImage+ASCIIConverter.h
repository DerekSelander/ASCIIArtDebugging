//
//  UIImage+ASCIIConverter.h
//  ASCIIArtDebugging
//
//  Created by Derek Selander on 2/4/13.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ASCIIConverter)
- (NSString *)description;
- (NSString *)debugDescription;
@end
