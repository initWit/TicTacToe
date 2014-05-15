//
//  ViewController.m
//  TicTacToe
//
//  Created by Robert Figueras on 5/15/14.
//  Copyright (c) 2014 AppSpaceship. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *myLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *myLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *myLabelThree;
@property (strong, nonatomic) IBOutlet UILabel *myLabelFour;
@property (strong, nonatomic) IBOutlet UILabel *myLabelFive;
@property (strong, nonatomic) IBOutlet UILabel *myLabelSix;
@property (strong, nonatomic) IBOutlet UILabel *myLabelSeven;
@property (strong, nonatomic) IBOutlet UILabel *myLabelEight;
@property (strong, nonatomic) IBOutlet UILabel *myLabelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property (strong, nonatomic) NSArray *ticTacToeGridArray;
@property (nonatomic) BOOL isItPlayerOne;

@property (nonatomic) NSInteger numberOfTurnsTaken;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.ticTacToeGridArray = [NSArray arrayWithObjects:self.myLabelOne,
                                   self.myLabelTwo,
                                   self.myLabelThree,
                                   self.myLabelFour,
                                   self.myLabelFive,
                                   self.myLabelSix,
                                   self.myLabelSeven,
                                   self.myLabelEight,
                                   self.myLabelNine,
                                   nil];

    [self resetBoard];


}

- (UILabel *)findLabelUsingPoint:(CGPoint) point{
//    NSLog(@"here is your point %f %f",point.x,point.y);

    for (UILabel *currentLabel in self.ticTacToeGridArray) {

        if (CGRectContainsPoint(currentLabel.frame, point)){
            NSLog(@"you touched label %d", currentLabel.tag);
            return currentLabel;
        }

    }

    return nil;
}

-(IBAction)onLabelTapped:(UITapGestureRecognizer*) tapGestureRecognizer {

    CGPoint tappedPoint = [tapGestureRecognizer locationInView:self.view];

    UILabel *selectLabel = [self findLabelUsingPoint:tappedPoint];

    if (selectLabel.text.length == 0) {
        [self populateLabelWithCorrectPlayer:selectLabel];
        [self setPlayerLabel];

        self.numberOfTurnsTaken ++;

        if ([self isTheBoardFilled]) {

            self.whichPlayerLabel.text = @"GAME OVER";
        }

        NSString *winnerString = [self whoWon];

        NSLog(@"winnerString: %@",winnerString);
        if (winnerString != nil) {
            NSString *messageString = [NSString stringWithFormat:@"%@ Won",winnerString];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageString
                                                            message:@"Great Job!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Restart Game"
                                                  otherButtonTitles:nil];
            [alert show];
        }

    }


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self resetBoard];
}

#pragma mark Helper Methods

-(void)resetBoard {

    self.isItPlayerOne = YES;
    [self setPlayerLabel];
    self.numberOfTurnsTaken = 0;

    for (UILabel *label in self.ticTacToeGridArray) {
        label.text = @"";
    }
}


- (void)populateLabelWithCorrectPlayer: (UILabel *)selectedLabel{

    if (self.isItPlayerOne) {
        selectedLabel.text = @"X";
        selectedLabel.textColor = [UIColor blueColor];
    }
    else {
        selectedLabel.text = @"O";
        selectedLabel.textColor = [UIColor redColor];
    }
    self.isItPlayerOne = !self.isItPlayerOne;

}

- (void)setPlayerLabel{

    if (self.isItPlayerOne) {
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
    }
    else {
        self.whichPlayerLabel.text = @"O";
        self.whichPlayerLabel.textColor = [UIColor redColor];

    }}

// helper method to determine if board is filled

-(BOOL) isTheBoardFilled {

    if (self.numberOfTurnsTaken > 8) {

        return YES;
    }
    return NO;
}


// helper method to determine winner

- (NSString *) whoWon
{
//    if ([self.my])

    NSString *first = [NSString stringWithFormat:@"%@",self.myLabelOne.text];
    NSString *second = [NSString stringWithFormat:@"%@",self.myLabelTwo.text];
    NSString *third = [NSString stringWithFormat:@"%@",self.myLabelThree.text];
    NSString *forth = [NSString stringWithFormat:@"%@",self.myLabelFour.text];
    NSString *fifth = [NSString stringWithFormat:@"%@",self.myLabelFive.text];
    NSString *sixth = [NSString stringWithFormat:@"%@",self.myLabelSix.text];
    NSString *seventh = [NSString stringWithFormat:@"%@",self.myLabelSeven.text];
    NSString *eighth = [NSString stringWithFormat:@"%@",self.myLabelEight.text];
    NSString *ninth = [NSString stringWithFormat:@"%@",self.myLabelNine.text];

    NSString *candidateWinner = [self testForWinner:first second:second third:third];

    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:forth second:fifth third:sixth];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:seventh second:eighth third:ninth];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:first second:forth third:seventh];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:second second:fifth third:eighth];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:third second:sixth third:ninth];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:first second:fifth third:ninth];
    if (candidateWinner == nil)
        candidateWinner = [self testForWinner:third second:fifth third:seventh];


    return candidateWinner;
}

- (NSString *)testForWinner:(NSString *)first second:(NSString *)second third:(NSString *)third
{
    if ([first isEqualToString:@"X"] && [second isEqualToString:@"X"] && [third isEqualToString:@"X"]) {
        NSLog(@"X IS THE WINNER");
        return @"X";
    }
    else if ([first isEqualToString:@"O"] && [second isEqualToString:@"O"] && [third isEqualToString:@"O"]) {
        NSLog(@"O IS THE WINNER");
        return @"Y";
    }
    return nil;
}

@end
