//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Kritsakorn on 7/24/15.
//  Copyright (c) 2015 Kritsakorn. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

#define AppPartnerURL @"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"

@interface LoginSectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view sendSubviewToBack:self.bg];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (IBAction)loginAction:(id)sender
{
    NSDictionary *parameters = @{@"username": self.usernameText.text, @"password": self.passwordText.text};
    NSURL *url = [NSURL URLWithString:AppPartnerURL];
    NSData *postData = [self encodeDictionary:parameters];
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // Peform the request
        [self PerformLoginRequest:request];
    });
}

- (void) PerformLoginRequest:(NSMutableURLRequest*) request
{
    NSURLResponse *response;
    NSError *error = nil;
    NSDate *start=[NSDate date];
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                            error:&error];
    NSDate *end=[NSDate date];
    double ellapsedMilliSeconds= [end timeIntervalSinceDate:start]*1000;
    
    if (error) {
        // Deal with your error
        NSLog(@"Error %@", error);
        return;
    }
    else {
        NSString *responeString = [[NSString alloc] initWithData:receivedData
                                                        encoding:NSUTF8StringEncoding];
        
        //convert string JSON to NSArray
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[responeString dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSString *code = [jsonObject valueForKey:@"code"];
        NSString *message = [jsonObject valueForKey:@"message"];
        NSString *messageWithTime = [NSString stringWithFormat:@"%@\n The API call took in %0.2f milliseconds.",message,ellapsedMilliSeconds];
        
        //add alert view
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:code withMessage:messageWithTime];
        });
    }

}

- (void) showAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return NO;
}

@end
