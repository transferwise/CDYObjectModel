//
//  DataEntryMultiColumnViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryMultiColumnViewController.h"
#import "TextEntryCell.h"
#import "UIView+Container.h"
#import "Constants.h"
#import "DataEntryDefaultHeader.h"
#import "UIResponder+FirstResponder.h"
#import "MOMStyle.h"
#import "MultipleEntryCell.h"
#import "TRWProgressHUD.h"

#define kInsetsNotSet UIEdgeInsetsMake(-1, -1, -1, -1)

@interface DataEntryMultiColumnViewController() <MultipleEntryCellDelegate>

@property (nonatomic, assign) BOOL keyboardIsVisible;
@property (nonatomic, weak) UITapGestureRecognizer* dismissKeyboardTaprecognizer;
@property (nonatomic, strong) TRWProgressHUD *hud;

@end

@implementation DataEntryMultiColumnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willReload)
												 name:TRWWillUpdateBaseDataNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReload)
												 name:TRWDidUpdateBaseDataNotification
											   object:nil];
    
    self.cachedInsets = kInsetsNotSet;
    
    for(UITableView* tableView in self.tableViews)
    {
        tableView.bgStyle = @"white";
        tableView.tableFooterView = [[UIView alloc] init];
    }
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [self configureForInterfaceOrientation:parent.interfaceOrientation];
}

- (void)setSectionCellsByTableView:(NSArray *)sectionCellsByTableView
{
    _sectionCellsByTableView = sectionCellsByTableView;
    
    for(NSArray* tableViewSections in sectionCellsByTableView)
    {
        for (NSArray *sectionCells in tableViewSections) {
            for (id cell in sectionCells) {
                
                if (![self isEntryCell:cell]) {
                    continue;
                }
                
                TextEntryCell *entryCell = cell;
                [entryCell.entryField setDelegate:self];
                [entryCell.entryField setReturnKeyType:UIReturnKeyNext];
            }
        }
    }
    
    UITableViewCell *lastCell = [[[sectionCellsByTableView lastObject] lastObject] lastObject];
    if ([self isEntryCell:lastCell]) {
        TextEntryCell *entryCell = (TextEntryCell *) lastCell;
        [entryCell.entryField setReturnKeyType:UIReturnKeyDone];
    }
}

