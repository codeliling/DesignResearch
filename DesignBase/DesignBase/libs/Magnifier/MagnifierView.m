//  MagnifierView.m
//  Fix CTM by Zhang Yungui <https://github.com/rhcad/touchvg> based on SimplerMaskTest:
//  http://stackoverflow.com/questions/13330975/how-to-add-a-magnifier-to-custom-control
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnifierView
@synthesize viewToMagnify, touchPoint;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, 180, 180)]) {
        // make the circle-shape outline with a nice border.
        /*
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
       */
        CALayer *maskLayer = [CALayer new];
        maskLayer.frame = CGRectMake(0, 0, 180, 180);
        maskLayer.contents = (id)[UIImage imageNamed:@"panelBg"].CGImage;
        [self.layer addSublayer:maskLayer];
        self.layer.borderWidth = 0;
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)pt {
    touchPoint = pt;
    // whenever touchPoint is set,
    // update the position of the magnifier (to just above what's being magnified)
    self.center = CGPointMake(pt.x, pt.y - 10);
}

- (void)drawRect:(CGRect)rect {
    // here we're just doing some transforms on the view we're magnifying,
    // and rendering that view directly into this view,
    // rather than the previous method of copying an image.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
    CGContextScaleCTM(context, 1.2, 1.2);
    CGContextTranslateCTM(context,-1*(touchPoint.x),-1*(touchPoint.y));
    [self.viewToMagnify.layer renderInContext:context];
}

@end
