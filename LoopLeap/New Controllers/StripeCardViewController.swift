//
//  StripeCardViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 08/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Stripe

class StripeCardViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var btnBuy: UIButton!
    
    let cardParams = STPCardParams()



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let paymentField = STPPaymentCardTextField(frame: CGRect(x: 10, y: 100, width:self.view.frame.size.width - 20, height: 44))
        paymentField.delegate = self
        self.view.addSubview(paymentField)
        
        self.navigationController?.navigationBar.isHidden = true

        
        
        
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print("Card number: \(textField.cardParams.number) Exp Month: \(textField.cardParams.expMonth) Exp Year: \(textField.cardParams.expYear) CVC: \(textField.cardParams.cvc)")
        self.btnBuy.isEnabled = textField.isValid
        
    
        
        if btnBuy.isEnabled {
            btnBuy.backgroundColor = UIColor.blue
            cardParams.number = textField.cardParams.number
            cardParams.expMonth = textField.cardParams.expMonth
            cardParams.expYear = textField.cardParams.expYear
            cardParams.cvc = textField.cardParams.cvc
        }
    }
    
    
    @IBAction func actionGetStripeToken() {
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // show the error to the user
                print(error)
                self.showAlertButtonTapped(strTitle: "Error", strMessage: error.localizedDescription)
            } else if let token = token {
                print(token)
                //Send token to backend for process
            }
        }
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- AlerViewController
    func showAlertButtonTapped(strTitle:String, strMessage:String) {
        // create the alert
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
