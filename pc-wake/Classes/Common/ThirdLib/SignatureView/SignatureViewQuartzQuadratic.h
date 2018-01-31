//
//  NICSignatureViewQuartzQuadratic.h
//  SignatureDemo
//
//  Created by Jason Harwig on 11/6/12.
//  Copyright (c) 2012 Near Infinity Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureViewQuartzQuadratic : UIView

/**
 * <#name#>
 */
typedef void (^DrawBlock)();

@property (assign, nonatomic) BOOL hasSignature;

@property (strong, nonatomic) UIImage *signatureImage;

/**
 * <#name#>
 */
@property (nonatomic, copy) DrawBlock block;

@end
