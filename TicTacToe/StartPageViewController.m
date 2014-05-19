//
//  StartPageViewController.m
//  TicTacToe
//
//  Created by Robert Figueras on 5/18/14.
//  Copyright (c) 2014 AppSpaceship. All rights reserved.
//

#import "StartPageViewController.h"
#import "ViewController.h"

@interface StartPageViewController ()

@end

@implementation StartPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{

    ViewController *nextViewController = segue.destinationViewController;
    nextViewController.playMode = segue.identifier;
    
}
@end
