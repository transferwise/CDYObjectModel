//
//  DataEntryMultiColumnViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissKeyboardViewController.h"

/**
 *  UIViewController for data entry in the Transferwise app
 *
 *  The view controller can have one or more tableviews associated with it through the tableViews array. For each tableview an array of section cell arrays must be provided in the sectionCellsByTableView property.
 *  Each section cell array represents a section in the corresponding tableview by index and should consist of configured cells ready for use in the tableview.
 *
 * Below is an attempt at visually describing the sectionCellsByTableView structure for two tableviews, one with 2 sections with 2 and 3 cells and one with one section with one cell.
 *
 *  Table     Section    Cell
 * --------------------------
 *
 *  0---------0-------- Cell1
 *   |         |------- Cell2
 *   |
 *   |--------1-------- Cell3
 *             |------- Cell4
 *             |------- Cell5
 *
 *  1---------0-------- Cell6
 *             |------- Cell7
 *
 *
 */
@interface DataEntryMultiColumnViewController : DismissKeyboardViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

/**
 *  use this property to keep track of the tableviews associated with the viewcontroller.
 */
@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray* tableViews;

/**
 *  set this property to an NSArray containing NSArrays of sections containing NSArrays of UITableViewCells. 
 *
 * The root NSArray must have as many elemts as there are associated tableviews @see tableViews
 */
@property (nonatomic, strong) NSArray *sectionCellsByTableView;


// iPad
/**
 *  scrollview for containing tableviews as columns
 */
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstColumnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnLeftEdgeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstColumnLeftMargin;

/**
 * signifies that constraints should be tightened to fit on screen with tab bar
 */
@property (nonatomic) BOOL showInsideTabControllerForIpad;

/**
 *  convenience method for quickly checking if the viewcontrller has more than on tableview associated with it.
 *
 *  @return YES if more than one tableview is associated, NO if 1 or 0 tableviews are associated.
 */
-(BOOL)hasMoreThanOneTableView;

/**
 *  method to override to capture taps on cells. Default implementation does nothing
 *
 *  @param indexPath indexpath of cell tapped
 *  @param tableView tableview containinig the cell.
 */
- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView;

/**
 *  called when the user finishes entry in a textfield on a cell
 *
 *  override to insert custom validation of textfields. Default implementation does nothing
 */
- (void)textFieldEntryFinished;

/**
 *  Called when keyboard will show
 *
 *  override to customise behaviour. The default implementation only handles the case when only one tableview is associated.
 *
 *  @param note @see UIKeyboardWillShowNotification
 */
-(void)keyboardWillShow:(NSNotification*)note; // Only handles single tables. Ovverride for iPad

/**
 * Called when keyboard will hide
 *
 *  override to customise behaviour. The default implementation only handles the case when only one tableview is associated.
 *
 *  @param note @see UIKeyboardWillHideNotification
 */
-(void)keyboardWillHide:(NSNotification*)note; // Only handles single tables. Ovverride for iPad

/**
 *  This property is a convenient place to store the default content offset of a view before adjusting it for the keyboard..
 */
@property (nonatomic, assign) UIEdgeInsets cachedInsets;

/**
 *  called when the user moves to a new cell with the next key on the keyboard.
 *
 *  override to customize behaviour. The default implementation only handles the case when only one tableview is associated.
 *
 *  @param cell      cell that has been selected
 *  @param tableView tableview the cell resides in.
 */
-(void)scrollToCell:(UITableViewCell*)cell inTableView:(UITableView*)tableView;


/**
 *	Call to reaload all tableviews when @see sectionCellsByTableView has been modified
 */
-(void)reloadTableViews;

/**
 *  override to add orientation change customisations.
 *
 *  default implementation handles laying out constraints for two columns on iPad.
 *
 *  @param orientation target orientation
 */
-(void)configureForInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  helper method for finding the UITableViewCell a view is the subview of.
 *
 *  @param view subview of a UITableViewCell
 *
 *  @return The parent UITableViewCell
 */
- (UITableViewCell *)getParentCell:(UIView *)view;

/**
 *	can be used to trigger movement to next editable cell
 *
 *	@param cell cell to move away from
 *
 *  @return BOOL to signal that the move should happen
 */
- (BOOL)moveFocusOnNextEntryAfterCell:(UITableViewCell *)cell;

@end
