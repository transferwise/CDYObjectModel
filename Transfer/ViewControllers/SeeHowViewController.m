//
//  WhyViewController.m
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SeeHowViewController.h"
#import "GoogleAnalytics.h"

@interface SeeHowViewController ()

@end

@implementation SeeHowViewController

-(SeeHowView *)whyView
{
    [[GoogleAnalytics sharedInstance] sendScreen:GASeeHowModal];
    return (SeeHowView*)self.view;
    
    
}

@end
