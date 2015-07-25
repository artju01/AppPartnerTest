//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Kritsakorn on 7/24/15.
//  Copyright (c) 2015 Kritsakorn. All rights reserved.
//


#import "ChatCell.h"

@interface ChatCell ()
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    [self.usernameLabel sizeToFit];
    self.messageTextView.text = chatData.message;
    [self.messageTextView sizeToFit];
    
    //UITextView's size changes to fit the content
    CGSize sizeThatShouldFitTheContent = [self.messageTextView  sizeThatFits:self.messageTextView.frame.size];
    
    //set new height for NSLayoutAttributeHeight
    for (NSLayoutConstraint *constraint in self.messageTextView.constraints) {
        if ([constraint firstAttribute] == NSLayoutAttributeHeight) {
            [constraint setConstant:sizeThatShouldFitTheContent.height];
        }
    }
    self.messageTextView.textContainerInset = UIEdgeInsetsZero;
    
    if (!chatData.avatar_image) {
        NSURL *url = [NSURL URLWithString:chatData.avatar_url];
        
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [ChatCell makeCircularLayer:self.userIcon];
                self.userIcon.image = image;
                // cache tthe image
                chatData.avatar_image = image;
            }
        }];
    }
    else {
        [ChatCell makeCircularLayer:self.userIcon];
        self.userIcon.image = chatData.avatar_image;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ( !error )
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES,image);
        } else{
            completionBlock(NO,nil);
        }
    }];
}

+ (void) makeCircularLayer:(UIImageView*) imageView
{
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:imageView.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
}



@end
