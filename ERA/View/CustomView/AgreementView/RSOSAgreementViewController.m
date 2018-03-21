//
//  RSOSAgreementViewController.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/24/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import "RSOSAgreementViewController.h"

@interface RSOSAgreementViewController ()

@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) UIToolbar *toolbar;

@property (nonatomic) IBOutlet UIButton *backButton;

@end

@implementation RSOSAgreementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.hidesBackButton = YES;
//
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SOSBeacon_white.png"]];
//    self.navigationItem.title = @"";
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel:)];
//
//
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                         target:nil action:nil];
//
//    UIBarButtonItem *acceptItem = [[UIBarButtonItem alloc] initWithTitle:@"Accept"
//                                                                   style:UIBarButtonItemStyleDone
//                                                                  target:self
//                                                                  action:@selector(handleAccept:)];


//    self.toolbar = [[UIToolbar alloc] init];
//    [self.toolbar setItems:@[spaceItem, acceptItem]];
//
//    [self.view addSubview:self.toolbar];
//    [self.toolbar sizeToFit];
    
    /*
    CGRect r = self.toolbar.frame;
    r.origin = CGPointMake(0, self.view.frame.size.height-self.toolbar.frame.size.height);
    self.toolbar.frame = r;
    
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    r = self.view.bounds;
    //r.size.height = r.size.height-self.toolbar.frame.size.height;
    
    self.textView.frame = r;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
     
    */
    
    [self loadSource];
}

- (void)loadSource {
    
    // load Terms and Conditions
    
    if(!self.sourceURL || ![self.sourceURL isFileURL]) {
        return;
    }
    
    if(self.sourceURL) {
        
        NSError *error;
        NSString *termsTextString = [NSString stringWithContentsOfURL:self.sourceURL
                                                             encoding:NSUTF8StringEncoding
                                                                error:&error];
        if(!error) {
            
            NSMutableAttributedString *termsText = [[NSMutableAttributedString alloc] init];
            
            NSMutableParagraphStyle *headerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            headerParagraphStyle.alignment = NSTextAlignmentCenter;
            
            
            if(self.docTitle.length > 0) {
                
                NSString *titleString = [NSString stringWithFormat:@"%@\n\n", self.docTitle];
                
                [termsText appendAttributedString:[[NSAttributedString alloc] initWithString:titleString
                                                                                  attributes:@{
                                                                                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                                                                                               NSParagraphStyleAttributeName:headerParagraphStyle
                                                                                               }]];
            }
            
            [termsText appendAttributedString:[[NSAttributedString alloc] initWithString:termsTextString attributes:nil]];
            
            self.textView.attributedText = termsText;
        }
    }
}

- (void)setSourceURL:(NSURL *)sourceURL {
    _sourceURL = sourceURL;
    
    [self loadSource];
}

- (void)setDocTitle:(NSString *)docTitle {
    
    _docTitle = docTitle;
    
    [self loadSource];
}

- (void)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)doCancel:(id)sender {
//
//    UINavigationController *nc = (UINavigationController *)self.navigationController.presentingViewController;
//
//    if(nc && [nc isKindOfClass:[UINavigationController class]]) {
//        [nc popToRootViewControllerAnimated:NO];
//    }
//
//    [self dismissViewControllerAnimated:YES completion:^{
//
//    }];
//}
//
//- (void)handleAccept:(id)sender {
//
//
//}

@end
