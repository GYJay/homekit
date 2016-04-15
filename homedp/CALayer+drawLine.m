//
//  CALayer+drawLine.m
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "CALayer+drawLine.h"
#import <UIKit/UIKit.h>
@implementation CALayer (drawLine)
-(void)drawLeftLineInContext:(CGContextRef)ref{
    [self drawLineInContext:ref fromX:0 fromY:0 toX:0 toY:self.bounds.size.height color:[[UIColor whiteColor] colorWithAlphaComponent:0.5] width:1];
}

-(void)drawTopLineInContext:(CGContextRef)ref{
    [self drawLineInContext:ref fromX:0 fromY:0 toX:self.bounds.size.width toY:0 color:[[UIColor whiteColor] colorWithAlphaComponent:0.5] width:1];
}

-(void)drawRightLineInContext:(CGContextRef)ref{
    [self drawLineInContext:ref fromX:self.bounds.size.width fromY:0 toX:self.bounds.size.width toY:self.bounds.size.height color:[[UIColor whiteColor] colorWithAlphaComponent:0.5] width:1];
}

-(void)drawButtomLineInContext:(CGContextRef)ref{
    [self drawLineInContext:ref fromX:0 fromY:self.bounds.size.height toX:self.bounds.size.width toY:self.bounds.size.height color:[[UIColor whiteColor] colorWithAlphaComponent:0.5] width:1];
}


- (void)drawLineInContext:(CGContextRef)ref
                    fromX:(CGFloat)startX
                    fromY:(CGFloat)startY
                      toX:(CGFloat)targetX
                      toY:(CGFloat)targetY
                    color:(UIColor *)color
                    width:(CGFloat)width {
    if (color == nil || color == [NSNull class])
        return;
    CGContextMoveToPoint(ref, startX, startY);
    CGContextAddLineToPoint(ref, targetX, targetY);
    CGContextSetStrokeColorWithColor(ref, color.CGColor);
    CGContextSetLineWidth(ref, width);
    CGContextStrokePath(ref);
}
@end
