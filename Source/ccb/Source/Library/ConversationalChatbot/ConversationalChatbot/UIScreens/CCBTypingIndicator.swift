//
//  CCBTypingIndicator.swift
//  ConversationalChatbotDev
//
//  Created by Shravana Kumar on 04/08/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS

class CCBBubbleView: UIView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = roundedMask(corners: .allCorners, radius: bounds.height / 2)
    }
    
    func roundedMask(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        return mask
    }
    
}


class CCBTypingIndicatorView: UIView {
        
        var bounceOffset: CGFloat = 2.5
        var isBounceEnabled: Bool = false
        var isFadeEnabled: Bool = true
        
        
        public private(set) var isAnimating: Bool = false
        private struct AnimationKeys {
            static let offset = "typingIndicator.offset"
            static let bounce = "typingIndicator.bounce"
            static let opacity = "typingIndicator.opacity"
            static let delayConstant = 0.33
        }
        
        /// initial offset for bounce
        open var initialOffsetAnimationLayer: CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.byValue = -bounceOffset
            animation.duration = 0.5
            animation.isRemovedOnCompletion = true
            return animation
        }
        
        /// if isBounceEnabled  is TRUE
        open var bounceAnimationLayer: CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.toValue = -bounceOffset
            animation.fromValue = bounceOffset
            animation.duration = 0.5
            animation.repeatCount = .infinity
            animation.autoreverses = true
            return animation
        }
        
        /// if isFadeEnabled is TRUE
        open var opacityAnimationLayer: CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1
            animation.toValue = 0.5
            animation.duration = 0.5
            animation.repeatCount = .infinity
            animation.autoreverses = true
            return animation
        }
        
        
        private let stackView = UIStackView()
        
        private let dots: [CCBBubbleView] = {
            return [CCBBubbleView(), CCBBubbleView(), CCBBubbleView()]
        }()
        
        // MARK: - Initialization
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }
        
        /// Sets up the view
        private func setupView() {
            dots.forEach {
                $0.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultText
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
                stackView.addArrangedSubview($0)
            }
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            addSubview(stackView)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            stackView.frame = bounds
            stackView.spacing = bounds.width > 0 ? 5 : 0
        }
        
        func startAnimating() {
            defer { isAnimating = true }
            guard !isAnimating else { return }
            var delay: TimeInterval = 0
            for dot in dots {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let `self` = self else { return }
                    if self.isBounceEnabled {
                        dot.layer.add(self.initialOffsetAnimationLayer, forKey: AnimationKeys.offset)
                        let bounceLayer = self.bounceAnimationLayer
                        bounceLayer.timeOffset = delay + AnimationKeys.delayConstant
                        dot.layer.add(bounceLayer, forKey: AnimationKeys.bounce)
                    }
                    if self.isFadeEnabled {
                        dot.layer.add(self.opacityAnimationLayer, forKey: AnimationKeys.opacity)
                    }
                }
                delay += AnimationKeys.delayConstant
            }
        }
        
        /// Sets the state of the `TypingIndicator` to not animating and removes animation layers
        func stopAnimating() {
            defer { isAnimating = false }
            guard isAnimating else { return }
            dots.forEach {
                $0.layer.removeAnimation(forKey: AnimationKeys.bounce)
                $0.layer.removeAnimation(forKey: AnimationKeys.opacity)
            }
        }
        
    }


class CCBTriangeView: UIView {
    
    
    func makeRightTriangle(fillColor:UIColor){
           let heightWidth = self.frame.size.width
           let path = CGMutablePath()

           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x:heightWidth, y: heightWidth/2))
           path.addLine(to: CGPoint(x:0, y:heightWidth))
           path.addLine(to: CGPoint(x:0, y:heightWidth))

           let shape = CAShapeLayer()
           shape.path = path
        shape.addAShadow(color: UIColor(red: 189 / 255, green: 204 / 255, blue: 215 / 255, alpha: 0.54) , offset: CGSize(width: 3, height: 0), radius: 2.0)
           shape.fillColor = fillColor.cgColor;

           self.layer.insertSublayer(shape, at: 0)
       }

       func makeLeftTriangle(fillColor:UIColor){
           let heightWidth = self.frame.size.width
           let path = CGMutablePath()

           path.move(to: CGPoint(x: heightWidth, y: 0))
           path.addLine(to: CGPoint(x:0, y: heightWidth/2))
           path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
           path.addLine(to: CGPoint(x:heightWidth, y:0))

           let shape = CAShapeLayer()
           shape.path = path
            shape.addAShadow(color: UIColor(red: 189 / 255, green: 204 / 255, blue: 215 / 255, alpha: 0.54), offset: CGSize(width: -3, height: 0), radius: 2.0)
           shape.fillColor = fillColor.cgColor;

           self.layer.insertSublayer(shape, at: 0)
       }
}
