//
//  ViewController.h
//  AddressBook
//
//  Created by Xinyu Yan on 4/8/16.
//  Copyright © 2016 Xinyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
- (IBAction)showPicker:(id)sender;

@end

