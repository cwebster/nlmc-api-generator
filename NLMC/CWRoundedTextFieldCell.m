//
//  CWRoundedTextFieldCell.m
//  
//
//  Created by Craig Webster on 05/01/2015.
//
//

#import "CWRoundedTextFieldCell.h"

@implementation CWRoundedTextFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSBezierPath *betterBounds = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:5 yRadius:5];
    [betterBounds addClip];
    [super drawWithFrame:cellFrame inView:controlView];
    if (self.isBezeled) {
        [betterBounds setLineWidth:2];
        [[NSColor colorWithCalibratedRed:0.510 green:0.643 blue:0.804 alpha:1] setStroke];
        [betterBounds stroke];
    }
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    [self.backgroundColor set];
    NSRectFill(cellFrame);
    
    NSAttributedString *attrString = self.attributedStringValue;
    
    /* if your values can be attributed strings, make them white when selected */
    if (self.isHighlighted && self.backgroundStyle==NSBackgroundStyleDark) {
        NSMutableAttributedString *whiteString = attrString.mutableCopy;
        [whiteString addAttribute: NSForegroundColorAttributeName
                            value: [NSColor whiteColor]
                            range: NSMakeRange(0, whiteString.length) ];
        attrString = whiteString;
    }
    
    [attrString drawWithRect: [self titleRectForBounds:cellFrame]
                     options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
    
    
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = self.attributedStringValue;
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height;
    }
    return titleFrame;
}
@end
