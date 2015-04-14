//
//  CustomInfoViewController.m
//  Transfer
//
//  Created by Mats Trovik on 09/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"

@interface CustomInfoViewController ()
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
        [self commonSetup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self commonSetup];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self commonSetup];
    }
    return self;
}

-(void)commonSetup
{
    _mapCloseButtonToActionIndex = NSNotFound;
}


-(void)viewDidLoad
{
    [self setActionButtonTitles:self.actionButtonTitles];
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

-(void)setActionButtonTitles:(NSArray *)actionButtonTitles
{
    _actionButtonTitles = actionButtonTitles;
    NSUInteger buttonCount = [self.actionButtons count];
    [actionButtonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx < buttonCount)
        {
            if([obj isKindOfClass:[NSString class]])
            {
                [self.actionButtons[idx] setTitle:obj forState:UIControlStateNormal];
            }
            else
            {
                [self.actionButtons[idx] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }];
    
}

-(void)setActionButtonBlocks:(NSArray *)actionButtonBlocks
{
    NSMutableArray* clone = [NSMutableArray arrayWithCapacity:[actionButtonBlocks count]];
    for (id block in actionButtonBlocks)
    {
        [clone addObject:[block copy]];
    }
    _actionButtonBlocks = clone;
}

-(void)setInfoImage:(UIImage *)infoImage
{
    _infoImage = infoImage;
    self.infoImageView.image = infoImage;
}

-(IBAction)actionButtonTapped:(UIButton*)target
{
    NSUInteger index = [self.actionButtons indexOfObject:target];
    if(![self executeButtonActionBlockAtIndex:index])
    {
        [self dismiss];
    }
    
}

-(BOOL)executeButtonActionBlockAtIndex:(NSUInteger)index
{
    if(index != NSNotFound && index < [self.actionButtonBlocks count])
    {
        id actionBlock = self.actionButtonBlocks[index];
        if(![actionBlock isEqual:[NSNull null]])
        {
            ActionButtonBlock actionButtonBlock = (ActionButtonBlock) actionBlock;
            actionButtonBlock();
            return YES;
        }
    }
    return NO;
}


-(IBAction)closebuttonTapped
{
    if(![self executeButtonActionBlockAtIndex:self.mapCloseButtonToActionIndex])
    {
        [self dismiss];
    }
}


+(instancetype)successScreenWithMessage:(NSString*)messageKey
{
	return [self screenWithMessage:messageKey
							 image:@"GreenTick"];
}

+(instancetype)failScreenWithMessage:(NSString *)messageKey
{
	return [self screenWithMessage:messageKey
							 image:@"RedCross"];
}

+(instancetype)screenWithMessage:(NSString *)messageKey
						   image:(NSString *)imageName
{
	CustomInfoViewController *customInfo = [[CustomInfoViewController alloc] init];
	customInfo.infoText = NSLocalizedString(messageKey, nil);
	customInfo.actionButtonTitles = @[NSLocalizedString(@"button.title.ok", nil)];
	customInfo.infoImage = [UIImage imageNamed:imageName];
	customInfo.mapCloseButtonToActionIndex = 1;
	
	return customInfo;
}
@end
