//
//  Extensions.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class Extensions: NSObject {

}

extension UITextField {
    func textFieldWithLeftView(width:CGFloat , icon:UIImage)  {
        self.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        imageView.image = icon
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        self.leftView = imageView
    }
}
