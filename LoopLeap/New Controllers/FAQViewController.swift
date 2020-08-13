//
//  FAQViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 13/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var faqTableView: UITableView!
    
    var sectionArray = ["How secure is my information?", "Will you sell or share my personal information with anyone?", "Can I create my own directories?", "Can I move files between directories?", "Can I edit uploaded content?"]
    var statusArray = [false, false, false, false,false]
     var cellArray = [" Security is our highest priority, so all information uploaded to your private vault will be encrypted so nobody, including us, can see it. We cannot see your login information either.", " We have no plans to sell or share any personal information. We might from time to time use your contact information internally to contact our users with updates.", "Yes, you can create new directories and name them anything you like", "Yes", "You can not edit the content but you can delete or replace files in any directory"]
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableContainerView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 4)
        faqTableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
            if role  == 6 {
                
                
                sideMenuController?.setContentViewController(with: "\(11)", animated: Preferences.shared.enableTransitionAnimation)
                
            }
                
            else {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
            }
                
            }
            
                
            else {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
                
                
            }
            
            
        }
            
        else {
            
            sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
            
            
            
        }
        
        sideMenuController?.hideMenu()
        
    }
    
    //MARK:-
    //MARK:- TableView DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
           return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if statusArray[section] {
            return 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return
        UITableViewAutomaticDimension 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        
        cell.cellLabel.text = cellArray[indexPath.section]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 52
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let obj = sectionArray[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 58))
       // headerView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8352941176, blue: 0.831372549, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10, y: 3, width: headerView.frame.size.width - 40, height: 50))
        label.numberOfLines = 2
        label.text = obj
       // label.font = "ra"
        let expandLbl = UIImageView(frame: CGRect(x:  label.frame.size.width + label.frame.origin.x + 5 , y: 3, width:20, height: 50))
        expandLbl.contentMode = .scaleAspectFit
        expandLbl.tintColor = .black
        if statusArray[section] {
            expandLbl.image  = #imageLiteral(resourceName: "dropup")
        }
        else {
            expandLbl.image  = #imageLiteral(resourceName: "dropdown")
        }
        headerView.addSubview(label)
        headerView.addSubview(expandLbl)
        headerView.tag = section
        headerView.isUserInteractionEnabled = true
//        let line = UIView(frame: CGRect(x: 0, y: 56.5, width: tableView.bounds.size.width, height: 1.5))
//        line.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.7450980392, blue: 0.7490196078, alpha: 1)
//        headerView.addSubview(line)
        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        headerView.addGestureRecognizer(tapgesture)
        return headerView
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionArray[section]
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.faqTableView!.beginUpdates()
            self.faqTableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.faqTableView!.endUpdates()
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionArray[section]
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.faqTableView!.beginUpdates()
            self.faqTableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.faqTableView!.endUpdates()
        }
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view
        let section    = headerView?.tag
        if statusArray[section!] {
            statusArray[section!] = false
        } else {
            statusArray[section!] = true
        }
       
        faqTableView.reloadData()
        
        
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