- (void)navigateAwayFrom:(UITableViewCell *)cell
{
	[self textFieldEntryFinished];
	[self moveFocusOnNextEntryAfterCell:cell];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    return [self.sectionCellsByTableView[index] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    NSArray *sectionCells = self.sectionCellsByTableView[index][(NSUInteger) section];
    return [sectionCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    UITableViewCell *cell = self.sectionCellsByTableView[index][indexPath.section][indexPath.row];
	
	if([cell isKindOfClass:[MultipleEntryCell class]])
	{
		((MultipleEntryCell *)cell).multipleEntryDelegate = self;
	}
	
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    UITableViewCell *cell = self.sectionCellsByTableView[index][indexPath.section][indexPath.row];
    return CGRectGetHeight(cell.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString* title = [self tableView:tableView titleForHeaderInSection:section];
    if(title)
    {
        return IPAD?75.0f:60.0f;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title = [self tableView:tableView titleForHeaderInSection:section];
    if(title)
    {
        DataEntryDefaultHeader* header = [DataEntryDefaultHeader instance];
        header.titleLabel.text = title;
        return header;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self isEntryCell:cell])
	{
        TextEntryCell *entryCell = cell;
        [entryCell.entryField becomeFirstResponder];
    }
	else
	{
        [self tappedCellAtIndexPath:indexPath inTableView:tableView];
    }
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView
{
    MCLog(@"tappedCellAtIndexPath:%@", indexPath);
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *containingCell = [textField findContainerOfType:[UITableViewCell class]];
    
    BOOL moved = [self moveFocusOnNextEntryAfterCell:containingCell];
    
    if (!moved && [containingCell isKindOfClass:[TextEntryCell class]])
	{
        TextEntryCell *entryCell = (TextEntryCell *) containingCell;
        [entryCell.entryField resignFirstResponder];
    }
    
    [self textFieldEntryFinished];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	TextEntryCell *cell = [textField findContainerOfType:[TextEntryCell class]];
	[cell textFieldEntryFinished];
    [self textFieldEntryFinished];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    TextEntryCell *cell = [textField findContainerOfType:[TextEntryCell class]];
    return [cell textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)moveFocusOnNextEntryAfterCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    if (indexPath == nil)
	{
        return NO;
    }
	
	if ([cell isKindOfClass:[MultipleEntryCell class]] && ![(MultipleEntryCell *)cell shouldNavigateAway])
	{
		return NO;
	}
    
    if ([cell isKindOfClass:[TextEntryCell class]])
	{
        [(TextEntryCell *)cell markTouched];
    }
    
    NSUInteger tableViewIndex = [self indexOfTableViewContainingCell:cell];

	NSIndexPath *moveToIndexPath = indexPath;
    
    while (tableViewIndex != NSNotFound)
    {
        UITableView* tableView = self.tableViews[tableViewIndex];
        while ((moveToIndexPath = [self nextEditableIndexPathAfter:moveToIndexPath inTableViewWithIndex:tableViewIndex]) != nil)
		{
            UITableViewCell *viewCell = [self tableView:tableView cellForRowAtIndexPath:moveToIndexPath];
            if ([self isEntryCell:viewCell])
			{
                TextEntryCell *entryCell = (TextEntryCell *) viewCell;
				
				if([entryCell isKindOfClass:[MultipleEntryCell class]])
				{
					[(MultipleEntryCell *)entryCell activate];
				}
				else
				{
					[entryCell.entryField becomeFirstResponder];
				}
                return YES;
            }
        }
        moveToIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        tableViewIndex++;
        if(tableViewIndex >= [self.tableViews count])
        {
            tableViewIndex = NSNotFound;
        }

            
    }
    
    return NO;
}

- (NSIndexPath *)nextEditableIndexPathAfter:(NSIndexPath *)indexPath inTableViewWithIndex:(NSUInteger)tableViewIndex
{
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) MAX(0,indexPath.row);
    
    NSUInteger count = [self.sectionCellsByTableView[tableViewIndex] count];
    
    for (; section < count ; section++)
	{
        NSArray *sectionCells = self.sectionCellsByTableView[tableViewIndex][section];
        for (; row < [sectionCells count]; row++)
		{
            id cell = sectionCells[row];
            if (![self isEntryCell:cell])
			{
                continue;
            }
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            if ([path isEqual:indexPath])
			{
                continue;
            }
            
            TextEntryCell *entryCell = cell;
            if (!entryCell.editable)
			{
                continue;
            }
            
            return path;
        }
        
        row = 0;
    }
    
    return nil;
}

-(NSUInteger)indexOfTableViewContainingCell:(UITableViewCell *)cell
{
    for (NSArray *tableViewSectionIndex in self.sectionCellsByTableView)
    {
        for (NSUInteger section = 0; section < [tableViewSectionIndex count]; section++) {
            NSArray *sectionCells = tableViewSectionIndex[section];
            NSUInteger row = [sectionCells indexOfObject:cell];
            if (row != NSNotFound) {
                return [self.sectionCellsByTableView indexOfObject:tableViewSectionIndex];
            }
        }
    }
    
    return NSNotFound;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    
    for (NSArray *tableViewSectionIndex in self.sectionCellsByTableView)
    {
        for (NSUInteger section = 0; section < [tableViewSectionIndex count]; section++) {
            NSArray *sectionCells = tableViewSectionIndex[section];
            NSUInteger row = [sectionCells indexOfObject:cell];
            if (row != NSNotFound) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    
    return nil;
}

- (BOOL)isEntryCell:(UITableViewCell *)cell
{
    return [cell isKindOfClass:[TextEntryCell class]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.keyboardIsVisible)
    {
        UITableViewCell *cell = [self getParentCell:textField];
        if(cell)
        {
            [self scrollToCell:cell inTableView:self.tableViews[0] animated:YES];
        }
    }
    return YES;
}

- (void)textFieldEntryFinished
{
    
}


-(BOOL)hasMoreThanOneTableView
{
    return [self.tableViews count] > 1;
}

-(void)reloadTableViews
{
	for (UITableView* tableView in self.tableViews)
	{
		[tableView reloadData];
	}
}

//Objc kung-fu not strong enough to pass Class as an argument to isKindOfClass yet :(
- (UITableViewCell *)getParentCell:(UIView *)view
{
	UIView* superview = view.superview;
	
	while (superview && ![superview isKindOfClass:[UITableViewCell class]])
	{
		superview = superview.superview;
	}
    
    return (UITableViewCell*)superview;
}

#pragma mark - orientation changes

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self refreshTableViewSizes];
    [self configureForInterfaceOrientation:toInterfaceOrientation];
}


-(void)configureForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //Lots of magic numbers here to match designs. Not sure what to do...
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        self.firstColumnLeftMargin.constant = self.showInsideTabControllerForIpad ? 148.f : 194.f;
        self.secondColumnLeftEdgeConstraint.constant = -380.f;
        self.secondColumnTopConstraint.constant = self.firstColumnHeightConstraint.constant + 50.f;
        
    }
    else
    {
        self.firstColumnLeftMargin.constant = self.showInsideTabControllerForIpad ? 60.f : 80.f;
        self.secondColumnLeftEdgeConstraint.constant = self.showInsideTabControllerForIpad ? 60.f : 100.f;
        self.secondColumnTopConstraint.constant = 0.f;
    }
}

- (void)refreshTableViewSizes
{
    if([self hasMoreThanOneTableView])
    {
		self.firstColumnHeightConstraint.constant= ((UITableView*)self.tableViews[0]).contentSize.height;
        self.secondColumnHeightConstraint.constant =((UITableView*) self.tableViews[1]).contentSize.height;
        [self.tableViews[0] layoutIfNeeded];
        [self.tableViews[1] layoutIfNeeded];
		[self configureForInterfaceOrientation:self.interfaceOrientation];
    }
}

#pragma mark - keyboard overlap
-(void)keyboardWillShow:(NSNotification*)note
{
    if(self.suppressAnimation)
    {
        return;
    }
    CGRect newframe = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    newframe = [self.view.window convertRect:newframe toView:self.view];
    if([self hasMoreThanOneTableView])
    {
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        CGFloat overlap = self.containerScrollView.frame.origin.y + self.containerScrollView.frame.size.height - newframe.origin.y;
        
        if(overlap >0)
        {
         
            if(self.keyboardIsVisible)
            {
                //If the keyboard is already showing, only update the insets without animation.
                UIEdgeInsets newInsets = self.cachedInsets;
                newInsets.bottom += overlap;
                self.containerScrollView.contentInset = newInsets;
            }
            else
            {
            
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:duration];
                [UIView setAnimationCurve:curve];
                [UIView setAnimationBeginsFromCurrentState:YES];
                
                if(UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, kInsetsNotSet))
                {
                    self.cachedInsets = self.containerScrollView.contentInset;
                }
                
                UIEdgeInsets newInsets = self.cachedInsets;
                newInsets.bottom += overlap;
                self.containerScrollView.contentInset = newInsets;
                
                [UIView commitAnimations];
            }
            
            UIView *firstResponder = [UIResponder currentFirstResponder];
            if(firstResponder)
            {
                UITableViewCell *cell = [self getParentCell:firstResponder];
                if(cell)
                {
                    UITableView* tableView;
                    for(UITableView* table in self.tableViews)
                    {
                        if([table indexPathForCell:cell])
                        {
                            tableView = table;
                            break;
                        }
                        
                    }
                    //Scroll cell after the keyboard has animated
                    if(duration <= 0)
                    {
                        [self scrollToCell:cell inTableView:tableView animated:YES];
                    }
                    else
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self scrollToCell:cell inTableView:tableView animated:YES];
                        });
                    }
                }
                
            }
            
            if(!self.dismissKeyboardTaprecognizer)
            {
                UITapGestureRecognizer *dismissKeyboardTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
                dismissKeyboardTapRecogniser.numberOfTapsRequired = 1;
                [self.containerScrollView addGestureRecognizer:dismissKeyboardTapRecogniser];
                self.dismissKeyboardTaprecognizer = dismissKeyboardTapRecogniser;
            }
        }
    }
    else
    {
        UITableView* tableView = self.tableViews[0];
        
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        if(UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, kInsetsNotSet))
        {
            self.cachedInsets = tableView.contentInset;
        }
        
        CGFloat overlap = tableView.frame.origin.y + tableView.frame.size.height - newframe.origin.y;
        
        if(overlap >0)
        {
            if(self.keyboardIsVisible)
            {
                //If the keyboard is already showing, only update the insets.
                UIEdgeInsets newInsets = self.cachedInsets;
                newInsets.bottom += overlap;
                tableView.contentInset = newInsets;
            }
            else
            {
            
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:duration];
                [UIView setAnimationCurve:curve];
                [UIView setAnimationBeginsFromCurrentState:YES];
                
                UIEdgeInsets newInsets = self.cachedInsets;
                newInsets.bottom += overlap;
                tableView.contentInset = newInsets;
                
                [UIView commitAnimations];
            }
            
            UIView *firstResponder = [UIResponder currentFirstResponder];
            if(firstResponder)
            {
                UITableViewCell *cell = [self getParentCell:firstResponder];
                if(cell)
                {
                    if(duration <= 0)
                    {
                        [self scrollToCell:cell inTableView:tableView animated:YES];
                    }
                    else
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self scrollToCell:cell inTableView:tableView animated:YES];
                        });
                    }
                }
            }
        }
    }
    self.keyboardIsVisible = YES;
}

