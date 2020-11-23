/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/** Custom header view class to create section header for tableview */
class SectionHeaderView: UIView {
    
    //MARK: Variable Declarations
    var topLineView = UIView()
    var headerLabel = UILabel()
    var bottomLineView = UIView()

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    /** To add behaviour to the UIView*/
    func addBehavior (){
        
        //Invoking creation of views for headerview
        self.creatingView()
    }
    
    /** Creating sub-views for headerview*/
    func creatingView(){
        
        self.backgroundColor = UIColor.white
        
        topLineView = UIView()
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topLineView)
        
        // Top Line constrains in the section header view
        //Leading space
        let topLineConstrain1 = NSLayoutConstraint(item: topLineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        //Trailing space
        let topLineConstrain2 = NSLayoutConstraint(item: topLineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        //Height of the view
        let topLineConstrain3 = NSLayoutConstraint(item: topLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)
        //Top spacing from super view
        let topLineConstrain4 = NSLayoutConstraint(item: topLineView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        
        //Apply constrains to the view
        self.addConstraint(topLineConstrain1)
        self.addConstraint(topLineConstrain2)
        self.addConstraint(topLineConstrain3)
        self.addConstraint(topLineConstrain4)
        
        // Header view title constrains in the section header view
         headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerLabel)
        
        //Leading space
        let headerTitlec1 = NSLayoutConstraint(item: headerLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10)
        //Trailing space
        let headerTitlec2 = NSLayoutConstraint(item: headerLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
         //Height of the view
        let headerTitlec3 = NSLayoutConstraint(item: headerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        //Top spacing from super view
        let headerTitlec4 = NSLayoutConstraint(item: headerLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 11)
        
        //Apply constrains to the view
        self.addConstraint(headerTitlec1)
        self.addConstraint(headerTitlec2)
        self.addConstraint(headerTitlec3)
        self.addConstraint(headerTitlec4)
        
        // Bottom line constrains in the section header view
        bottomLineView = UIView()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView)
        
        //Leading space
        let bottonLinec1 = NSLayoutConstraint(item: bottomLineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        //Trailing space
        let bottonLinec2 = NSLayoutConstraint(item: bottomLineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        //Height of the view
        let bottonLinec3 = NSLayoutConstraint(item: bottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)
        //Top spacing from super view
        let bottonLinec4 = NSLayoutConstraint(item: bottomLineView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 61)
        
        //Apply constrains to the view
        self.addConstraint(bottonLinec1)
        self.addConstraint(bottonLinec2)
        self.addConstraint(bottonLinec3)
        self.addConstraint(bottonLinec4)
        
    }


}
