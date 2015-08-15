//
//  IdeaFlowChartView.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit


class IdeaFlowChartView: UIView {

    var centerPoint = CGPointZero
    var ringRadius: CGFloat?
    var ringLayers = [CAShapeLayer]()
    let ringLineWidth = CGFloat(5.0)
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.blackColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("_refresh"), name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("_refresh"), name: IdeaFlowEvent.Notifications.AllEventsDeleted.rawValue, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: IdeaFlowEvent.Notifications.AllEventsDeleted.rawValue, object: nil)
    }
    
    func _refresh() {
        
        println("\nq(^o^q)(p^o^)pq(^o^q)(p^o^)pq(^o^q)(p^o^)pq(^o^q)(p^o^)pq(^o^q)(p^o^)p\n")
        _removeAllRingLayers()
        
        let events = IdeaFlowEvent.MR_findAll()
        for event in events
        {
            _setupLayer(event as! IdeaFlowEvent)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        
        let maxRadius = fmin(bounds.width / 2.0, bounds.height / 2.0)
        ringRadius = maxRadius - 5
        _refresh()
    }
    
    private func _removeAllRingLayers() {
        for layer in ringLayers
        {
            layer.removeFromSuperlayer()
        }
        ringLayers.removeAll(keepCapacity: false)
    }
    
    private func _setupLayer(event: IdeaFlowEvent)
    {
        if event.endTimeStamp != nil
        {
            var layer = CAShapeLayer()
            layer.path = _createArcFromEvent(event.startTimeStamp, endTimeStamp: event.endTimeStamp)
            layer.lineWidth = ringLineWidth
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = event.eventTypeColor().CGColor
            layer.strokeStart = event.startTimeStamp.timeToPercentOfDay()
            layer.strokeEnd = event.endTimeStamp?.timeToPercentOfDay() ?? 0.0
            
            println("times   \(event.endTimeStamp!) - \(event.startTimeStamp)")
            println("strokes \(layer.strokeStart) - \(layer.strokeEnd)")
            
            layer.lineCap = kCALineCapSquare
            ringLayers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    private func _createArcFromEvent(startTimeStamp: NSDate, endTimeStamp: NSDate?) -> CGPathRef {
        let path = CGPathCreateMutable()
        
        let startDegrees = startTimeStamp.timeToPercentOfDay() * 360
        let endDegrees = endTimeStamp?.timeToPercentOfDay() ?? 0.0 * 360
        
        let radius = ringRadius! - CGFloat(ringLayers.count) * (ringLineWidth + 3)
        
        CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, radius, _degreesToRadians(startDegrees), _degreesToRadians(endDegrees-90), true)
        return path
    }
    
    private func _degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / CGFloat(180)
    }
    
}