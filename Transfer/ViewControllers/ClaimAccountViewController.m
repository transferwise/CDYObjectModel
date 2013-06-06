//
//  ClaimAccountViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ClaimAccountViewController.h"
#import "TextEntryCell.h"

@interface ClaimAccountViewController ()

@property (nonatomic, strong) IBOutlet TextEntryCell *emailCell;
@property (nonatomic, strong) IBOutlet TextEntryCell *passwordCell;

@end

@implementation ClaimAccountViewController

- (id)init {
    self = [super initWithNibName:@"ClaimAccountViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    NSMutableArray *cells = [NSMutableArray array];

    TextEntryCell *email = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:email];
    [cells addObject:email];
    [email configureWithTitle:NSLocalizedString(@"login.email.field.title", nil) value:@""];
    [email.entryField setReturnKeyType:UIReturnKeyNext];
    [email.entryField setKeyboardType:UIKeyboardTypeEmailAddress];

    TextEntryCell *password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordCell:password];
    [cells addObject:password];
    [password configureWithTitle:NSLocalizedString(@"login.password.field.title", nil) value:@""];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];

    [self setPresentedSectionCells:cells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
