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
@property (nonatomic, weak)  CAGradientLayer *gradient;

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
        
        self.backgroundColor = [UIColor greenColor];
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

@end


@interface InvitationProgressIndicatorView ()

@property (nonatomic,strong) NSArray* segments;
@property (nonatomic,strong) NSArray* startColors;
@property (nonatomic,strong) NSArray* endColors;

@end

@implementation InvitationProgressIndicatorView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self commonSetup];
    }
    
    return self;
}

-(void)commonSetup
{
    NSMutableArray* segments = [NSMutableArray arrayWithCapacity:4];
    CGFloat radius = (roundf(self.bounds.size.width/2.0f));
    for( int i=0 ; i<4 ; i++)
    {
        ProgressSegment *segment = [[ProgressSegment alloc] initWithRadius:radius startColor:[UIColor blueColor] endColor:[UIColor redColor]];
        [segments addObject:segment];
        segment.center = CGPointMake(self.bounds.size.width/2.0f,self.bounds.size.height/2.0f);
        segment.transform = CGAffineTransformMakeRotation((i*120.0f/180) * M_PI);
        [self addSubview:segment];
    }
    
    _segments = segments;
    
    _startColors = @[[UIColor colorFromStyle:@"LightBlue"],[UIColor colorFromStyle:@"LightBlue"],[UIColor colorFromStyle:@"LightBlue"]];
    _endColors = @[[UIColor colorFromStyle:@"LightBlueHighlighted"],[UIColor colorFromStyle:@"LightBlueHighlighted"],[UIColor colorFromStyle:@"LightBlueHighlighted"]];
}

-(void)awakeFromNib
{
    [self commonSetup];
}


-(void)setProgress:(NSUInteger)progress animated:(BOOL)animated
{
    NSUInteger truncatedProgress = progress % self.segments.count -1 ;
    for(int i = 0 ; i<self.segments.count - 1 ; i++)
    {
        ProgressSegment* segment = self.segments[i];
        if (truncatedProgress - 1 > i)
        {
            segment.startColor = [UIColor colorFromStyle:@"separatorGrey"];
            segment.endColor = segment.startColor;
        }
        else
        {
            segment.startColor = self.startColors[i];
            segment.endColor = self.endColors[i];
        }
    }
    
    
    ProgressSegment* lastSegment = self.segments[self.segments.count - 1];
    lastSegment.startColor = self.startColors[truncatedProgress];
    lastSegment.endColor = self.endColors[truncatedProgress];
    lastSegment.transform = [(ProgressSegment*)self.segments[truncatedProgress] transform];
    
}



@end
