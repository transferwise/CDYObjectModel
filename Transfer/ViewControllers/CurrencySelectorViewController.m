//
//  CurrencySelectorViewController.m
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CurrencySelectorViewController.h"
#import "CurrencyCell.h"

@interface CurrencySelectorViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation CurrencySelectorViewController

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
    UINib *cellNib = [UINib nibWithNibName:@"CurrencyCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CurrencyCell"];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.contentInset = UIEdgeInsetsMake(self.highlightView.frame.origin.y - self.collectionView.frame.origin.y, 0, self.view.frame.size.height - self.highlightView.frame.origin.y - self.highlightView.frame.size.height, 0);
    if(self.selectedIndex == NSNotFound)
    {
        self.selectedIndex = 0;
    }
    self.collectionView.contentOffset = [self calculateOffsetForCellAtIndex:self.selectedIndex];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.currencyArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyCell* cell = (CurrencyCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"CurrencyCell" forIndexPath:indexPath];
    [cell configureWithCurrency:self.currencyArray[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView setContentOffset:[self calculateOffsetForCellAtIndex:indexPath.row] animated:YES];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //Page to cells
    CGFloat targetY = targetContentOffset->y + self.collectionView.contentInset.top;
    CGFloat cellHeight =((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.height;
    CGFloat cellIndex = roundf(targetY/cellHeight);
    targetY = cellIndex * cellHeight;
    targetContentOffset->y = targetY - self.collectionView.contentInset.top;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self calculateSelectedIndex];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self calculateSelectedIndex];
}

-(void)calculateSelectedIndex
{
    self.selectedIndex = [self.collectionView indexPathForItemAtPoint:[self.view convertPoint:self.highlightView.center toView:self.collectionView]].row;
}

-(CGPoint)calculateOffsetForCellAtIndex:(NSUInteger)index
{
    CGFloat cellHeight =((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.height;
    return CGPointMake(0, index * cellHeight - self.collectionView.contentInset.top);
}

- (IBAction)closeTapped:(id)sender {
    [self dismiss];
}

- (IBAction)selectTapped:(id)sender {
    [self dismiss];
    [self.delegate currencySelector:self didSelectCurrencyAtIndex:self.selectedIndex];
}

-(void)presentOnViewController:(UIViewController*)hostViewcontroller
{
    [self willMoveToParentViewController:hostViewcontroller];
    [hostViewcontroller.view addSubview:self.view];
    CGRect newFrame = hostViewcontroller.view.bounds;
    newFrame.origin.y = newFrame.size.height;
    self.view.frame = newFrame;
    [hostViewcontroller addChildViewController:self];
    [self didMoveToParentViewController:hostViewcontroller];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = hostViewcontroller.view.bounds;
    } completion:nil];
    
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect newFrame = self.view.bounds;
        newFrame.origin.y = newFrame.size.height;
        self.view.frame = newFrame;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

-(void)setSelectedCurrency:(Currency*)selectedCurrency
{
    self.selectedIndex = [self.currencyArray indexOfObject:selectedCurrency];
}

@end
