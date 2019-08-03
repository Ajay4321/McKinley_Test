//
//  ViewController.m
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "WebViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *txtId;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _btnLogin.layer.cornerRadius = 4.0;
}

- (IBAction)loginPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if (_txtId.text == nil && _txtPassword == nil) {
        [self showAlertWithMessage:@"Id and Pasword cannot be blank."];
    }
    else if (_txtId == nil)
    {
        [self showAlertWithMessage:@"Id cannot be blank."];
    }
    else if (_txtPassword == nil)
    {
        [self showAlertWithMessage:@"Pasword cannot be blank."];
    }
    else if ([self validateEmailWithString:_txtId.text] == NO)
    {
        [self showAlertWithMessage:@"Invalid email id."];
    }
    else
    {
        NSDictionary *param = @{
                                @"email": _txtId.text,
                                @"password": _txtPassword.text
                                };
        [[DataManager sharedManager] loginWithParameters:param withCompletionHandler:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error)
            {
                NSLog(@"alksdhalskdhl %@",error.localizedDescription);
            }else
            {
                [[DataManager sharedManager] saveData:[responseObject objectForKey:@"token"] withKey:@"userToken"];
                [self showweWebViewWithToken:[responseObject objectForKey:@"token"]];
            }
        }];
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)showAlertWithMessage:(NSString *)msg
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!!!!"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showweWebViewWithToken:(NSString *)token
{
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webView.userToken = token;
    [self.navigationController pushViewController:webView animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

@end
