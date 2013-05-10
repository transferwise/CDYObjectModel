//
//  UploadMoneyViewController.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UploadMoneyViewController.h"
#import "BlueButton.h"

@interface UploadMoneyViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *toggleButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;
@property (strong, nonatomic) IBOutlet BlueButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;

@end

@implementation UploadMoneyViewController

- (id)init{
    self = [super initWithNibName:@"UploadMoneyViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnClicked:(id)sender {
}
- (IBAction)toggleButtonValueChanged:(id)sender {
}


- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setFooterView:nil];
    [self setToggleButton:nil];
    [self setHeaderLabel:nil];
    [self setFooterLabel:nil];
    [self setDoneButton:nil];
    [self setNotificationLabel:nil];
    [super viewDidUnload];
}
@end
