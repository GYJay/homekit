//
//  CALayer+drawLine.h
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (drawLine)
-(void)drawLeftLineInContext:(CGContextRef)ref;
-(void)drawTopLineInContext:(CGContextRef)ref;
-(void)drawRightLineInContext:(CGContextRef)ref;
-(void)drawButtomLineInContext:(CGContextRef)ref;
@end
