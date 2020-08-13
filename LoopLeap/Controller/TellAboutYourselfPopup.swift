//
//  TellAboutYourselfViewController.swift
//  LoopLeap
//
//  Created by IOS2 on 12/19/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class TellAboutYourselfPopup: UIViewController
{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!

    
    var yesAcion :blockAction?
    var  noAction : blockAction?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
       // yesBtn.backgroundColor = .clear
        yesBtn.layer.cornerRadius = 27.5
        yesBtn.layer.borderWidth = 2
        yesBtn.layer.borderColor = UIColor.white.cgColor
        
       // noBtn.backgroundColor = .clear
        noBtn.layer.cornerRadius = 27.5
        noBtn.layer.borderWidth = 2
        noBtn.layer.borderColor = UIColor.white.cgColor
        
        //showAnimate()

        
        

        // Do any additional setup after loading the view.
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

        
       // self.dismiss(animated: true, completion: nil)
//
//        })
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
