//
//  TabViewController.m
//  Transfer
//
//  Created by Mats Trovik on 19/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabViewController.h"

@implementation TabItem

@end

@interface TabViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tabBarCollectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *tabItems;
@property (weak, nonatomic) TabItem *selectedItem;
@property (assign, nonatomic)CGSize tabSize;
@property (assign, nonatomic)CGSize lastTabSize;

@end

@implementation TabViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UINib* nib = [UINib nibWithNibName:@"TabCell" bundle:[NSBundle mainBundle]];
    [self.tabBarCollectionView registerNib:nib forCellWithReuseIdentifier:@"TabCell"];
    [self selectItem:self.selectedItem];
}

-(void)viewDidLayoutSubviews
{
    [self layoutTabs];
    [super viewDidLayoutSubviews];
}

-(NSMutableArray *)tabItems
{
    if(!_tabItems)
    {
        _tabItems = [NSMutableArray array];
    }
    return _tabItems;
}

-(void)addItem:(TabItem*)newItem
{
    [self.tabItems addObject:newItem];
    [self setItems:self.tabItems];
}

-(void)setItems:(NSArray*)items
{
    self.tabItems = [items mutableCopy];
    [self layoutTabs];
}

-(void)selectItem:(TabItem *)newSelectedItem
{
    
    BOOL shouldSelect = YES;
    if(newSelectedItem)
    {
        if(newSelectedItem.actionBlock)
        {
            shouldSelect = newSelectedItem.actionBlock(newSelectedItem);
        }
    }
    
    if(shouldSelect)
    {
        if(newSelectedItem.viewController)
        {
            [self.selectedItem.viewController.view removeFromSuperview];
            [self.selectedItem.viewController removeFromParentViewController];
            [newSelectedItem.viewController willMoveToParentViewController:self];
            [self.containerView addSubview:newSelectedItem.viewController.view];
            newSelectedItem.viewController.view.frame = self.containerView.bounds;
            [self addChildViewController:newSelectedItem.viewController];
        }
        
        [self setCellSelectedState:NO forItem:self.selectedItem];
        [self setCellSelectedState:YES forItem:newSelectedItem];
        
        self.selectedItem = newSelectedItem;
    }
}

-(void)selectIndex:(NSUInteger)index
{
    if(index >= [self.tabItems count])
        return;
    [self selectItem:self.tabItems[index]];
    
}

-(void)setCellSelectedState:(BOOL)selected forItem:(TabItem*)item
{
    NSUInteger index = [self.tabItems indexOfObject:item];
    if(index!=NSNotFound)
    {
        TabCell *cell = (TabCell*) [self.tabBarCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell configureForSelectedState:selected];
    }
}

-(void)layoutTabs
{
    if(self.tabItems.count > 0)
    {
        UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.tabBarCollectionView.collectionViewLayout;
        if(layout.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            CGFloat height = self.tabBarCollectionView.frame.size.height / [self.tabItems count];
            self.tabSize = CGSizeMake(self.tabBarCollectionView.frame.size.width, roundf(height));
            self.lastTabSize = CGSizeMake(self.tabSize.width, self.tabSize.height + [self roundingAdjustmentforDimension:height]);
        }
        else
        {
            CGFloat width = self.tabBarCollectionView.frame.size.width / [self.tabItems count];
            self.tabSize = CGSizeMake(roundf(width), self.tabBarCollectionView.frame.size.height);
            self.lastTabSize = CGSizeMake(self.tabSize.width + [self roundingAdjustmentforDimension:width], self.tabSize.height);
        }
        
        [layout invalidateLayout];
        
        if([self.tabItems indexOfObject:self.selectedItem] == NSNotFound && [self.tabItems count] > 0)
        {
            self.selectedItem = self.tabItems[0];
        }
    }
}

-(CGFloat)roundingAdjustmentforDimension:(CGFloat)dimension
{
    CGFloat difference = dimension - roundf(dimension);
    if(difference < 0)
    {
        return -1.0f;
    }
    else if (difference > 0)
    {
        return 1.0f;
    }
    
    return 0.0f;
}

#pragma mark - Collection View Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tabItems count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TabCell *cell = (TabCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"TabCell" forIndexPath:indexPath];
    TabItem* item = self.tabItems[indexPath.row];
    [cell configureWithTabItem:item];
    if(item == self.selectedItem)
    {
        [cell configureForSelectedState:YES];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectIndex:indexPath.row];
}

#pragma mark - Collection View Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tabItems count]-1)
    {
        return self.lastTabSize;
    }
    return self.tabSize;
}

@end
