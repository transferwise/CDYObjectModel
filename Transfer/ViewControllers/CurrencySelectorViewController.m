//
//  CurrencySelectorViewController.m
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CurrencySelectorViewController.h"
#import "CurrencyCell.h"
#import "Constants.h"
#import "UIColor+MOMStyle.h"

@interface CurrencySelectorViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray* maskedCells;

@end

@implementation CurrencySelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *cellNib = [UINib nibWithNibName:@"CurrencyCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CurrencyCell"];
    
    self.titleLabel.text = NSLocalizedString(@"currency.selector.title", nil);
    [self.selectButton setTitle:NSLocalizedString(@"currency.selector.select.button.title",nil) forState:UIControlStateNormal];
	[self.selectButton setTitleColor:[UIColor colorFromStyle:@"highlightblue"] forState:UIControlStateHighlighted];
	
	UITapGestureRecognizer *recognizer =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(highlightViewTapped)];
	recognizer.numberOfTapsRequired = 1;
	[self.view addGestureRecognizer:recognizer];
}

-(void)viewDidLayoutSubviews
{
    self.collectionView.contentInset = UIEdgeInsetsMake(self.highlightView.frame.origin.y - self.collectionView.frame.origin.y, 0, self.view.frame.size.height - self.highlightView.frame.origin.y - self.highlightView.frame.size.height, 0);
    if(self.selectedIndex == NSNotFound)
    {
        self.selectedIndex = 0;
    }
    self.collectionView.contentOffset = [self calculateOffsetForCellAtIndex:self.selectedIndex];
	[self maskCenterCells];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Mask the selected cell
        [self maskCenterCells];
    });
    [self.view layoutSubviews];
    [super viewDidLayoutSubviews];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.currencyArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyCell* cell = (CurrencyCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"CurrencyCell" forIndexPath:indexPath];
    [cell configureWithCurrency:self.currencyArray[indexPath.row]];
    cell.viewToMask.hidden = YES;
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView setContentOffset:[self calculateOffsetForCellAtIndex:indexPath.row] animated:YES];
}

//nasty bit of code to recalculate cell sizes on orientation changes, there is a better way with autolayout, I am sure.
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	float height = 44.f;
	
	if(IPAD)
	{
		//ipad, landscape
		if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
			return CGSizeMake(1024.f, height);
		}
		//ipad protrait
		return CGSizeMake(768.f, height);
	}
	
	//iphone, protrait
    return CGSizeMake(320.f, height);
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[[self.collectionView collectionViewLayout] invalidateLayout];
}

#pragma mark - UIScrollViewDelegate
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self maskCenterCells];
}

-(void)maskCenterCells
{
    NSMutableArray *cellsToMask = [NSMutableArray arrayWithCapacity:2];
    CGRect maskFrame = self.highlightView.frame;
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:[self.view convertPoint:maskFrame.origin toView:self.collectionView]];
	if (indexPath)
    {
		CurrencyCell* cell = (CurrencyCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        if(cell)
        {
            [cellsToMask addObject:cell];
        }
    }
    CGPoint bottomOfMask = maskFrame.origin;
    bottomOfMask.y += maskFrame.size.height;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.view convertPoint:bottomOfMask toView:self.collectionView]];
    if (indexPath)
    {
        CurrencyCell* cell = (CurrencyCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        if(cell)
        {
            [cellsToMask addObject:cell];
        }
    }
    [self maskCells:cellsToMask];
}

-(void)maskCells:(NSArray*)cells
{
    for (CurrencyCell *cell in cells) {
        cell.viewToMask.hidden = NO;
        [self maskCell:cell];
        [self.maskedCells removeObject:cell];
    }
    
    for (CurrencyCell *cell in self.maskedCells) {
        cell.viewToMask.hidden = YES;
    }
    
    self.maskedCells = [cells mutableCopy];
}

-(void)maskCell:(CurrencyCell*)cell
{
    CGRect maskFrame = self.highlightView.frame;
    CGRect convertedMaskFrame = [self.view convertRect:maskFrame toView:cell.viewToMask];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = convertedMaskFrame;
    
    // Create a path with the rectangle in it.
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    
    // Set the path to the mask layer.
    maskLayer.path = path;
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    
    // Set the mask of the view.
    cell.viewToMask.layer.mask = maskLayer;
}

-(void)calculateSelectedIndex
{
    self.selectedIndex = [self.collectionView indexPathForItemAtPoint:[self.view convertPoint:self.highlightView.center toView:self.collectionView]].row;
}

-(void)highlightViewTapped
{
	[self calculateSelectedIndex];
	[self select];
}

-(CGPoint)calculateOffsetForCellAtIndex:(NSUInteger)index
{
    CGFloat cellHeight =((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.height;
    return CGPointMake(0, index * cellHeight - self.collectionView.contentInset.top);
}

- (IBAction)closeTapped:(id)sender {
    [self dismiss];
}

- (void)select
{
	[self dismiss];
    if([self.delegate respondsToSelector:@selector(currencySelector:didSelectCurrencyAtIndex:)])
    {
        [self.delegate currencySelector:self didSelectCurrencyAtIndex:self.selectedIndex];
    }
}

- (IBAction)selectTapped:(id)sender {
    [self select];
}

-(void)presentOnViewController:(UIViewController *)hostViewcontroller
{
    if([self.delegate respondsToSelector:@selector(currencySelectorwillShow:)])
    {
        [self.delegate currencySelectorwillShow:self];
    }
    [super presentOnViewController:hostViewcontroller];
}

-(void)dismiss
{
    if([self.delegate respondsToSelector:@selector(currencySelectorwillHide:)])
    {
        [self.delegate currencySelectorwillHide:self];
    }
    [super dismiss];
}

-(void)setSelectedCurrency:(Currency*)selectedCurrency
{
    self.selectedIndex = [self.currencyArray indexOfObject:selectedCurrency];
}

@end
