//
//  InvitationProgressIndicatorView.m
//  Transfer
//
//  Created by Mats Trovik on 13/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InvitationProgressIndicatorView.h"
#import "MOMStyle.h"

@interface ProgressSegment : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic, strong) UIColor *startColor;

@property (nonatomic, strong) UIColor *endColor;

@end

@implementation ProgressSegment

- (id)initWithRadius:(CGFloat)radius startColor:(UIColor*)startColor endColor:(UIColor*)endColor
{
    CGRect frame = CGRectMake(0, 0, radius, (1 + cosf((60.0f/180)*M_PI)) * radius);
    
    self = [super initWithFrame:frame];
    if (self) {

        _radius = radius;
        
        _startColor = startColor;
        _endColor = endColor;
        
        self.backgroundColor = [UIColor colorFromStyle:@"separatorGrey"];
        CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
        gradient.frame = self.bounds;
        gradient.startPoint = CGPointMake(0.0f, 0.0f);
        gradient.endPoint = CGPointMake(sinf((60.0f/180)*M_PI),1.0f);
        gradient.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
        
        _gradient = gradient;
        
        [self.layer addSublayer:gradient];
        
        UIBezierPath *arcShape = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0.0f, radius) radius:radius startAngle:1.5f*M_PI endAngle:((120.0f/180) - 0.5f)*M_PI clockwise:YES];
        [arcShape addLineToPoint:CGPointMake(0.0f, radius)];
        [arcShape closePath];

        [arcShape setUsesEvenOddFillRule:YES];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.path = arcShape.CGPath;

        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.fillColor = [UIColor grayColor].CGColor;
        self.layer.mask = shapeLayer;
        
        CGPoint anchor = CGPointMake(0.0f, radius / self.bounds.size.height);
        
        self.layer.anchorPoint = anchor;
        
        
        
    }
    return self;
}

-(void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    [self updateColors];
}

-(void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    [self updateColors];
}

-(void)updateColors
{
    self.gradient.colors = @[(id)self.startColor.CGColor,(id)self.endColor.CGColor];
}


-(void)showGradient:(BOOL)showGradient
{
    if (showGradient)
    {
        [self.layer addSublayer:self.gradient];
    }
    else
    {
        [self.gradient removeFromSuperlayer];
    }
}


@end


@interface InvitationProgressIndicatorView ()

@property (nonatomic,strong) NSArray* staticSegments;
@property (nonatomic,strong) ProgressSegment *dynamicSegment;
@property (nonatomic,strong) NSArray* startColors;
@property (nonatomic,strong) NSArray* endColors;

@end

@implementation InvitationProgressIndicatorView


-(void)setupSegments
{
    NSMutableArray* segments = [NSMutableArray arrayWithCapacity:4];
    CGFloat radius = (roundf(self.bounds.size.width/2.0f));
    
    _startColors = @[[UIColor colorFromStyle:@"invite0_1"],[UIColor colorFromStyle:@"invite1_1"],[UIColor colorFromStyle:@"invite2_1"]];
    _endColors = @[[UIColor colorFromStyle:@"invite0_2"],[UIColor colorFromStyle:@"invite1_2"],[UIColor colorFromStyle:@"invite2_2"]];

    
    for( int i=0 ; i<3 ; i++)
    {
        ProgressSegment *segment = [[ProgressSegment alloc] initWithRadius:radius startColor:_startColors[i] endColor:_endColors[i]];
        [segments addObject:segment];
        segment.center = CGPointMake(self.bounds.size.width/2.0f,self.bounds.size.height/2.0f);
        segment.transform = CGAffineTransformMakeRotation((i*120.0f/180) * M_PI);
        [self addSubview:segment];
    }
    
    _staticSegments = segments;
    
    ProgressSegment *segment = [[ProgressSegment alloc] initWithRadius:radius startColor:[UIColor blueColor] endColor:[UIColor redColor]];
    segment.center = CGPointMake(self.bounds.size.width/2.0f,self.bounds.size.height/2.0f);
    segment.transform = CGAffineTransformIdentity;
    [self addSubview:segment];
    
    self.dynamicSegment = segment;
    

}


-(void)setProgress:(NSUInteger)progress animated:(BOOL)animated
{
    if(!self.staticSegments)
    {
        [self setupSegments];
    }
    
    if(progress==0)
    {
        return;
    }
    
    
    //setup static segments
    NSUInteger truncatedProgress = (progress - 1 ) % ([self.staticSegments count]);
    [self.staticSegments enumerateObjectsUsingBlock:^(ProgressSegment* segment, NSUInteger i, BOOL *stop) {
        [self bringSubviewToFront:segment];
        if (i >= truncatedProgress )
        {
            [segment showGradient:NO];
            if(i == truncatedProgress)
            {
                [self sendSubviewToBack:segment];
            }
        }
        else
        {
            [segment showGradient:YES];
        }
    }];

    //Setup dynamic segment
    
    self.dynamicSegment.startColor = self.startColors[truncatedProgress];
    self.dynamicSegment.endColor = self.endColors[truncatedProgress];
    if(animated)
    {   NSInteger previousSegmentIndex = truncatedProgress - 1;
        if(previousSegmentIndex<0)
        {
            previousSegmentIndex = [self.staticSegments count] - 1;
        }
        self.dynamicSegment.transform = [(ProgressSegment*)self.staticSegments[previousSegmentIndex] transform];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.dynamicSegment.transform = [(ProgressSegment*)self.staticSegments[truncatedProgress] transform];
        } completion:nil];
        
        
    }
    else
    {
        self.dynamicSegment.transform = [(ProgressSegment*)self.staticSegments[truncatedProgress] transform];
    }
    
    
    
}



@end
