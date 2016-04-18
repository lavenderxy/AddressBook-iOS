//
//  contactViewController.h
//  oktv
//
//  Created by Xinyu Yan on 4/7/16.
//  Copyright © 2016 freshdigitalgroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface contactViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *contactTableView;

@end
