//
//  IdeaFlowChartView2.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit

extension CGFloat
{
    func degreesToRadians() -> CGFloat
    {
        return self * CGFloat(0.0174532925)
    }
}

class IdeaFlowChartView2: UIView
{
    var lineWidth :CGFloat
    {
        get{
            return 20//fmin(centerPoint.x,centerPoint.y) - radiusInset
        }
        
    }
    let radiusInset = CGFloat(5)
    var centerPoint = CGPoint(x: 0, y: 0)
    var radius: CGFloat?
    let fontColor = UIColor.whiteColor()
    let tickmarkColor = UIColor.whiteColor()
    
    var permanentOffset = CGFloat(0)
    var permanentOffsetPoint = CGPointZero
    var transientOffset = CGFloat(0)
    var transientOffsetPoint = CGPointZero
    var experimentalOffset: CGFloat { get { return permanentOffset + transientOffset} }
    var experimentalOffsetPoint: CGPoint { get { return CGPointMake(permanentOffsetPoint.x + transientOffsetPoint.x, permanentOffsetPoint.y + transientOffsetPoint.y)} }
    
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserverForIdeaFlowEvents(self, selector: Selector("_refresh"))
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func _refresh()
    {
        setNeedsDisplay()
    }
    
    private func _rotateContextNegative90Degrees(context: CGContextRef)
    {
        CGContextTranslateCTM(context, centerPoint.x, centerPoint.y)
        CGContextRotateCTM(context, CGFloat(-90).degreesToRadians())
        CGContextTranslateCTM(context, -centerPoint.x, -centerPoint.y)
    }
    
    override func drawRect(rect: CGRect)
    {
        centerPoint = CGPointMake(bounds.width / 2.0, bounds.height / 2.0)
        radius = fmin(centerPoint.x, centerPoint.y) - radiusInset
        
        let context = UIGraphicsGetCurrentContext()
        
        let hours = 24
        drawEventRings(context!)
        drawQuarterHourMarkers(context!,hours:hours)
        drawHoursText(context!, rect: rect, x: centerPoint.x, y: centerPoint.y, radius: radius!, sides: hours, color: UIColor.whiteColor())
    }
    
    private func drawEventRings(context: CGContextRef)
    {
        if let events = IdeaFlowEvent.getEventsForSelectedDay()
        {   
            var index : CGFloat = 0
            let currentRadius : CGFloat = radius! - lineWidth/2.0
            
            CGContextSaveGState(context)
            _rotateContextNegative90Degrees(context)
            
            for event in events
            {
                CGContextBeginPath(context);
                
                let startPercent = event.startTimeStamp.timeToPercentOfDay()
                //always draw to the end of the day.  if there is a next event for the day, it will draw over the appropriate segment
                let endTimeStamp = event.startTimeStamp.oneSecondBeforeMidnight()
                
                let endPercent = endTimeStamp!.timeToPercentOfDay()
                
                let startAngle = (startPercent * CGFloat(2*M_PI))
                let endAngle = (endPercent * CGFloat(2*M_PI))
                
                CGContextAddArc(context, centerPoint.x, centerPoint.y, currentRadius, startAngle, endAngle, 0)
                
                CGContextSetStrokeColorWithColor(context, event.eventTypeColor().CGColor)
                CGContextSetLineWidth(context, lineWidth)
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
                
                index = index + 1
            }
            
            CGContextRestoreGState(context)
        }
    }
    
    func drawQuarterHourMarkers(context: CGContextRef, hours: Int)
    {
        let totalMarkers = CGFloat(hours*4)
        let degreesPerMarker = CGFloat(360 / totalMarkers)
        for i in 1...Int(totalMarkers)
        {
            // save the original position and origin
            CGContextSaveGState(context)
            // make translation
            CGContextTranslateCTM(context, centerPoint.x, centerPoint.y)
            // make rotation
            let degrees = CGFloat(i)*degreesPerMarker
            CGContextRotateCTM(context, degrees.degreesToRadians())
            if i % 4 == 0
            {
                // if an hour position we want a line slightly longer
                drawSecondMarker(context, x: radius!-15, y:0, radius:radius!, color: tickmarkColor)
            }
            else
            {
                drawSecondMarker(context, x: radius!-10, y:0, radius:radius!, color: tickmarkColor)
            }
            // restore state before next translation
            CGContextRestoreGState(context)
        }
    }
    
    func drawSecondMarker(context:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, color:UIColor)
    {
        // generate a path
        let path = CGPathCreateMutable()
        // move to starting point on edge of circle
        CGPathMoveToPoint(path, nil, radius, 0)
        // draw line of required length
        CGPathAddLineToPoint(path, nil, x, y)
        // close subpath
        CGPathCloseSubpath(path)
        // add the path to the context
        CGContextAddPath(context, path)
        // set the line width
        CGContextSetLineWidth(context, 1.5)
        // set the line color
        CGContextSetStrokeColorWithColor(context,color.CGColor)
        // draw the line
        CGContextStrokePath(context)
    }
    
    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint]
    {
        let angle = CGFloat(360/sides).degreesToRadians()
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides
        {
            let xpo = cx - r * cos(angle * CGFloat(i)+adjustment.degreesToRadians())
            let ypo = cy - r * sin(angle * CGFloat(i)+adjustment.degreesToRadians())
            points.append(CGPoint(x: xpo, y: ypo))
            i--;
        }
        return points
    }
    
    func drawHoursText(context:CGContextRef, rect:CGRect, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor)
    {
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        CGContextTranslateCTM(context, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(context, 1.0, -1.0)
        // dictates on how inset the ring of numbers will be
        let inset = CGFloat(35)
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius-inset, adjustment:270)
        _ = CGPathCreateMutable()
        
        for p in points.enumerate()
        {
            if p.index > 0
            {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                let fontSize = (radius/CGFloat(5)) / CGFloat(sides/12)
                let aFont = UIFont.systemFontOfSize(fontSize)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionaryRef = [NSFontAttributeName:aFont,NSForegroundColorAttributeName:fontColor]
                // create the attributed string
                let text = CFAttributedStringCreate(nil, p.index.description, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
                // set the line width to stroke the text with
                CGContextSetLineWidth(context, 1.5)
                // set the drawing mode to stroke
                CGContextSetTextDrawingMode(context, CGTextDrawingMode.Fill)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                CGContextSetTextPosition(context, xn, yn)
                // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
                // draw the line of text
                CTLineDraw(line, context)
            }
        }
        
    }
}
