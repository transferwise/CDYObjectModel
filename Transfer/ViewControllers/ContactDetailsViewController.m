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
#import "UIView+RenderBlur.h"
#import "UIImage+RenderBlur.h"

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
    //TODO: m@s replace with loading user image once API is implemented.
    self.userImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"User%d",arc4random()%3]];
    [self.userImage blurInBackgroundWithCompletionBlock:^(UIImage * blurry) {
        __weak typeof(self) weakSelf = self;
        CGSize blurSize = blurry.size;
        CGSize wantedSize = weakSelf.headerBackground.frame.size;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          
            //Crop blurred image
            NSUInteger scale = [UIScreen mainScreen].scale;
            CGRect rect = CGRectMake((blurSize.width/2.0 - wantedSize.width/8)*scale,
                                     (blurSize.height/2.0 - wantedSize.height/8)*scale,
                                     wantedSize.width/4*scale,
                                     wantedSize.height/4*scale);
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([blurry CGImage], rect);
            UIImage *croppedBlur = [UIImage imageWithCGImage:imageRef
                                                  scale:scale
                                            orientation:blurry.imageOrientation];
            CGImageRelease(imageRef);
            
            //Scale it up
            
            UIGraphicsBeginImageContextWithOptions(wantedSize, NO, 0.0);
            [croppedBlur drawInRect:CGRectMake(0, 0, wantedSize.width, wantedSize.height)];
            UIImage *scaledup = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            
            //Blur again
            [UIImage blurImageInBackground:scaledup withRadius:10 iterations:4 tintColor:nil withCompletionBlock:^(UIImage *result) {
                self.headerBackground.alpha = 0.0f;
                self.headerBackground.image = result;
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.headerBackground.alpha = 0.2f;
                } completion:nil];
            }];
            
        });
    }];
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
