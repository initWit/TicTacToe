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

@property CGAffineTransform transform;

@property (strong, nonatomic) NSTimer *myTimer;
@property int remainingSeconds;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property BOOL clickedInfoButton;
@property int pausedSecondsLeft;

@property (strong, nonatomic) IBOutlet UILabel *playModeLabel;

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

    self.transform = self.whichPlayerLabel.transform;

    [self resetBoard];

    self.timerLabel.text = @"Drag X to start";

    self.clickedInfoButton = NO;

    self.playModeLabel.text = self.playMode;

//    self.navigationController.navigationBarHidden = YES;

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (self.clickedInfoButton == YES) {

        if (![self.timerLabel.text isEqualToString:@"Drag X to start"]) {

            [self startTimer];
        }
    }

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

-(IBAction)onDrag:(UIPanGestureRecognizer* )panGestureRecognizer{

    CGPoint point;

    point = [panGestureRecognizer translationInView:self.view]; // *** get the point where your finger is from the gesture

    self.whichPlayerLabel.transform = CGAffineTransformMakeTranslation(point.x, point.y); // *** apply the point to the transform of the label

    point.x += self.whichPlayerLabel.center.x; // *** add an offset to the center of the label; now "point" is the center of the label
    point.y += self.whichPlayerLabel.center.y;

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) { // *** let go

        for (UILabel *eachLabel in self.ticTacToeGridArray) {

            if (CGRectContainsPoint(eachLabel.frame, point)){ // *** if the label's center is in the grid label, then set center

                if (eachLabel.text.length == 0) {
                    [self populateLabelWithCorrectPlayer:eachLabel];

                    [self setPlayerLabel];
                    self.numberOfTurnsTaken ++;

                    NSString *winnerString = [self whoWon];

                    if (winnerString != nil) {
                        NSString *messageString = [NSString stringWithFormat:@"%@ Won",winnerString];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageString
                                                                        message:@"Great Job!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Restart Game"
                                                              otherButtonTitles:nil];
                        alert.tag = 1;
                        [alert show];

                        [self endTimer];
                        break;

                    }

                    if ([self isTheBoardFilled])
                    {
                        self.whichPlayerLabel.transform = self.transform;
                        self.whichPlayerLabel.text = @"GAME OVER";

                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIE GAME"
                                                                        message:@"What a good battle!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Play again?"
                                                              otherButtonTitles:nil];
                        alert.tag = 1;
                        [alert show];

                        [self endTimer];
                        break;
                        
                    }

                    self.whichPlayerLabel.transform = self.transform;

                    [self endTimer];
                    [self startTimer];

                    break;

                } else { // frame is filled

                    [UIView animateWithDuration:0.5 animations:^{
                        self.whichPlayerLabel.transform = self.transform;
                    }];
                    break;
                }

            } else { // if not in the frame

                if (eachLabel.tag==9) {
                    NSLog(@"animate");

                    [UIView animateWithDuration:0.5 animations:^{
                        self.whichPlayerLabel.transform = self.transform;
                    }];
                }
            }

        } // end for each label loop


        if ([self whoWon] == nil && ![self.playMode isEqualToString: @"TwoPlayer"]) {
            [self computerTakesTurn];
        }

    } // end if touch ended

}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1) { // *** if it is the winner alert
        [self resetBoard];
    }
    else { // *** if it is the time expired alert

        if ([self.playMode isEqualToString: @"TwoPlayer"]) {
            self.isItPlayerOne = !self.isItPlayerOne; // *** switch players
            [self setPlayerLabel];
            [self startTimer];
        }
        else {
            self.isItPlayerOne = !self.isItPlayerOne; // *** switch players
            [self setPlayerLabel];
            [self computerTakesTurn];
        }
    }


}

#pragma mark Helper Methods

-(void)resetBoard {

    NSLog(@"Resetting Board");
    self.isItPlayerOne = YES;
    [self setPlayerLabel];
    self.numberOfTurnsTaken = 0;

    for (UILabel *label in self.ticTacToeGridArray) {
        label.text = @"";
    }

    self.whichPlayerLabel.transform = self.transform;

    self.timerLabel.text = @"Drag X to start";

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

    }
}


-(BOOL) isTheBoardFilled {

    if (self.numberOfTurnsTaken > 8) {
        return YES;
    }
    return NO;
}


- (NSString *) whoWon
{

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
        return @"O";
    }
    return nil;
}

#pragma mark - Timer helper methods

