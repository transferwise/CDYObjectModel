//
//  TabViewController.m
//  Transfer
//
//  Created by Mats Trovik on 19/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *tabItems;
@property (weak, nonatomic) TabItem *selectedItem;
@property (assign, nonatomic)CGSize tabSize;
@property (assign, nonatomic)CGSize lastTabSize;
@property (assign, nonatomic)CGSize gapSize;

@end

@implementation TabViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UINib* nib = [UINib nibWithNibName:@"TabCell" bundle:[NSBundle mainBundle]];
    [self.tabBarCollectionView registerNib:nib forCellWithReuseIdentifier:@"TabCell"];
    [self.tabBarCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Space"];
    [self selectItem:self.selectedItem];
}

-(void)viewDidLayoutSubviews
{
    [self layoutTabs];
    [super viewDidLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarCollectionView.contentInset = self.tabBarInsets;
}

-(NSInteger)insertFlexibleSpaceAtIndex
{
	if (self.centerVertically)
	{
		return _insertFlexibleSpaceAtIndex + 1;
	}
	else
	{
		return _insertFlexibleSpaceAtIndex;
	}
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
    [self applyDefaultColors];
    [self layoutTabs];
}

-(void)applyDefaultColors
{
    for(TabItem* item in self.tabItems)
    {
        item.selectedColor = item.selectedColor?:self.defaultSelectedColor;
        item.deSelectedColor = item.deSelectedColor?:self.defaultDeSelectedColor;
        item.highlightedColor = item.highlightedColor?:self.defaultHighlightedColor;
    }
}

-(void)setDefaultDeSelectedColor:(UIColor *)defaultDeSelectedColor
{
    if(_defaultDeSelectedColor != defaultDeSelectedColor)
    {
        _defaultDeSelectedColor = defaultDeSelectedColor;
        [self applyDefaultColors];
    }
}

-(void)setDefaultSelectedColor:(UIColor *)defaultSelectedColor
{
    if(_defaultSelectedColor != defaultSelectedColor)
    {
        _defaultSelectedColor = defaultSelectedColor;
        [self applyDefaultColors];
    }
}

-(void)setDefaultHighlightedColor:(UIColor *)defaultHighlightedColor
{
    if(_defaultHighlightedColor != defaultHighlightedColor)
    {
        _defaultHighlightedColor = defaultHighlightedColor;
        [self applyDefaultColors];
    }
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
            [self addChildViewController:newSelectedItem.viewController];
            [newSelectedItem.viewController didMoveToParentViewController:self];
            [self.containerView addSubview:newSelectedItem.viewController.view];
            newSelectedItem.viewController.view.frame = self.containerView.bounds;
            newSelectedItem.viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            self.navigationItem.title = newSelectedItem.viewController.title;
            self.navigationItem.rightBarButtonItems = newSelectedItem.viewController.navigationItem.rightBarButtonItems;
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
		NSIndexPath *indexPath = [self indexPathForIndex:index];
		
        TabCell *cell = (TabCell*) [self.tabBarCollectionView cellForItemAtIndexPath:indexPath];
        [cell configureForSelectedState:selected];
    }
}

