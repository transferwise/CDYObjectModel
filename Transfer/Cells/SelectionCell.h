//
//  CountrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

@class SelectionCell;

extern NSString *const TWSelectionCellIdentifier;

typedef void (^SelectionCellSelectionBlock)(NSString *name);

@protocol SelectionItem <NSObject>

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* code;

@end

@protocol SelectionCellDelegate <NSObject>

- (id<SelectionItem>)selectionCell:(SelectionCell*)cell getByCodeOrName:(NSString *)codeOrName;

@optional
-(void)selectionCell:(SelectionCell*)cell selectedItem:(id)item;

@end

@interface SelectionCell : TextEntryCell

@property (nonatomic, weak) id<SelectionCellDelegate> selectionDelegate;
@property (nonatomic, copy) SelectionCellSelectionBlock selectionHandler;

- (void)setCode:(NSString *)code;

@end
