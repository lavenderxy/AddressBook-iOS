//
//  contactViewController.m
//  oktv
//
//  Created by Xinyu Yan on 4/7/16.
//  Copyright © 2016 freshdigitalgroup. All rights reserved.
//

#import "contactViewController.h"
#import "SearchDetailContainerViewController.h"
#import <Contacts/Contacts.h>

@interface contactViewController (){
    NSMutableArray *contacts;
    NSMutableArray *feeds;
    NSMutableArray *contactsStr;
    NSDictionary *feedsData;

}

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;


@end

@implementation contactViewController

@synthesize contactTableView;

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"EDIT MY FEED";
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                              NSFontAttributeName: [UIFont fontWithName:@"Gotham-Medium" size:19.0]}];
    _searchView.layer.cornerRadius =15;
    _searchTextField.text = @"";
    [_searchTextField becomeFirstResponder];
    _searchTextField.delegate = self;
    contactTableView.delegate = self;
    contactTableView.dataSource = self;
    
    contacts = [[NSMutableArray alloc] init];
    contactsStr = [[NSMutableArray alloc] init];
    feeds = [[NSMutableArray alloc] init];
//    [self getContacts];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)getFeeds{
    
    NSURL *feedsurl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oktv.freshdigitalgroup.com/app/1/videos/home"]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:feedsurl];
    [loginrequest setHTTPMethod:@"GET"];
    
    NSLog(@"about to invoke");
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:feedsurl
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                //    [NSURLConnection sendAsynchronousRequest:loginrequest
                //                                     queue:[[NSOperationQueue alloc] init]
                //                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSString *ret = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSLog(@"return from home data: %@", ret);
                //                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                
                feedsData = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:&error];
                
                [self performSelectorOnMainThread:@selector(feedsDataLoadedUpdate) withObject:nil waitUntilDone:NO];
                
                //                               dispatch_async(dispatch_get_main_queue(), ^{
                //                                 [self homeDataLoadedUpdate];
                //                           });
                
                //                               [self performSelectorOnMainThread:@selector(homeDataLoadedUpdate) withObject:nil waitUntilDone:NO];
                //[self homeDataLoadedUpdate];
                
                
            }] resume];

    
}

-(void)feedsDataLoadedUpdate {

}

//-(void)getContacts{
//    CNContactStore *store = [[CNContactStore alloc] init];
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!granted) {
//            dispatch_async(dispatch_get_main_queue(),^{
//            
//            });
//            return;
//        }
//        NSError *fetchError;
//        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey,[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]]];
//        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//            [contacts addObject:contact];
//        }];
//        if (!success) {
//            NSLog(@"error = %@",fetchError);
//        }
//        
//        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
//        for (CNContact* contact in contacts) {
//            NSString *string = [formatter stringFromContact:contact];
//            if (string!=nil) {
//                [contactsStr addObject:string];
//            }
//        }
//    }];
//    
//}

//-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
//    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc] initWithObjects:@[@"",@""] forKeys:@[@"firstName",@"lastName"]];
//    return NO;
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Lets go!");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Lets ret!");
    [self performSegueWithIdentifier:@"showSearchResults1" sender:self];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"seg: %@", segue);
    NSLog(@"seg id: %@", [segue identifier]);
    if ([segue identifier]!=nil) {
        if ([[segue identifier ] isEqualToString:@"showSearchResults1"]) {
            SearchDetailContainerViewController *sdc  = (SearchDetailContainerViewController *)[segue destinationViewController];
            [sdc setSearchString:_searchTextField.text];
            [super prepareForSegue:segue sender:sender];
        }
        return;
    }
    
    [super prepareForSegue:segue sender:sender];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return contacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    UILabel *label = nil;
    UIImageView *img = nil;
    UIButton *addBtn = nil;
 
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellC" forIndexPath:indexPath];
                label = [cell viewWithTag:1];
                break;
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:@"feedContactCell" forIndexPath:indexPath];
                label = [cell viewWithTag:1];
                img = [cell viewWithTag:2];
                break;
        }

    }else{
        switch (indexPath.row) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellC" forIndexPath:indexPath];
                label = [cell viewWithTag:1];
                break;
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
                label = [cell viewWithTag:1];
                img = [cell viewWithTag:2];
                addBtn = [cell viewWithTag:3];
                break;
        }

    }
    
    //configure the cell
    img.layer.cornerRadius = 25;
    [img setImage:[UIImage imageNamed:@"profile"]];
    [addBtn addTarget:self action:@selector(addFeed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                label.text = @"IN MY FEED";
                break;
            case 1:
                label.text = @"Jack Smith";
                
            default:
                break;
        }

    }else{
        
        switch (indexPath.row) {
            case 0:
                label.text = @"ADD TO MY FEED";
                break;
                
            default:
                label.text = [contactsStr objectAtIndex:indexPath.row];
                break;
        }
    }
    
    return cell;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 30.0;
            break;
            
        default:
            return 60.0;
            break;
    }

}

-(void)addFeed:(id)sender{
    NSLog(@"ssssssssss");
}

-(void)dismissKeyboard{
    [_searchTextField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
