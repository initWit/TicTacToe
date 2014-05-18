//
//  WebViewController.m
//  TicTacToe
//
//  Created by Robert Figueras on 5/18/14.


#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate,UITextFieldDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UITextField *myURLTextField;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mySpinner;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:NO];

    self.myWebView.scrollView.delegate = self;

    NSURL *myURL = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.myWebView loadRequest:request];

}

- (IBAction)showMyAlert:(id)sender {

    UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"Coming soon!"
                                                         message:@"Coming soon!"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [myAlertView show];
}

- (IBAction)onForwardButtonPressed:(id)sender
{
    [self.myWebView goForward];
}

- (IBAction)onBackButtonPressed:(id)sender
{

    [self.myWebView goBack];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender

{
    [self.myWebView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender
{
    [self.myWebView reload];
}

#pragma mark - UIWebViewDelegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.mySpinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    if ([self.myWebView canGoForward])
    {
        [self.forwardButton setEnabled:YES];
    }
    else
    {
        [self.forwardButton setEnabled: NO];
    }

    if ([self.myWebView canGoBack])
    {
        [self.backButton setEnabled:YES];
    }
    else
    {
        [self.backButton setEnabled: NO];
    }


    // *** set the navigation title as the website title

    self.myURLTextField.text = webView.request.URL.absoluteString;
    NSString *titleFromTheWebViewString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = titleFromTheWebViewString;

    // *** stop spinning only when webview is done loading

    if (![webView isLoading]) {
        [self.mySpinner stopAnimating];
    }

    // *** refresh the UITextField every time a new page is loaded

    self.myURLTextField.frame = CGRectMake(20.0, 80.0, self.myURLTextField.frame.size.width, self.myURLTextField.frame.size.height);
    self.myURLTextField.alpha = 1.0;

}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat myOffset = (self.myWebView.scrollView.contentOffset.y + 64.0); // *** adjust scrollview offset for nav controller 64 px

    int fadeRate = 30; // *** the lower the fadeRate, the faster the fade

    if (myOffset > 0) {
        self.myURLTextField.alpha = (1-((myOffset)/fadeRate)); // *** fade textfield based on position of scrollview and fadeRate
        self.myURLTextField.frame = CGRectMake(20.0, (80.0 - myOffset), self.myURLTextField.frame.size.width, self.myURLTextField.frame.size.height);
    }
    else { // *** if user springs scrollview below 0, reset textfield position and alpha
        self.myURLTextField.frame = CGRectMake(20.0, 80.0, self.myURLTextField.frame.size.width, self.myURLTextField.frame.size.height);
        self.myURLTextField.alpha = 1.0;
    }

}
- (IBAction)goBackToGame:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSString *finishedURL = textField.text;

    if (![textField.text hasPrefix:@"http://"]) {
        finishedURL = [@"http://" stringByAppendingString:textField.text];
    }

    NSURL *myURL = [NSURL URLWithString:finishedURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.myWebView loadRequest:request];
    [textField resignFirstResponder];
    
    return YES;
    
}


@end
