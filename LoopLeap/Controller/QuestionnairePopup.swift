//
//  QuestionnaireViewController.swift
//  LoopLeap
//
//  Created by IOS2 on 12/19/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class QuestionnairePopup: UIViewController
{
     @IBOutlet weak var txtViw: UITextView!
    @IBOutlet weak var questionmarkImage: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!

    var yesAcion :blockAction?
    var  noAction : blockAction?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        popupview.layer.cornerRadius = 15
//        popupview.layer.shadowColor = UIColor.black.cgColor
//        popupview.layer.shadowOffset = CGSize(width: 0, height: 10)
//        popupview.layer.shadowOpacity = 0.9
//        popupview.layer.shadowRadius = 5
        
       // yesBtn.backgroundColor = .clear
        yesBtn.layer.cornerRadius = 27.5
        yesBtn.layer.borderWidth = 2
        yesBtn.layer.borderColor = UIColor.white.cgColor
        
        //noBtn.backgroundColor = .clear
        noBtn.layer.cornerRadius = 27.5
        noBtn.layer.borderWidth = 2
        noBtn.layer.borderColor = UIColor.white.cgColor
        txtViw.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //txtViw.contentOffset = CGPoint.zero

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtViw.isScrollEnabled = true
        txtViw.flashScrollIndicators()
    }
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func yesButtonAction(_ sender: Any)
    {
        self.yesAcion!()
        
    }
    
    @IBAction func noButtonAction(_ sender: Any)
    {
       self.noAction!()
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
