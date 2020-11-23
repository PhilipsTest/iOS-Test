//
//  CCBMessageTableViewCell.swift
//  ConversationalChatbotDev
//
//  Created by Shravan Kumar on 22/07/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS
import markymark

protocol CCBMessageCell: class {
  var message: Activity? { get set }
//    var leftChatIcon:UiImage?
}

protocol CCBMessageCellAction {
    func userClicked(onLink link:URL)
    func userClicked(onVideo link:URL)
}

class CCBMessageBaseTableViewCell: UITableViewCell,CCBMessageCell {
    
    @IBOutlet weak var textBubble: UIDView!
    @IBOutlet weak var triangleView: CCBTriangeView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var chatIconImageView: UIImageView!
    @IBOutlet weak var contentMarkView: MarkDownTextView!
    @IBOutlet weak var productImageViiewConstraint: NSLayoutConstraint!
    
    private var imageURLS:[String] = [String]()
    
    fileprivate enum Constants {
      static let shadowColor = UIColor(red: 189 / 255, green: 204 / 255, blue: 215 / 255, alpha: 0.54)
      static let shadowRadius: CGFloat = 2
      static let shadowOffset = CGSize(width: 0, height: 1)
      static let chainedMessagesBottomMargin: CGFloat = 20
      static let lastMessageBottomMargin: CGFloat = 32
    }
    
      var message: Activity? {
        didSet {
          guard let message = message else {
            return
          }
            let text = self.parseAndProvideText(message: message.text ?? "")
            contentMarkView.text = text
            self.loadImageForImageCard()
            self.showIndicatorView()
        }
      }
    
    var delegate: CCBMessageCellAction? {
        didSet {
            guard let aDeletage = delegate else { return }
            contentMarkView.urlOpener = CCBCellURLRule(delegate: aDeletage)
        }
    }

    func showIndicatorView() {
        //
    }
    
    func updateChatIcon(image:UIImage) {
        //
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      textBubble.layer.cornerRadius = 4
      textBubble.layer.addAShadow(
        color: Constants.shadowColor,
        offset: Constants.shadowOffset,
        radius: Constants.shadowRadius)
        contentMarkView.styling.paragraphStyling.textColor = UIDThemeManager.sharedInstance.defaultTheme?.labelRegularText
        contentMarkView.styling.paragraphStyling.contentInsets = UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
        contentMarkView.styling.paragraphStyling.baseFont =  UIFont(uidFont: .medium, size: UIDFontSizeMedium)
        contentMarkView.styling.linkStyling.baseFont =  UIFont(uidFont: .medium, size: UIDFontSizeMedium)
        contentMarkView.styling.linkStyling.textColor =  UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultText
        contentMarkView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        self.contentMarkView.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = .clear
    }
    
    private func parseAndProvideText(message:String) -> String {
        let markyMark = MarkyMark(build: {
            $0.setFlavor(ContentfulFlavor())
        })
        let markDownItems = markyMark.parseMarkDown(message)
        let imageItems = markDownItems.filter({
            if let _ = $0 as? ImageMarkDownItem {
                return true
            } else {
                return false
            }
        })
        guard imageItems.count > 0 else {
            self.imageURLS.removeAll()
            return message
        }
        var textNSString = message as NSString
        for anImageItem in imageItems {
            var valueRange = textNSString.range(of: (anImageItem as! ImageMarkDownItem).altText)
            
            if valueRange.location >= 2 {
                valueRange.location = valueRange.location - 2
            }
            valueRange.length = valueRange.length + 3
            textNSString = textNSString.replacingCharacters(in: valueRange, with: "") as NSString
            
            var linkRange = textNSString.range(of: (anImageItem as! ImageMarkDownItem).file)
            linkRange.location = linkRange.location - 1
            linkRange.length = linkRange.length + 2
            textNSString = textNSString.replacingCharacters(in: linkRange, with: "") as NSString
            self.imageURLS.append((anImageItem as! ImageMarkDownItem).file)
        }
        
        return textNSString as String

    }
    
