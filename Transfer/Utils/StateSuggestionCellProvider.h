//
//  StateSuggestionProvider.h
//  Transfer
//
//  Created by Mats Trovik on 26/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionCellProvider.h"
#import "SelectionCell.h"

//TODO: remove when state is available from api
@interface State : NSObject<SelectionItem>

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@end

@interface StateSuggestionCellProvider : SuggestionCellProvider

- (State *)getByCodeOrName:(NSString*)codeOrName;

@end
