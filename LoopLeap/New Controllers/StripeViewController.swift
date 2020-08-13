//
//  StripeViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 08/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Stripe

class StripeViewController: UIViewController, STPAddCardViewControllerDelegate {
  
    
// let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
       
    }
        
  
    @IBAction func actionAddCardDefault(_ sender: Any) {
        
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//        // STPAddCardViewController must be shown inside a UINavigationController.
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        self.present(navigationController, animated: true, completion: nil)
        
         let vc:PaymentScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"PaymentScreenViewController") as! PaymentScreenViewController
        
        self.present(vc, animated: true, completion: nil)
       
        
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print(token)
        //Use token for backend process
        self.dismiss(animated: true, completion: {
            completion(nil)
        })
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
