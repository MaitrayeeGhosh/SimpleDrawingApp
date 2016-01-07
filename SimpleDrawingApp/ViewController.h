//
//  ViewController.h
//  SimpleDrawingApp
//
//  Created by Maitrayee Ghosh on 06/01/16.
//  Copyright © 2016 Maitrayee Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasUIView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController
- (IBAction)didTapPenSelectionBtn:(id)sender;
- (IBAction)didTapErazerBtn:(id)sender;
- (IBAction)didTapSaveBtn:(id)sender;

@property (weak, nonatomic) IBOutlet CanvasUIView *canvas;


@end