- (void) startTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(countDownClock)
                                   userInfo:nil
                                    repeats:YES];


    if (self.clickedInfoButton == YES && ![self.timerLabel.text isEqualToString:@"Drag X to start"]) {
        NSLog(@"came back timerlabel says %@", self.timerLabel.text);
        self.remainingSeconds = self.pausedSecondsLeft;
        self.timerLabel.text = [NSString stringWithFormat:@"%d",self.pausedSecondsLeft];
    }
    else {
        self.remainingSeconds = 10;
        self.timerLabel.text = @"10";
    }
    self.clickedInfoButton = NO;
}

- (void) countDownClock {

    if (--self.remainingSeconds == 0) {
        [self endTimer];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OUT OF TIME"
                                                        message:@"Move is forfeited"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
        self.timerLabel.text = [NSString stringWithFormat:@"%d",self.remainingSeconds];
}

-(IBAction) endTimer {
    [self.myTimer invalidate];
    self.myTimer = nil;
}

- (IBAction) didClickInfoButton {

    self.clickedInfoButton = YES;

    if (![self.timerLabel.text  isEqual: @"Drag X to start"]) {
        self.pausedSecondsLeft = self.remainingSeconds;
    }
}

- (IBAction)goToStartPage:(id)sender {

    [self endTimer];
    [self resetBoard];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) computerTakesTurn {
    if ([self.playMode isEqualToString:@"OnePlayerEasy"]) {
        [self easyComputerMakesSelection];
    }
    else{
        [self difficultComputerMakesSelection];
    }

}

- (void) easyComputerMakesSelection {

    for (UILabel *eachLabel in self.ticTacToeGridArray) {

        if (eachLabel.text.length == 0) {
            [self populateLabelWithCorrectPlayer:eachLabel];
            [self setPlayerLabel];
            self.numberOfTurnsTaken ++;

            NSString *winnerString = [self whoWon];

            if (winnerString != nil) {
                NSString *messageString = [NSString stringWithFormat:@"%@ Won",winnerString];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageString
                                                                message:@"Great Job!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Restart Game"
                                                      otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];

                [self endTimer];
                break;

            }

            if ([self isTheBoardFilled])
            {
                self.whichPlayerLabel.transform = self.transform;
                self.whichPlayerLabel.text = @"GAME OVER";

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIE GAME"
                                                                message:@"What a good battle!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Play again?"
                                                      otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];

                [self endTimer];
                break;

            }

            self.whichPlayerLabel.transform = self.transform;
            
            [self endTimer];
            [self startTimer];
            
            break;
        }
        
    } // end for loop

}

- (void) difficultComputerMakesSelection{

    NSMutableArray *gameState = [[NSMutableArray alloc]init];

    for (UILabel *eachLabel in self.ticTacToeGridArray) {

        [gameState addObject:eachLabel.text];

    }
    NSLog(@"%@",gameState);

    // user takes center

    if ([[gameState objectAtIndex:4] isEqualToString:@"X"]) {
        NSLog(@"USER PICKED CENTER");
    }
    if ([[gameState objectAtIndex:8] isEqualToString:@"X"]) {
        NSLog(@"USER PICKED OPPOSITE CORNER - ATTACK!");
    }

    if ([[gameState objectAtIndex:2] isEqualToString:@"X"] || [[gameState objectAtIndex:6] isEqualToString:@"X"]) {
        NSLog(@"USER PICKED CORNER = NOW BLOCK");
    }

    if ([[gameState objectAtIndex:1] isEqualToString:@"X"] || [[gameState objectAtIndex:3] isEqualToString:@"X"] || [[gameState objectAtIndex:5] isEqualToString:@"X"] || [[gameState objectAtIndex:7] isEqualToString:@"X"]) {
        NSLog(@"USER PICKED SIDE = NOW BLOCK");
    }




    for (UILabel *eachLabel in self.ticTacToeGridArray) {


        if (eachLabel.text.length == 0) {
            [self populateLabelWithCorrectPlayer:eachLabel];
            [self setPlayerLabel];
            self.numberOfTurnsTaken ++;

            NSString *winnerString = [self whoWon];

            if (winnerString != nil) {
                NSString *messageString = [NSString stringWithFormat:@"%@ Won",winnerString];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageString
                                                                message:@"Great Job!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Restart Game"
                                                      otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];

                [self endTimer];
                break;

            }

            if ([self isTheBoardFilled])
            {
                self.whichPlayerLabel.transform = self.transform;
                self.whichPlayerLabel.text = @"GAME OVER";

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIE GAME"
                                                                message:@"What a good battle!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Play again?"
                                                      otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];

                [self endTimer];
                break;

            }

            self.whichPlayerLabel.transform = self.transform;

            [self endTimer];
            [self startTimer];
            
            break;
        }
        
    } // end for loop




}

@end
