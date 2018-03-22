//
//  RSOSUIPhoneTextField.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSOSUIPhoneTextField : UITextField <UITextFieldDelegate>

@property (weak, nonatomic) id<UITextFieldDelegate> m_delegate;

@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) NSString *szPattern;

- (void) setRegionCode: (NSString *) regionCode;
- (void) setPattern: (NSString *) pattern;

@end
