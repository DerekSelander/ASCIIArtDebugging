//
//  UIImageView+ASCIIConverter.m
//  ASCII
//
//  Created by Derek Selander on 8/26/12.
//  Copyright (c) 2012 Derek Selander. All rights reserved.
//

#import "UIImageView+ASCIIConverter.h"

#define kMaxWidth   250.0f  //Adjust for console width
#define kMaxHeight  150.0f  //Adjust for console height
//Adjust for printing type.  i.e. Log for NSLog(@"%@", imageView), po imageView in debugger
static ASCIIImageViewType asciiDebugType = ASCIIImageViewTypeDebugOnly;

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;
static NSString * characterMap = @"#@8%Oo\";,'. ";

@implementation UIImageView (ASCIIConverter)

//****************************************************************
#pragma mark - Public Methods
//****************************************************************

- (NSString *)description
{
    NSMutableString *ASCIIString = [NSMutableString stringWithCapacity:self.image.size.width * self.image.size.height];
    [ASCIIString appendString:[super description]];
    
    if (!self.image) {
        [ASCIIString appendString:@"Image is nil!"];
        return ASCIIString;
    } else if (asciiDebugType == ASCIIImageViewTypeBoth ||
               asciiDebugType == ASCIIImageViewTypeLogOnly) {
        [ASCIIString appendString:@"\n"];
        [ASCIIString appendString:[self convertToASCII]];
        [ASCIIString appendString:@"\n"];
    }

    return (NSString *)ASCIIString;
}

- (NSString *)debugDescription
{
    NSMutableString *ASCIIString = [NSMutableString stringWithCapacity:self.image.size.width * self.image.size.height];
    [ASCIIString appendString:[super description]];
    if (!self.image) {
        [ASCIIString appendString:@"Image is nil!"];
        return ASCIIString;
    } else if (asciiDebugType == ASCIIImageViewTypeBoth ||
               asciiDebugType == ASCIIImageViewTypeDebugOnly) {
        [ASCIIString appendString:@"\n"];
        [ASCIIString appendString:[self convertToASCII]];
        [ASCIIString appendString:@"\n"];
    }

    return (NSString *)ASCIIString;
}

//****************************************************************
#pragma mark - "Private" Methods
//****************************************************************

- (NSString *)convertToASCII {
    
    UIImage *resizedImage = [self resizedImageToFitInSize:CGSizeMake(kMaxHeight, kMaxHeight) scaleIfSmaller:YES];
    CGSize size = resizedImage.size;
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8.0f, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), resizedImage.CGImage);
    NSMutableString *ASCIIString = [NSMutableString stringWithCapacity:width * height + width];
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            NSUInteger position = lroundf((CGFloat)gray * 11.0f/255.0f);
            [ASCIIString appendFormat:@"%c", [characterMap characterAtIndex:position]];
            
        }
        [ASCIIString appendString:@"\n"];
    }
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    return [ASCIIString copy];
}

-(UIImage*)resizedImageToSize:(CGSize)dstSize
{
	CGImageRef imgRef = self.image.CGImage;
	// the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
	CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
	CGFloat scaleRatio = dstSize.width / srcSize.width;
	UIImageOrientation orient = self.image.imageOrientation;
	CGAffineTransform transform = CGAffineTransformIdentity;
	switch(orient) {
            
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
            
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0f);
			transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
			break;
            
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
            
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
			transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
			break;
            
		case UIImageOrientationLeftMirrored: //EXIF = 5
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
			transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
			transform = CGAffineTransformRotate(transform, 3.0f * M_PI_2);
			break;
            
		case UIImageOrientationLeft: //EXIF = 6
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(0.0f, srcSize.width);
			transform = CGAffineTransformRotate(transform, 3.0f * M_PI_2);
			break;
            
		case UIImageOrientationRightMirrored: //EXIF = 7
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
            
		case UIImageOrientationRight: //EXIF = 8
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0f);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
            
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
	}
    
	UIGraphicsBeginImageContextWithOptions(dstSize, NO, 0.0f);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -srcSize.height, 0.0f);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0.0f, -srcSize.height);
	}
    
	CGContextConcatCTM(context, transform);
    
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, 0.0f, srcSize.width, srcSize.height), imgRef);
	UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return resizedImage;
}

-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale
{
	CGImageRef imgRef = self.image.CGImage;
	CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); 
    
	UIImageOrientation orient = self.image.imageOrientation;
	switch (orient) {
		case UIImageOrientationLeft:
		case UIImageOrientationRight:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
			break;
        default:
            break;
	}
    
	// Compute the target CGRect in order to keep aspect-ratio
	CGSize dstSize;
    
	if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
		dstSize = srcSize; 
	} else {
		CGFloat wRatio = boundingSize.width / srcSize.width;
		CGFloat hRatio = boundingSize.height / srcSize.height;
        
		if (wRatio < hRatio) {
			dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
		} else {
			dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
		}
	}

	return [self resizedImageToSize:dstSize];
}

@end
