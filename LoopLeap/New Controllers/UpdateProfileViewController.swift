//
//  UpdateProfileViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 14/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit

class UpdateProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, CountryListDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate
{
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var profileIconImg: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNummberView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTexttField: UITextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalView: UIView!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordView: UIView!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var makePublicProfileBtn: UIButton!
    @IBOutlet weak var enableDiaryModeBtn: UIButton!
    @IBOutlet weak var vitalInfoSwitchBtn: UISwitch!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    
    
    
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var selectedTxtFldTag = Int()
    var selectedMarriageTxtFld:UITextField?
    let kHeaderSectionTag: Int = 6900;
    var i: Int = 0
    var answeredQuestionsArray: Array<Any> = []
    var sectionItems: Array<Any> = []
    //let section  = headerView?.tag
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var filesArray = [GetAnswersObject]()
    var filesFinalArray = [GetAnswersObject]()
    
    //    var audioPlayer: AVAudioPlayer?
    //    var moviePlayer:MPMoviePlayerController!
    var currentIndex = Int()
    var sectionArray = ["", "Jobs:", "Girlfriend/Boyfriend:", "Marriages:" , "Social Media"]
    var statusArray = [false, false, false, false]
    
    var jobsArray = [Int]()
    var girlfriendArray =  [Int]()
    var marriageArray =  [Int]()
    
    var compressLabel = UIImageView()
    var switchStatus = Bool()
    var countryList = CountryList()
    var isCountryCode = Bool()
    var countryCode = String()
    var phoneExtension = String()
    var myPickerController = UIImagePickerController()
    var doneBool = Bool()
    var updateProfileObject = KeyHolderObject()
    var getProfileObject = KeyHolderObject()
    var makePublic = String()
    var diaryMode = String()
    var vitalInfo = ""
    
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getProfileApi()
        
