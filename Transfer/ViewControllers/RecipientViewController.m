//
//  RecipientViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientViewController.h"
#import "UIColor+Theme.h"
#import "TRWProgressHUD.h"
#import "TransferwiseOperation.h"
#import "CurrenciesOperation.h"
#import "RecipientTypesOperation.h"
#import "TextEntryCell.h"
#import "CurrencySelectionCell.h"
#import "Constants.h"
#import "Currency.h"
#import "RecipientType.h"
#import "RecipientTypeField.h"
#import "RecipientFieldCell.h"

static NSUInteger const kRecipientFieldsSection = 2;

@interface RecipientViewController ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) TextEntryCell *nameCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@end

@implementation RecipientViewController

- (id)init {
    self = [super initWithNibName:@"RecipientViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];

    NSMutableArray *recipientCells = [NSMutableArray array];

    TextEntryCell *nameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [recipientCells addObject:nameCell];

    [self setRecipientCells:recipientCells];

    NSMutableArray *currencyCells = [NSMutableArray array];

    CurrencySelectionCell *currencyCell = [self.tableView dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [self handleCurrencySelection:currency];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

    CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
    [self setExecutedOperation:currenciesOperation];
    [currenciesOperation setResultHandler:^(NSArray *currencies, NSError *error) {
        if (error) {
            [hud hide];
            return;
        }

        RecipientTypesOperation *operation = [RecipientTypesOperation operation];
        [self setExecutedOperation:operation];

        [operation setResultHandler:^(NSArray *recipients, NSError *typesError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];

                if (typesError) {
                    return;
                }

                [self.currencyCell setAllCurrencies:currencies];
                [self setRecipientTypes:recipients];

                [self setPresentedSectionCells:@[self.recipientCells, self.currencyCells, @[]]];
                [self.tableView reloadData];
            });
        }];

        [operation execute];
    }];

    [currenciesOperation execute];
}

- (void)handleCurrencySelection:(Currency *)currency {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did select currency:%@. Default type:%@", currency, currency.defaultRecipientType);

        RecipientType *type = [self findTypeWithCode:currency.defaultRecipientType];
        MCLog(@"Have %d fields", [type.fields count]);

        NSArray *cells = [self buildCellsForType:type];
        [self setRecipientTypeFieldCells:cells];
        [self setPresentedSectionCells:@[self.recipientCells, self.currencyCells, cells]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kRecipientFieldsSection] withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (NSArray *)buildCellsForType:(RecipientType *)type {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[type.fields count]];
    for (RecipientTypeField *field in type.fields) {
        RecipientFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
        [cell setFieldType:field];
        [result addObject:cell];
    }
    return [NSArray arrayWithArray:result];
}

- (RecipientType *)findTypeWithCode:(NSString *)typeString {
    for (RecipientType *type in self.recipientTypes) {
        if (![typeString isEqualToString:type.type]) {
            continue;
        }

        return type;
    }
    return nil;
}

@end