-(void)keyboardWillHide:(NSNotification*)note
{
    
    if(self.suppressAnimation)
    {
        return;
    }

    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if([self hasMoreThanOneTableView])
    {
        if(!UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, kInsetsNotSet))
        {
            self.containerScrollView.contentInset = self.cachedInsets;
        }
    }
    else
    {
        if(!UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, kInsetsNotSet))
        {
            UITableView* tableView = self.tableViews[0];
            tableView.contentInset = self.cachedInsets;
        }
    }
    [UIView commitAnimations];
    
    self.cachedInsets = kInsetsNotSet;
    self.keyboardIsVisible = NO;
}

-(void)scrollToCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView animated:(BOOL)animated
{
    if(self.suppressAnimation)
    {
        return;
    }
    if(IPAD)
    {
        [self scrollScrollViewToShowView:cell animated:animated];
    }
    else
    {
        NSIndexPath *path = [tableView indexPathForCell:cell];
        if(path)
        {
            [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animated];
        }
    }
}

-(void)scrollScrollViewToShowView:(UIView*)targetView animated:(BOOL)animated
{
    CGRect showRect = [self.containerScrollView convertRect:targetView.frame fromView:targetView.superview];
    showRect.size.height *= 2;
    [self.containerScrollView scrollRectToVisible:showRect animated:animated];
}

#pragma mark - dismiss keyboard

-(void)dismissKeyboard:(UITapGestureRecognizer*)recognizer
{
    [self.containerScrollView removeGestureRecognizer:recognizer];
    [self.view endEditing:YES];
}

#pragma mark - Reload Base Data
- (void)willReload
{
	if (self.reloadBaseData)
	{
		//show hud
		self.hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
		[self.hud setMessage:NSLocalizedString(@"generic.data.reloading", nil)];
	}
}

- (void)didReload
{
	if (self.reloadBaseData)
	{
		[self reload];
		[self.hud hide];
		self.hud = nil;
	}
}

- (void)reload
{
	//override in an inheriting class to cause base data reload
}

@end
