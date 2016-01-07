//
//  CanvasUIView.m
//  SimpleDrawingApp
//
//  Created by Maitrayee Ghosh on 06/01/16.
//  Copyright © 2016 Maitrayee Ghosh. All rights reserved.
//

#import "CanvasUIView.h"

#define DEFAULT_COLOR               [UIColor blackColor]
#define DEFAULT_WIDTH               5.0f

static const CGFloat kPointMinDistance = 5.0f;
static const CGFloat kPointMinDistanceSquared = kPointMinDistance * kPointMinDistance;
@interface CanvasUIView ()
@property (nonatomic,assign) CGPoint currentPoint;
@property (nonatomic,assign) CGPoint previousPoint;
@property (nonatomic,assign) CGPoint previousPreviousPoint;
#pragma mark Private Helper function
CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation CanvasUIView
{
@private
    CGMutablePathRef _path;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _path = CGPathCreateMutable();
        _lineWidth = DEFAULT_WIDTH;
        _lineColor = DEFAULT_COLOR;
        _empty = YES;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _path = CGPathCreateMutable();
        _lineWidth = DEFAULT_WIDTH;
        _lineColor = DEFAULT_COLOR;
        _empty = YES;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
   /************** While Drawing ******************/
    if (!_erasing) {
        [self.backgroundColor set];
        UIRectFill(rect);
        // get the graphics context and draw the path
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, _path);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        
        CGContextStrokePath(context);
        self.empty = NO;
    }
    /************** While Erazing ******************/
    else
    {
        [self.backgroundColor set];
        UIRectFill(rect);
        // get the graphics context and draw the path
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextAddPath(context, _path);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _lineWidth);
        
        CGContextStrokePath(context);
        
    }
}

#pragma mark - private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - Touch event handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.previousPoint = [touch previousLocationInView:self];
    self.previousPreviousPoint = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    [self touchesMoved:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    CGFloat dx = point.x - self.currentPoint.x;
    CGFloat dy = point.y - self.currentPoint.y;
    
    if ((dx * dx + dy * dy) < kPointMinDistanceSquared) {
        
        return;
    }
    
    self.previousPreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    CGPoint mid1 = midPoint(self.previousPoint, self.previousPreviousPoint);
    CGPoint mid2 = midPoint(self.currentPoint, self.previousPoint);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL,
                              self.previousPoint.x, self.previousPoint.y,
                              mid2.x, mid2.y);
    
    CGRect bounds = CGPathGetBoundingBox(subpath);
    CGRect drawBox = CGRectInset(bounds,  -0.5 *self.lineWidth, -0.5 *self.lineWidth);
    CGPathAddPath(_path, NULL, subpath);
    CGPathRelease(subpath);
    
    [self setNeedsDisplayInRect:drawBox];
    
}

-(UIImage *)getTheImage
{
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext( self.bounds.size );
    [_canvasImage drawInRect:CGRectMake(0,0,self.bounds.size .width,self.bounds.size .height)];
    [drawImage drawInRect:CGRectMake(0,0,self.bounds.size .width,self.bounds.size .height) blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