    private func loadImageForImageCard() {
        
        guard self.imageURLS.count > 0 else {
            self.productImageView.isHidden = true
            self.productImageViiewConstraint.constant = 0
            return
        }
        self.productImageViiewConstraint.constant = 50
        DispatchQueue(label: "downloadImage").async {
            guard let url = URL(string:self.imageURLS.first ?? "") else {
                return;
            }
            DispatchQueue.main.async {
                let placeHolderImage = UIImage(named: "WelcomeImageIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
                self.productImageView.setImageWith(url, placeholderImage:placeHolderImage )
                self.productImageView.contentMode = .scaleAspectFit
                self.productImageView.setNeedsDisplay()
                self.productImageView.isHidden = false
                self.layoutIfNeeded()
            }
        }
    }
    
}

class CCBInMessageTableViewCell: CCBMessageBaseTableViewCell  {
  
    @IBOutlet weak var indicatorView: UIView!
    private var typingIndicatorView: CCBTypingIndicatorView?
    
  override func awakeFromNib() {
    super.awakeFromNib()
    textBubble.backgroundColor = UIColor.white
    self.typingIndicatorView = CCBTypingIndicatorView()
//    var frame = self.indicatorView.bounds
    self.textBubble.backgroundColorType = .primary
    self.typingIndicatorView?.frame = CGRect(x: 15, y: -15, width: 50, height: 50)
    self.typingIndicatorView?.isFadeEnabled = true
    self.typingIndicatorView?.isBounceEnabled = true
    self.typingIndicatorView?.isHidden = true
    self.indicatorView.addSubview(self.typingIndicatorView!)
    self.triangleView.makeLeftTriangle(fillColor: self.textBubble.backgroundColor!)
  }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
  
    override func showIndicatorView() {
        if (self.message?.type == .typing) {
            self.typingIndicatorView?.isHidden = false
            self.indicatorView.isHidden = false
            self.textBubble.isHidden = true
            self.typingIndicatorView?.startAnimating()
            self.textBubble.backgroundColor = .clear
        } else {
            self.typingIndicatorView?.isHidden = true
            self.typingIndicatorView?.stopAnimating()
            self.textBubble.isHidden = false
            self.indicatorView.isHidden = true
            self.textBubble.backgroundColorType = .primary
        }
    }
    
    override func updateChatIcon(image:UIImage) {
        self.chatIconImageView.image = image
    }

}


class CCBOutMessageTableViewCell: CCBMessageBaseTableViewCell {
  

  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.clear
    self.textBubble.backgroundColorType = .secondary
    self.triangleView.makeRightTriangle(fillColor: self.textBubble.backgroundColor!)
  }
    
    override func updateChatIcon(image:UIImage) {
        //
    }

  
}

extension CALayer {
    
    fileprivate var allCorners: CACornerMask { return [ .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner ] }
    
    func roundCorners(radius: CGFloat, skipping skip: CACornerMask = []) {
        self.cornerRadius = radius
        self.maskedCorners = allCorners.subtracting(skip)
    }
    // system default for shadowRadius is 3.0
    // system default for shadowOffset is (0.0, -3.0)
    func addShadow(opacity: Float, radius: CGFloat = 3.0, offset: CGSize = CGSize(width: 0.0, height: -3.0)) {
        self.shadowOffset = .zero
        self.shadowOpacity = opacity
        self.shadowRadius = radius
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        self.shadowOffset = offset
    }
    
    func addAShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
      shadowColor = color.cgColor
      shadowOffset =  offset
      shadowRadius = radius
      shadowOpacity = 1
    }
    
//    func addBottomBorder(color: UIColor = .separator, width: CGFloat = 1) {
//      let borderLayer = CALayer()
//      borderLayer.frame = CGRect(
//        x: 0,
//        y: frame.height - 1,
//        width: frame.width,
//        height: width)
//      borderLayer.backgroundColor = color.cgColor
//      addSublayer(borderLayer)
//    }
}


class CCBCellURLRule : NSObject, URLOpener {
    
    var delegate: CCBMessageCellAction?
    
    init(delegate:CCBMessageCellAction) {
        super.init()
        self.delegate = delegate
    }
    
    func open(url: URL) {
        if url.absoluteString.contains("youtube") {
            self.delegate?.userClicked(onVideo: url)
        } else {
            self.delegate?.userClicked(onLink: url)
        }
    }
}

