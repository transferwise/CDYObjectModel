//
//  CustomInfoViewController.m
//  Transfer
//
//  Created by Mats Trovik on 09/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"

@interface CustomInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation CustomInfoViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setDefaultAction];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setDefaultAction];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setDefaultAction];
    }
    return self;
}

-(void)setDefaultAction
{
    __weak typeof(self) weakSelf = self;
    self.actionButtonBlock = ^{
        [weakSelf dismiss];
    };
}

-(void)viewDidLoad
{
    [self.actionButton setTitle:self.actionButtonTitle forState:UIControlStateNormal];
    self.infoLabel.text = self.infoText;
    self.titleLabel.text = self.titleText;
    self.infoImageView.image = self.infoImage;
    [super viewDidLoad];
}

-(void)setInfoText:(NSString *)infoText
{
    _infoText = infoText;
    self.infoLabel.text = infoText;
}

-(void)setTitleText:(NSString *)title
{
    _titleText = title;
    self.titleLabel.text = title;
}

-(void)setActionButtonTitle:(NSString *)dismissButtonTitle
{
    _actionButtonTitle = dismissButtonTitle;
    [self.actionButton setTitle:dismissButtonTitle forState:UIControlStateNormal];
}

-(void)setInfoImage:(UIImage *)infoImage
{
    _infoImage = infoImage;
    self.infoImageView.image = infoImage;
}

-(IBAction)actionButtonTapped
{
    if(self.actionButtonBlock)
    {
        self.actionButtonBlock();
    }
}

-(IBAction)closebuttonTapped
{
    if(self.mapCloseButtonToAction)
    {
        if(self.actionButtonBlock)
        {
            self.actionButtonBlock();
        }
    }
    else
    {
        [self dismiss];
    }
}

@end
