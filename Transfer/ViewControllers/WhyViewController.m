//
//  WhyViewController.m
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "WhyViewController.h"

@interface WhyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *leftRateValue;
@property (weak, nonatomic) IBOutlet UILabel *leftDescription1;
@property (weak, nonatomic) IBOutlet UILabel *leftFeeValue;
@property (weak, nonatomic) IBOutlet UILabel *leftDescription2;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *rightRateValue;
@property (weak, nonatomic) IBOutlet UILabel *rightDescription1;
@property (weak, nonatomic) IBOutlet UILabel *rightFeeValue;
@property (weak, nonatomic) IBOutlet UILabel *rightDescription2;

@property (weak, nonatomic) IBOutlet UILabel *vsTitle;
@property (weak, nonatomic) IBOutlet UILabel *rateTitle;
@property (weak, nonatomic) IBOutlet UILabel *feeTitle;

@end

@implementation WhyViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
