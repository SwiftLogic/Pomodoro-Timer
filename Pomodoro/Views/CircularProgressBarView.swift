//
//  CircularProgressBarView.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/25/22.
//

import UIKit

class CircularProgressBarView: UIView {
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Properties
    
    private var circleLayer = CAShapeLayer()
     var progressLayer = CAShapeLayer()
    
    
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    private var progressLineWideth: CGFloat = 12.0
    
    //MARK: - Methods
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = progressLineWideth / 2
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.appMainColor.withAlphaComponent(0.1).cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = progressLineWideth
        progressLayer.strokeEnd = 1.0
        progressLayer.strokeColor = UIColor.appGrayColor.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    
    
    func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.repeatCount = .infinity////
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    
    
}
