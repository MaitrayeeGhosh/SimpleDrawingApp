//
//  ViewController.m
//  SimpleDrawingApp
//
//  Created by Maitrayee Ghosh on 06/01/16.
//  Copyright © 2016 Maitrayee Ghosh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _canvas.canvasImage=[UIImage imageNamed:@"BackgroundImage.png"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapPenSelectionBtn:(id)sender {
    
    _canvas.erasing=NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:(id)self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Red Pen", @"Blue Pen", @"Green Pen",@"Black Pen",@"Cancel", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        _canvas.lineColor=[UIColor redColor];
    }
    else if (buttonIndex==1)
    {
         _canvas.lineColor=[UIColor blueColor];
    }
    else if (buttonIndex==2)
    {
        _canvas.lineColor=[UIColor greenColor];
    }
    else if (buttonIndex==3)
    {
        _canvas.lineColor=[UIColor blackColor];
    }
    
}


- (IBAction)didTapErazerBtn:(id)sender {
    
      _canvas.erasing=YES;
}

- (IBAction)didTapSaveBtn:(id)sender {

    UIImage *newImage=[_canvas getTheImage];
     CIImage *SaveImage = [[CIImage alloc] initWithCGImage:newImage.CGImage options:nil];
    CIContext *context = [CIContext contextWithOptions:nil];
    context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImg = [context createCGImage:SaveImage
                                     fromRect:[SaveImage extent]];
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[SaveImage properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congrats" message:@"Photo saved in album" delegate:Nil cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                              [alertView show];
                              NSLog(@"error: %@",error);
                              
                              CGImageRelease(cgImg);
                          }];
}
@end