-(void)layoutTabs
{
    if(self.tabItems.count > 0)
    {
        UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.tabBarCollectionView.collectionViewLayout;

        if([self useFixedSizeTabs])
        {
            if(layout.scrollDirection == UICollectionViewScrollDirectionVertical)
            {
                CGFloat height = self.tabBarCollectionView.frame.size.height  - self.tabBarCollectionView.contentInset.top - self.tabBarCollectionView.contentInset.bottom - [self.tabItems count] * self.fixedSize.height;
                self.gapSize = CGSizeMake(self.tabBarCollectionView.frame.size.width, self.centerVertically ? height / 2 : height);
                
            }
            else
            {
                CGFloat width = self.tabBarCollectionView.frame.size.width - self.tabBarCollectionView.contentInset.left - self.tabBarCollectionView.contentInset.right - [self.tabItems count] * self.fixedSize.width;
                
                self.gapSize = CGSizeMake(width, self.tabBarCollectionView.frame.size.height);
            }
        }
        else
        {
            if(layout.scrollDirection == UICollectionViewScrollDirectionVertical)
            {
                CGFloat height = (self.tabBarCollectionView.frame.size.height - self.tabBarCollectionView.contentInset.top - self.tabBarCollectionView.contentInset.bottom) / [self.tabItems count];
                self.tabSize = CGSizeMake(self.tabBarCollectionView.frame.size.width, roundf(height));
                self.lastTabSize = CGSizeMake(self.tabSize.width, self.tabSize.height + [self roundingAdjustmentforDimension:height]);
            }
            else
            {
                CGFloat width = (self.tabBarCollectionView.frame.size.width - self.tabBarCollectionView.contentInset.left - self.tabBarCollectionView.contentInset.right) / [self.tabItems count];
                self.tabSize = CGSizeMake(roundf(width), self.tabBarCollectionView.frame.size.height);
                self.lastTabSize = CGSizeMake(self.tabSize.width + [self roundingAdjustmentforDimension:width], self.tabSize.height);
            }
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
	if(self.centerVertically)
	{
		if([self useFixedSizeTabs])
		{
			return [self.tabItems count] + 2;
		}
		else
		{
			return [self.tabItems count] + 1;
		}
	}
	else if([self useFixedSizeTabs])
	{
		return [self.tabItems count] + 1;
	}
	else
	{
		return [self.tabItems count];
	}
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.centerVertically && indexPath.row == 0)
	{
		UICollectionViewCell *spacerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Space" forIndexPath:indexPath];
        return spacerCell;
	}
    else if ([self useFixedSizeTabs] && indexPath.row == self.insertFlexibleSpaceAtIndex)
    {
        UICollectionViewCell *spacerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Space" forIndexPath:indexPath];
        return spacerCell;
    }
	
    TabCell *cell = (TabCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"TabCell" forIndexPath:indexPath];
	NSLog(@"%li", (long)indexPath.row);
    TabItem* item = self.tabItems[[self indexForIndexPath:indexPath]];
    [cell configureWithTabItem:item];
    if(item == self.selectedItem)
    {
        [cell configureForSelectedState:YES];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.tabBarCollectionView cellForItemAtIndexPath:indexPath];
    if([cell isKindOfClass:[TabCell class]])
    {
        [self selectIndex:[self indexForIndexPath:indexPath]];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.tabBarCollectionView cellForItemAtIndexPath:indexPath];
    if([cell isKindOfClass:[TabCell class]])
    {
        [((TabCell*)cell) configureForHighlightedState];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.tabBarCollectionView cellForItemAtIndexPath:indexPath];
    if([cell isKindOfClass:[TabCell class]])
    {
        TabItem* item = self.tabItems[[self indexForIndexPath:indexPath]];
        if(item == self.selectedItem)
        {
            [((TabCell*)cell) configureForSelectedState:YES];
        }
        else
        {
            [((TabCell*)cell) configureForSelectedState:NO];
        }
    }
}

#pragma mark - Collection View Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self useFixedSizeTabs])
    {
		if (self.centerVertically && indexPath.row == 0)
		{
			return CGSizeMake(self.gapSize.width, self.gapSize.height + [self getCenteringInset]);
		}
        else if (indexPath.row == self.insertFlexibleSpaceAtIndex)
        {
            return CGSizeMake(self.gapSize.width, self.gapSize.height - [self getCenteringInset]);
        }
		
        return self.fixedSize;
    }
    else
    {
        if (indexPath.row == [self.tabItems count] - 1)
        {
            return self.lastTabSize;
        }
		
        return self.tabSize;
    }
}

#pragma mark indexpath conversion
- (CGFloat)getCenteringInset
{
	return (self.fixedSize.height / 2 - self.tabBarInsets.top / 2) + 10;
}

- (NSIndexPath*)indexPathForIndex:(NSUInteger)index
{
	if (self.centerVertically)
	{
		if([self useFixedSizeTabs] && index >= self.insertFlexibleSpaceAtIndex - 1)
		{
			return [NSIndexPath indexPathForRow:index + 2 inSection:0];
		}
		else
		{
			return [NSIndexPath indexPathForRow:index + 1 inSection:0];
		}
	}
	else
	{
		if([self useFixedSizeTabs] && index >= self.insertFlexibleSpaceAtIndex - 1)
		{
			return [NSIndexPath indexPathForRow:index + 1 inSection:0];
		}
		else
		{
			return [NSIndexPath indexPathForRow:index inSection:0];
		}
	}
}

- (NSUInteger)indexForIndexPath:(NSIndexPath*)indexPath
{
	if (self.centerVertically)
	{
		if ([self useFixedSizeTabs]  && indexPath.row >= self.insertFlexibleSpaceAtIndex)
		{
			return indexPath.row - 2;
		}
		else
		{
			return indexPath.row - 1;
		}
	}
	else
	{
		if ([self useFixedSizeTabs]  && indexPath.row >= self.insertFlexibleSpaceAtIndex)
		{
			return indexPath.row - 1;
		}
		else
		{
			return indexPath.row;
		}
	}
}

-(BOOL)useFixedSizeTabs
{
    return (self.fixedSize.width > 0 || self.fixedSize.height > 0);
}

@end
