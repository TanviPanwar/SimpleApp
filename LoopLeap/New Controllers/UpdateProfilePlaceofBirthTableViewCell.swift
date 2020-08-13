//
//  UpdateProfilePlaceofBirthTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 08/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class UpdateProfilePlaceofBirthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var paceofBirthView: UIView!
    @IBOutlet weak var placeofBirthTextField: UITextField!
    @IBOutlet weak var elementarySchoolView: UIView!
    @IBOutlet weak var elementarySchoolTextField: UITextField!
    @IBOutlet weak var middleSchoolView: UIView!
    @IBOutlet weak var middleSchoolTextField: UITextField!
    @IBOutlet weak var highSchoolView: UIView!
    @IBOutlet weak var highSchoolTextField: UITextField!
    @IBOutlet weak var collegeView: UIView!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var gradCollegeView: UIView!
    @IBOutlet weak var gradCollegeField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
