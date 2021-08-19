//
//  ToastView.swift
//  TWLifeInfo
//
//  Created by Frost on 2015/11/23.
//  Copyright © 2015年 Frost Chen. All rights reserved.
//

import UIKit

class FCToastView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageLabel_Top_Constraint: NSLayoutConstraint!
    
    static var toast: FCToastView?
    
    static func clear() {
        toast?.removeFromSuperview()
    }
    
    static func initToast() {
        let className = NSStringFromClass(self)
        let bundle:Bundle = Bundle(for: NSClassFromString(className)!)
        let xibName = className.components(separatedBy: ".").last!
        self.toast = UINib(nibName: xibName, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? FCToastView
    }
    
    static func showMessage(message:String,
                                   backgroundColor:UIColor? = nil,
                                   textColor:UIColor? = nil) {
        DispatchQueue.main.async {
            if(self.toast == nil) {
                self.initToast()
            }
            
            if let toast = self.toast {
                toast.isUserInteractionEnabled = false
                if let backgroundColor = backgroundColor {
                    toast.backgroundColor = backgroundColor
                } else {
                    toast.backgroundColor = UIColor.white
                }
                
                if let textColor = textColor {
                    toast.messageLabel.textColor = textColor
                } else {
                    toast.messageLabel.textColor = UIColor.black
                }
                
                let window: UIWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })!
                window.layer.removeAllAnimations()
                toast.removeFromSuperview()
                self.initToastUI(message: message)
                window.addSubview(toast)
                
                toast.alpha = 0
                UIView.animate(withDuration: 0.6,
                               animations: { () -> Void in
                                toast.alpha = 0.7
                               },
                               completion: { (finished) -> Void in
                                if finished {
                                    UIView.animate(withDuration: 0.86, delay: 0.7,
                                                   options: UIView.AnimationOptions.allowAnimatedContent,
                                                   animations: { () -> Void in
                                                    toast.alpha = 0
                                                    
                                                   }, completion: { (Bool) -> Void in
                                                    
                                                   })
                                }
                               })
                
            }
        }
    }


    private static func initToastLayer() {
        if let toast = self.toast {
            toast.layer.borderWidth = 1
            toast.layer.cornerRadius = 16
            toast.layer.shadowOpacity = 0.8
            toast.layer.shadowRadius = 5
            toast.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }
    
    private static func initToastUI(message:String) {
        let toastHorizontalGap:CGFloat = 40
        let labelVerticalGap:CGFloat = 5
        let labelHorizontalGap:CGFloat = 10
        let toastBottomGap:CGFloat = 80
        
        let window: UIWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })!
        let windowHeight:CGFloat = window.frame.size.height
        let windowWidth:CGFloat = window.frame.size.width
        let maxToastWidth:CGFloat = windowWidth - 2 * toastHorizontalGap
     
        self.initToastLayer()
        
        if let toast = self.toast {
            toast.messageLabel.text = message
            
            let stringSize = toast.messageLabel.text!.FCGetOneLineStringWidth(font: toast.messageLabel.font)
            
            var stringWidth:CGFloat = stringSize.width
            var stringHeight:CGFloat = stringSize.height
            if(stringSize.width > maxToastWidth) {
                stringWidth = maxToastWidth
                stringHeight = toast.messageLabel.text!.FCStringHeightWithConstrainedWidth(width: maxToastWidth, font: toast.messageLabel.font)
            }
            
            stringHeight = ceil(stringHeight)
            stringWidth = ceil(stringWidth)
            toast.frame.size.width = stringWidth + 2 * labelHorizontalGap
            toast.frame.size.height = stringHeight + 2 * labelVerticalGap
            toast.messageLabel.sizeToFit()
            
            toast.frame.origin.y = windowHeight -  toast.frame.size.height - toastBottomGap
            toast.frame.origin.x = windowWidth/2 - toast.frame.size.width/2
        }
    }
    
}
