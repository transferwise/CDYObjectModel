//
//  UpdateBusinessProfileOperation.m
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Users.h"
#import "Constants.h"
#import "BusinessProfile.h"

NSString *const kUpdateBusinessProfilePath = @"/user/updateBusinessProfile";
NSString *const kValidateBusinessProfilePath = @"/user/validateBusinessProfile";

@interface BusinessProfileOperation ()

@property (nonatomic, strong) NSManagedObjectID *data;
@property (nonatomic, copy) NSString *path;

@end

@implementation BusinessProfileOperation

- (id)initWithPath:(NSString *)path data:(NSManagedObjectID *)data {
    self = [super init];
    if (self) {
        _data = data;
        _path = path;
    }
    return self;
}

- (void)execute {
    MCAssert(self.objectModel);

    NSString *path = [self addTokenToPath:self.path];
    
    __block __weak BusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            if ([response[@"status"] isEqualToString:@"valid"]) {
                weakSelf.saveResultHandler(nil);
                return;
            }

            [weakSelf.objectModel createOrUpdateUserWithData:response];

            [weakSelf.workModel saveContext:^{
                weakSelf.saveResultHandler(nil);
            }];
        }];
    }];

    [self.objectModel performBlock:^{
        BusinessProfile *profile = (BusinessProfile *) [self.objectModel.managedObjectContext objectWithID:self.data];
        [self postData:[profile data] toPath:path];
    }];
}

+ (BusinessProfileOperation *)commitWithData:(NSManagedObjectID *)data {
    return [[BusinessProfileOperation alloc] initWithPath:kUpdateBusinessProfilePath data:data];
}

+ (BusinessProfileOperation *)validateWithData:(NSManagedObjectID *)data {
    return [[BusinessProfileOperation alloc] initWithPath:kValidateBusinessProfilePath data:data];
}

@end