        countryList.delegate = self
        countryCodeTextField.text =  "🇺🇸 +1"
        phoneExtension = "+1"
        showDatePicker()
        setUI()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //keyboardWillHide(notification: NSNotification.Name.UIKeyboardWillHide)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //profileTableView.reloadData()
        
    }
    
    func setUI()
    {
        profileIconImg.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: profileIconImg.frame.size.height/2)
        nameView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        emailView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        countryCodeView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        phoneNummberView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        dateView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        addressView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        cityView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        postalView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        countryView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        newPasswordView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        reEnterPasswordView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        submitBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: submitBtn.frame.size.height/2)
        // makePublicProfileBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: 2)
        // enableDiaryModeBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: 2)
        
    }
    
    func updateUI() {
        
        profileIconImg.sd_setImage(with: URL(string : getProfileObject.pro_pic_url), placeholderImage: UIImage(named: "place"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            
        }
        nameTextField.text = getProfileObject.name
        emailTextField.text = getProfileObject.email
        dateTextField.text = getProfileObject.dob
        countryCodeTextField.text = getProfileObject.country_code
        phoneTextField.text = getProfileObject.phone
        addressTexttField.text = getProfileObject.address_line_1
        cityTextField.text = getProfileObject.city
        postalTextField.text = getProfileObject.zip
        countryTextField.text = getProfileObject.country
        if getProfileObject.public_upon_death == "1" {
            
            makePublicProfileBtn.setImage(UIImage(named: "check"), for: .normal)
            
            
            
        }
            
        else  {
            
            makePublicProfileBtn.setImage(UIImage(named: "unchck"), for: .normal)
            
            
        }
        
        if getProfileObject.diary_mode == "1" {
            
            enableDiaryModeBtn.setImage(UIImage(named: "check"), for: .normal)
            
        }
            
        else {
            
            enableDiaryModeBtn.setImage(UIImage(named: "unchck"), for: .normal)
            
        }
        
        if getProfileObject.vital_information == "1" {
            
            vitalInfoSwitchBtn.isOn = true
            switchStatus = true
        }
            
        else {
            
            vitalInfoSwitchBtn.isOn = false
            switchStatus = false
            
        }
        
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            doneBool = false
        } else {
           
            let section = Int(textField.accessibilityLabel ?? "0")!
            
            if section == 3 {
            if let cell = profileTableView.cellForRow(at: IndexPath(row:textField.tag, section: 3)) as? UpdateProfileMarriageTableViewCell{
                
                if textField == cell.marriageDateTextField {
                    doneBool = true
                    selectedTxtFldTag = textField.tag
                }
                
            }
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let section = Int(textField.accessibilityLabel ?? "0")!
        
        if section == 3 {
            if let cell = profileTableView.cellForRow(at: IndexPath(row:textField.tag, section: 3)) as? UpdateProfileMarriageTableViewCell{
                
                if textField == cell.marriageDateTextField {
                    doneBool = true
                    selectedTxtFldTag = textField.tag
                }
                
            }
        }
        return true
    }
    
  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            let section = Int(textField.accessibilityLabel ?? "0")!
            
            if section == 0 {
                
                if textField.tag == 0 {
                    
                    self.getProfileObject.place_of_birth = updatedText
                    
                }
                    
                else  if textField.tag == 1 {
                    self.getProfileObject.elementry_school = updatedText
                    
                }
                else  if textField.tag == 2 {
                    self.getProfileObject.middle_school = updatedText
                    
                }
                else  if textField.tag == 3 {
                    self.getProfileObject.high_school = updatedText
                    
                }
                else  if textField.tag == 4 {
                    self.getProfileObject.college = updatedText
                    
                }
                    
                else  if textField.tag == 5 {
                    self.getProfileObject.grad_school = updatedText
                    
                }
                
                
                
            }
                
            else if section  == 1 {
                
                self.getProfileObject.first_job[textField.tag] = updatedText
                
            } else if section == 2 {
                
                self.getProfileObject.partners[textField.tag] = updatedText
                
            } else if section == 3 {
                
                if let cell = profileTableView.cellForRow(at: IndexPath(row:textField.tag, section: 3)) as? UpdateProfileMarriageTableViewCell{
                    
                    if textField == cell.marriedToTextField {
                         self.getProfileObject.marriage_to[textField.tag] = updatedText
                    }
                   
                }
                
                
            }
                
            else if section == 4 {
                
                if textField.tag == 0 {
                    
                    self.getProfileObject.facebook = updatedText
                    
                }
                    
                else  if textField.tag == 1 {
                    self.getProfileObject.instagram = updatedText
                    
                }
                else  if textField.tag == 2 {
                    self.getProfileObject.snapchat = updatedText
                    
                }
                else  if textField.tag == 3 {
                    self.getProfileObject.twitter = updatedText
                    
                }
                else  if textField.tag == 4 {
                    self.getProfileObject.linkedin = updatedText
                    
                }
                
                
                
            }
        }
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        
        if let text1 = textView.text,
            let textRange = Range(range, in: text1) {
            let updatedText = text1.replacingCharacters(in: textRange,
                                                       with: text)
            
            let section = Int(textView.accessibilityLabel ?? "0")!
            if section  == 4 {
                
                if textView.tag == 5 {
                    self.getProfileObject.about_me = updatedText
                    
                }
                
            }
            
        }
        
        return true
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
    
    @IBAction func profileBtnAction(_ sender: Any) {
        
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        
        isCountryCode = true
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        updateProfileApi()
        
    }
    
    @IBAction func dateBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func countryBtnAction(_ sender: Any) {
        
        isCountryCode = false
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func vitalSwitchBtnAction(_ sender: UISwitch) {
        
        if vitalInfoSwitchBtn.isOn {
            
            switchStatus = true
            vitalInfo = "1"
            
        }
            
        else {
            
            switchStatus = false
            vitalInfo = ""
            
            
            
        }
        
        
        DispatchQueue.main.async {
            self.profileTableView.reloadData()
            
        }
        
    }
    
    @IBAction func cancelToolButtonAction(_ sender: UIBarButtonItem)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if doneBool {
            
            
            let indexPath = IndexPath(row: selectedTxtFldTag, section: 3)
            let cell = profileTableView.cellForRow(at: indexPath) as? UpdateProfileMarriageTableViewCell
            
            cell?.marriageDateTextField.text = formatter.string(from: datePicker.date)
            
            getProfileObject.marriage_date[selectedTxtFldTag] = (cell?.marriageDateTextField.text)!
     
            
        }
            
        else {
            
            dateTextField.text = formatter.string(from: datePicker.date)
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        
    }
    
    @IBAction func makePublicBtnAction(_ sender: Any) {
        
        if makePublicProfileBtn.currentImage == UIImage(named: "unchck") {
            
            makePublicProfileBtn.setImage(UIImage(named: "check"), for: .normal)
            makePublic = "1"
        }
            
        else {
            
            makePublicProfileBtn.setImage(UIImage(named: "unchck"), for: .normal)
            makePublic = "0"
            
            
        }
        
        
    }
    
    @IBAction func enableDiaryModeBtnAction(_ sender: Any) {
        
        
        if enableDiaryModeBtn.currentImage == UIImage(named: "unchck") {
            
            enableDiaryModeBtn.setImage(UIImage(named: "check"), for: .normal)
            diaryMode = "1"
        }
            
        else {
            
            enableDiaryModeBtn.setImage(UIImage(named: "unchck"), for: .normal)
            diaryMode = "0"
            
        }
        
    }
    
    
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showDatePicker()
    {
        //Formate Date
        datePicker.datePickerMode = .date
        dateTextField.inputView = pickerInputView
        dateTextField.inputAccessoryView = nil
        datePicker.maximumDate = Date()
        
    }
    
    @objc func showMarriageDatePicker(cell: UpdateProfileMarriageTableViewCell)
    {
        //Formate Date
        datePicker.datePickerMode = .date
        cell.marriageDateTextField.inputView = pickerInputView
        cell.marriageDateTextField.inputAccessoryView = nil
        datePicker.maximumDate = Date()
        
    }
    
    //MARK:-
    //MARK:- Country Delegate
    func selectedCountry(country: Country) {
        
        if isCountryCode {
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
            // countryTextField.text = "\(country.name!)"
            phoneExtension = "+\(country.phoneExtension)"
        }
        else {
            countryTextField.text = "\(country.name!)"
            //  countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
            countryCode = country.countryCode
        }
    }
    
    
    //MARK:-
    //MARK:- ImagePicker Delegate
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage] as [String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileIconImg.image = image
        self.dismiss(animated: false) {
            
        }
        
    }
    
    
    //MARK:-
    //MARK:- Tableview  Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        print(section)
        switch section {
            
        case 0:
            
            if switchStatus {
                return 1
                
            }
                
            else {
                
                return 0
            }
        case 1:
            return  getProfileObject.first_job.count
        case 2:
            return   getProfileObject.partners.count
        case 3:
            
            if getProfileObject.marriage_date.count > getProfileObject.marriage_to.count {
                
                return  getProfileObject.marriage_date.count
                
            }
                
            else if getProfileObject.marriage_to.count > getProfileObject.marriage_date.count {
                
                return  getProfileObject.marriage_date.count
                
                
            }
                
            else {
                return getProfileObject.marriage_date.count
                
            }
            
        case 4:
            
            if switchStatus {
                return 1
                
            }
                
            else {
                
                return 0
            }
        default:
            break
        }
        
        
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if switchStatus {
            return UITableViewAutomaticDimension
            
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"UpdateProfilePlaceofBirthTableViewCell", for: indexPath) as! UpdateProfilePlaceofBirthTableViewCell
            
            
            cell.placeofBirthTextField.accessibilityLabel = "\(indexPath.section)"
            cell.elementarySchoolTextField.accessibilityLabel = "\(indexPath.section)"
            cell.middleSchoolTextField.accessibilityLabel = "\(indexPath.section)"
            cell.highSchoolTextField.accessibilityLabel = "\(indexPath.section)"
            cell.collegeTextField.accessibilityLabel = "\(indexPath.section)"
            cell.gradCollegeField.accessibilityLabel = "\(indexPath.section)"
            
            
            cell.placeofBirthTextField.tag = 0
            cell.elementarySchoolTextField.tag = 1
            cell.middleSchoolTextField.tag = 2
            cell.highSchoolTextField.tag = 3
            cell.collegeTextField.tag = 4
            cell.gradCollegeField.tag = 5
            
            
            cell.placeofBirthTextField.text = getProfileObject.place_of_birth
            cell.elementarySchoolTextField.text = getProfileObject.elementry_school
            cell.middleSchoolTextField.text = getProfileObject.middle_school
            cell.highSchoolTextField.text = getProfileObject.high_school
            cell.collegeTextField.text = getProfileObject.college
            cell.gradCollegeField.text = getProfileObject.grad_school
            
            return cell
            
        }
            
            
        else  if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"UpdateProfileMarriageTableViewCell", for: indexPath) as! UpdateProfileMarriageTableViewCell
            
            cell.marriageDateTextField.tag = indexPath.row
            cell.marriageDateTextField.accessibilityLabel = "\(indexPath.section)"
            cell.marriedToTextField.tag = indexPath.row
            cell.marriedToTextField.accessibilityLabel = "\(indexPath.section)"
            
            
            cell.marriageDateTextField.text = getProfileObject.marriage_date[indexPath.row]
            cell.marriedToTextField.text = getProfileObject.marriage_to[indexPath.row]
            
            showMarriageDatePicker(cell: cell)
            
            
            
            return cell
            
        }
            
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"UpdateProfileSocialTableViewCell", for: indexPath) as! UpdateProfileSocialTableViewCell
            
            cell.facebookTextField.accessibilityLabel = "\(indexPath.section)"
            cell.instagramTextField.accessibilityLabel = "\(indexPath.section)"
            cell.snapchatTextField.accessibilityLabel = "\(indexPath.section)"
            cell.twitterTextField.accessibilityLabel = "\(indexPath.section)"
            cell.linkedinTextField.accessibilityLabel = "\(indexPath.section)"
            cell.aboutTextView.accessibilityLabel = "\(indexPath.section)"
            
            
            
            
            cell.facebookTextField.tag = 0
            cell.instagramTextField.tag = 1
            cell.snapchatTextField.tag = 2
            cell.twitterTextField.tag = 3
            cell.linkedinTextField.tag = 4
            cell.aboutTextView.tag = 5
            
            
            cell.facebookTextField.text = getProfileObject.facebook
            cell.instagramTextField.text = getProfileObject.instagram
            cell.snapchatTextField.text = getProfileObject.snapchat
            cell.twitterTextField.text = getProfileObject.twitter
            cell.linkedinTextField.text = getProfileObject.linkedin
            cell.aboutTextView.text = getProfileObject.about_me
            
            
            
            return cell
        }
            
            
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier:"UpdateProfileTableViewCell", for: indexPath) as! UpdateProfileTableViewCell
            
            cell.cellTextField.tag = indexPath.row
            cell.cellTextField.accessibilityLabel = "\(indexPath.section)"
            if indexPath.section == 1 {
                
                
                cell.cellTextField.text = getProfileObject.first_job[indexPath.row]
                
                
                
            }
                
            else if indexPath.section == 2 {
                
                cell.cellTextField.text = getProfileObject.partners[indexPath.row]
                
            }
            
            
            return cell
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAtindexPath: IndexPath) {
        //questionsListTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 0
        }
        else {
            
            if switchStatus {
                return 40
            }
            else {
                return 0
                
            }
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        if switchStatus {
            
            let obj = sectionArray[section]
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
            // headerView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8352941176, blue: 0.831372549, alpha: 1)
            
            let size =  CGSize(width:(sectionArray[section] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name:"Raleway", size: 15)]).width + 10, height: 40)
            
            print(size)
            let label = UILabel(frame: CGRect(x: 27, y: 8, width: size.width , height: 24))
            label.font = UIFont(name:"Raleway", size: 15)
            // label.numberOfLines = 2
            label.text = obj
            let expandLbl = UIButton(frame: CGRect(x:  label.frame.size.width + label.frame.origin.x + 5 , y: 8, width:20, height: 24))
            expandLbl.contentMode = .scaleAspectFit
            expandLbl.tintColor = .black
            //if statusArray[section] {
            expandLbl.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
            expandLbl.addTarget(self, action:#selector(expandSectionAction), for: .touchUpInside)
            
            expandLbl.tag = section
            
            // }
            //        else {
            //          expandLbl.image  = #imageLiteral(resourceName: "expand")
            //        }
            
            let deleteImg = UIButton(frame: CGRect(x: headerView.frame.origin.x + headerView.frame.size.width - 40 , y: 8, width:20, height: 24))
            deleteImg.contentMode = .scaleAspectFit
            deleteImg.tintColor = .black
            deleteImg.setImage(#imageLiteral(resourceName: "collapse"), for: .normal)
            deleteImg.addTarget(self, action:#selector(collapseSectionAction), for: .touchUpInside)
            deleteImg.tag = section
            
            headerView.addSubview(label)
            headerView.addSubview(expandLbl)
            headerView.addSubview(deleteImg)
            switch section {
                
            case 0:
                expandLbl.isHidden = true
                deleteImg.isHidden = true
                
            case 1:
                deleteImg.isHidden = true
            case 2:
                if getProfileObject.first_job.count > 0 {
                    deleteImg.isHidden = false
                } else {
                    deleteImg.isHidden = true
                }
            case 3:
                if getProfileObject.partners.count > 0 {
                    deleteImg.isHidden = false
                } else {
                    deleteImg.isHidden = true
                }
            case 4:
                if getProfileObject.marriage_to.count > 0 || getProfileObject.marriage_date.count > 0 {
                    deleteImg.isHidden = false
                } else {
                    deleteImg.isHidden = true
                }
                expandLbl.isHidden = true
            default:
                break
            }
            
            headerView.tag = section
            headerView.isUserInteractionEnabled = true
            
            //   let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
            //  headerView.addGestureRecognizer(tapgesture)
            return headerView
        }
        else {
            return UIView()
        }
    }
    
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionArray
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
            self.profileTableView!.beginUpdates()
            self.profileTableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.profileTableView!.endUpdates()
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
            self.profileTableView!.beginUpdates()
            self.profileTableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.profileTableView!.endUpdates()
        }
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view
        let section    = headerView?.tag
        
        
        
        
        
    }
    
    @objc func expandSectionAction(sender: UIButton!) {
        
        
        //  let headerView = sender.view
        //let section    = headerView?.tag
        
        
        if sender.tag == 1 {
            
            // jobsArray.count += 1
            if getProfileObject.first_job.count < 10 {
                getProfileObject.first_job.append("")
                print(jobsArray.count)
                
            }
        }
            
        else if sender.tag == 2{
            
            if getProfileObject.partners.count < 10 {
                getProfileObject.partners.append("")
                print(girlfriendArray.count)
            }
            
        }
            
        else if sender.tag == 3{
            
            if getProfileObject.marriage_date.count < 10 && getProfileObject.marriage_to.count < 10  {
                getProfileObject.marriage_to.append("")
                getProfileObject.marriage_date.append("")
                print(marriageArray.count)
                
            }
            
        }
        
        profileTableView.reloadData()
        
        
        
    }
    
    @objc func collapseSectionAction(sender: UIButton!) {
        
        
        if sender.tag == 2 {
            
            getProfileObject.first_job.removeLast()
            print(jobsArray.count)
        }
            
        else if sender.tag == 3{
            
            getProfileObject.partners.removeLast()
            print(girlfriendArray.count)
            
            
        }
            
        else if sender.tag == 4 {
            
            getProfileObject.marriage_to.removeLast()
            getProfileObject.marriage_date.removeLast()
            
            print(marriageArray.count)
            
            
            
        }
        
        profileTableView.reloadData()
        
        
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func getProfileApi() {
        
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.settings, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        ProjectManager.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        print(json)
                        let status = json["status"] as? Int
                        if status == 1{
                            if let data = json["data"] as? [String : Any] {
                                
                                self.getProfileObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                
                                self.updateUI()
                                self.profileTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                            
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                        }
                }
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
        }
        
    }
    
    
    
    
    func updateProfileApi() {
        
        let name:String = (nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let countryCode:String = (countryCodeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dob:String = (dateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTexttField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let city:String = (cityTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let zip:String = (postalTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let country:String = (countryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let newPassword:String = (newPasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let confirmPassword:String = (reEnterPasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        
        self.view.endEditing(true)
        
        if name.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if name.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
        }
        else if countryCode.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country code", vc: self)
        }
        else if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone number", vc: self)
        }
        else if phone.count < 8 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters phone number", vc: self)
        }
        else  if dob.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select date of birth", vc: self)
        }
        else  if address.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
        }
        else if city.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter city", vc: self)
        }
        else if zip.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter postal/zip code", vc: self)
        }
            
        else if country.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
            
            
        else {
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {

//                if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
//                {
//                    let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
//                    //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
//                    let headers = [
//                        "Authorization": token_type + accessToken,
//                        "Accept": "application/json"
//                    ]
            
                    let str =  countryCode
                    let split = str.split(separator: " ")
                    let codeNumber    = String(split.suffix(1).joined(separator: [" "]))
                    print(codeNumber)
                    
                    
                    var parameters = [String: Any]()
                    
                    if vitalInfo == "1" {
                    parameters = ["name":name , "email": email, "dob":dob,"phone_code":codeNumber,"phone":phone,"address":address, "city":city, "zip":zip, "country":country, "password":newPassword, "password_confirmation":confirmPassword,"enable_diary_mode":diaryMode,"make_public":makePublic,"enable_email":email,"enable_phone":phone, "place_of_birth":getProfileObject.place_of_birth, "elementry_school":getProfileObject.elementry_school, "middle_school":getProfileObject.middle_school , "high_school":getProfileObject.high_school ,"grad_school":getProfileObject.grad_school ,"college":getProfileObject.college ,"first_job":getProfileObject.first_job ,"partners":getProfileObject.partners,"marriage_date":getProfileObject.marriage_date ,"marriage_to":getProfileObject.marriage_to,"facebook":getProfileObject.facebook, "instagram":getProfileObject.instagram ,"snapchat":getProfileObject.snapchat ,"twitter":getProfileObject.twitter , "linkedin":getProfileObject.linkedin ,"about_me":getProfileObject.about_me, "additional_deatils":vitalInfo]
                        
                    }
                    
                    else {
                    
                     parameters = ["name":name , "email": email, "dob":dob,"phone_code":codeNumber,"phone":phone,"address":address, "city":city, "zip":zip, "country":country, "password":newPassword, "password_confirmation":confirmPassword,"enable_diary_mode":diaryMode,"make_public":makePublic,"enable_email":email,"enable_phone":phone, "place_of_birth":getProfileObject.place_of_birth, "elementry_school":getProfileObject.elementry_school, "middle_school":getProfileObject.middle_school , "high_school":getProfileObject.high_school ,"grad_school":getProfileObject.grad_school ,"college":getProfileObject.college ,"first_job":getProfileObject.first_job ,"partners":getProfileObject.partners ,"marriage_date":getProfileObject.marriage_date ,"marriage_to":getProfileObject.marriage_to ,"facebook":getProfileObject.facebook, "instagram":getProfileObject.instagram ,"snapchat":getProfileObject.snapchat ,"twitter":getProfileObject.twitter , "linkedin":getProfileObject.linkedin ,"about_me":getProfileObject.about_me]
                        
                    }
                    
                    print(parameters)
                    
                    let imgParam = "change_profile_pic"
            
//
//
//
//
////            Alamofire.request(baseURL + ApiMethods.settings, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
////                .responseJSON { response in
////
////                    ProjectManager.sharedInstance.stopLoader()
////
////                    // check for errors
////                    guard response.result.error == nil else {
////                        // got an error in getting the data, need to handle it
////                        print("error calling GET on /todos/1")
////                        print(response.result.error!)
////                        return
////                    }
////
////                    // make sure we got some JSON since that's what we expect
////                    guard let json = response.result.value as? [String: Any] else {
////                        print("didn't get todo object as JSON from API")
////                        if let error = response.result.error {
////                            print("Error: \(error)")
////                        }
////                        return
////                    }
////
////                    print(json)
////                    let status = json["status"] as? Int
////                    if status == 1{
////                        if let data = json["data"] as? [String: Any] {
////
////
////
////
////                        }
////                        else{
////
////                        }
////
////                    }
////                    else {
////                        self.navigationController?.popViewController(animated: true)
////                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "PendingKeyHolders not found", vc: UIApplication.topViewController()!)
////
////                    }
////            }
//
//               // }
//
//            //}
//
//
//
//
//
//                     ProjectManager.sharedInstance.showLoader()
//
//                    Alamofire.upload(multipartFormData: { (multipartFormData) in
//                        DispatchQueue.main.async {
//                           multipartFormData.append(UIImageJPEGRepresentation(self.profileIconImg.image!, 0.4)!, withName: "change_profile_pic", fileName: "profile.jpeg", mimeType: "image/jpeg")
//
//                        }
//                        for (key, value) in parameters {
//
//                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//
//                        }
//                    }, to:baseURL + ApiMethods.settings, headers: headers)
//                    { (result) in
//
//                        ProjectManager.sharedInstance.stopLoader()
//
//                        switch result {
//                        case .success(let upload, _,_ ):
//
//                            upload.uploadProgress(closure: { (progress) in
//                                //Print progress
//                            })
//
//                            upload.responseJSON { response in
//                                //print response.result
//
//                                print(response.result)
//                                print(response.result.value)
//
//
//
//
//                                if let json = (response.result.value)! as? [String:Any] {
//
//                                    print(json)
//
//                                    let status = json["status"] as? NSNumber
//                                    if status  == 1 {
//
//                                        if let data = json["data"] as? [String:Any] {
//
//                                    self.updateProfileObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
//
//                                    print(self.updateProfileObject)
//
//                                    let message = json["message"] as? String
//
//
//                                    if self.getProfileObject.email == email && self.getProfileObject.phone == phone  {
//
//                                        let alertController = UIAlertController(title:"", message: message, preferredStyle: .alert)
//
//                                        // Create OK button
//                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//
//                                            self.dismiss(animated: true, completion: nil)
//                                        }
//                                        alertController.addAction(OKAction)
//
//                                        // Present Dialog message
//                                        self.present(alertController, animated: true, completion:nil)
//
//                                    }
//
//
//                                    else {
//
//                                        let msg = json["message"] as? String
//                                        let alertController = UIAlertController(title:"", message: msg, preferredStyle: .alert)
//
//                                        // Create OK button
//                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//
//
//
//                                            let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
//
//                                            alertVC.profileObject = self.updateProfileObject
//                                            alertVC.profileBool = true
//                                            alertVC.profile_pic = self.profileIconImg.image!
//
//
//                                            let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                            , tapGestureDismissal: false, panGestureDismissal: false) {
//                                                let overlayAppearance = PopupDialogOverlayView.appearance()
//                                                overlayAppearance.blurRadius  = 30
//                                                overlayAppearance.blurEnabled = true
//                                                overlayAppearance.liveBlur    = false
//                                                overlayAppearance.opacity     = 0.4
//                                            }
//
//                                            alertVC.verifyAction = {
//
////                                                popup.dismiss({
////
////                                                    // self.navigationController?.popViewController(animated: true)
////
////                                                })
//
//                                            }
//
//                                            alertVC.noAction = {
//
//                                                popup.dismiss({
//
//                                                    // self.navigationController?.popViewController(animated: true)
//
//                                                })
//
//
//                                            }
//                                            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//                                        }
//
//                                        alertController.addAction(OKAction)
//                                        // Present Dialog message
//                                        self.present(alertController, animated: true, completion:nil)
//
//                                    }
//
//                                }
//
//                                        else {
//
//                                            let msg = json["message"] as? String
//                                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
//                                        }
//
//                                }
//
//                                    else {
//
//                                        let msg = json["message"] as? String
//                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
//                                    }
//
//                                }
//
//
//
//
//
//                            }
//
//                        case .failure(let encodingError): break
//                            //print encodingError.description
//                        }
//                    }
//
//                }
//
//            }
    
//            else {
//                DispatchQueue.main.async(execute: {
//
//                    ProjectManager.sharedInstance.stopLoader()
//                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
//                })
//            }
            
       // }
    
            
            
//                        if ProjectManager.sharedInstance.isInternetAvailable()
//                        {
                            ProjectManager.sharedInstance.showLoader()

                            ProjectManager.sharedInstance.callApiWithParameters(params:parameters , url:baseURL + ApiMethods.settings, image: profileIconImg.image, imageParam:imgParam) { (response, error) in
                                ProjectManager.sharedInstance.stopLoader()


                                if response != nil {
                                    if let status = response?["status"] as? NSNumber {
                                        if status == 1 {
                                            print(response!)
                                            if let data = response?["data"] as? [String: Any] {

                                                self.updateProfileObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)

                                                print(self.updateProfileObject)

                                                 let message = response?["message"] as? String


                                                if self.getProfileObject.email == email //&& self.getProfileObject.phone == phone
                                                {

                                                    let alertController = UIAlertController(title:"", message: message, preferredStyle: .alert)

                                                    // Create OK button
                                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

                                                        self.dismiss(animated: true, completion: nil)
                                                    }
                                                    alertController.addAction(OKAction)

                                                    // Present Dialog message
                                                    self.present(alertController, animated: true, completion:nil)

                                                }


                                                else {

                                                let msg = response?["message"] as? String
                                                let alertController = UIAlertController(title:"", message: msg, preferredStyle: .alert)

                                                // Create OK button
                                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in



                                                    let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!

                                                    alertVC.profileObject = self.updateProfileObject
                                                    alertVC.profileBool = true
                                                    alertVC.profile_pic = self.profileIconImg.image!


                                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                                    , tapGestureDismissal: false, panGestureDismissal: false) {
                                                        let overlayAppearance = PopupDialogOverlayView.appearance()
                                                        overlayAppearance.blurRadius  = 30
                                                        overlayAppearance.blurEnabled = true
                                                        overlayAppearance.liveBlur    = false
                                                        overlayAppearance.opacity     = 0.4
                                                    }

                                                    alertVC.verifyAction = {

//                                                        popup.dismiss({
//
//                                                            // self.navigationController?.popViewController(animated: true)
//
//                                                        })


                                                    }

                                                    alertVC.noAction = {

                                                        popup.dismiss({

                                                            // self.navigationController?.popViewController(animated: true)

                                                        })


                                                    }
                                                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)

                                                }

                                                alertController.addAction(OKAction)
                                                // Present Dialog message
                                                self.present(alertController, animated: true, completion:nil)

                                            }

                                            }

                                            else {

                                                let msg = response?["message"] as? String
                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                            }

                                        }
                                        else {

                                            let msg = response?["message"] as? String
                                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)

                                        }
                                    }
                                }

                                else {

                                    let msg = response?["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)

                                }
                            }
                        }
            
                        else {
                            DispatchQueue.main.async(execute: {

                                ProjectManager.sharedInstance.stopLoader()
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                            })
            }

        }
    
    
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
