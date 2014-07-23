//
//  ContactDetailsViewController.m
//  Transfer
//
//  Created by Mats Trovik on 17/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "PlainPresentationCell.h"
#import "RecipientTypeField.h"
#import "TypeFieldValue.h"

@interface ContactDetailsViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ContactDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib * cellNib = [UINib nibWithNibName:@"PlainPresentationCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PlainPresentationCellIdentifier];
    [self.tableView reloadData];
    self.nameLabel.text = self.recipient.name;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipient.fieldValues count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlainPresentationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    if(indexPath.row < [self.recipient.fieldValues count])
    {
        TypeFieldValue* value = [self.recipient.fieldValues objectAtIndex:indexPath.row];
        [cell configureWithTitle:value.valueForField.title text:value.value];
    }
    else
    {
        [cell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.email", nil) text:self.recipient.email?:@"-"];
    }
    return cell;
}


@end
