//
//  AddressBookSuggestionTable.h
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldSuggestionTable;

@protocol SuggestionTableDelegate <NSObject>

@optional
-(void)suggestionTableDidStartEditing:(TextFieldSuggestionTable*)table;
-(void)suggestionTableDidEndEditing:(TextFieldSuggestionTable*)table;
-(void)suggestionTable:(TextFieldSuggestionTable*)table selectedObject:(id)object;

@end

@protocol SuggestionTableCellProvider <UITableViewDataSource>

@required
-(void)filterForText:(NSString*)text completionBlock:(void(^)(BOOL contentDidChange))completionBlock;

@optional
-(id)objectForIndexPath:(NSIndexPath*)indexPath;
@end

@interface TextFieldSuggestionTable : UITableView

@property (nonatomic,weak) id<SuggestionTableDelegate> suggestionTableDelegate;
@property (nonatomic, weak) id<SuggestionTableCellProvider> dataSource;
@property (nonatomic, strong) UITextField *textField;
@end
