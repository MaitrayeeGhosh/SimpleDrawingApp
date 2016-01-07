//
//  CanvasUIView.h
//  SimpleDrawingApp
//
//  Created by Maitrayee Ghosh on 06/01/16.
//  Copyright © 2016 Maitrayee Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasUIView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL empty;
@property (nonatomic, assign) BOOL erasing;
@property(strong,nonatomic)UIImage *canvasImage;
-(UIImage *)getTheImage;

@end
