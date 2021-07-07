//
//  ProfileViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    //MARK:- Varaiables
    let imagePicker = ImagePicker()
    var titleArr = ["Personal Details", "Work Details", "Income Details", "Banking Details"]
    
    enum Detail: String {
       case Personal = "Personal Details"
       case Work = "Work Details"
       case Income = "Income Details"
       case Banking = "Banking Details"
    }

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataSetup()
    }
    
    func dataSetup() {
        if let appUser = AppUser.shared {
            if let url = URL(string: appUser.profileURL) {
                self.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        self.imagePicker.delegate = self
        self.imagePicker.showImagePicker(self)
    }
}

//MARK:- Image Picker Delegates
extension ProfileViewController: ImagePickerDelegate{
  
    func didFinishPickingImage(_ info: AnyObject?) {
        if (info != nil) {
            if let image = info![UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageURL = info![UIImagePickerController.InfoKey.imageURL] as? URL {
                
                OptionAlertView.show(self, title: "Update Profile Image", message: "Are you sure you want to update profile image?") { (action) in
                    if action == "Yes" {
                        self.userImageView.image = image
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            self.requestToUpdateProfileImage(imageData, fileName: self.randomString())
                        }
                    }
                }
            }
        }
    }
}

//MARK:- Table View Delegate And Data Source
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.titleLabel.text = self.titleArr[indexPath.row]
        
        cell.completion = { (title) in
            let detail = Detail.init(rawValue: title)
            self.editButtonTapped(detail!)
        }
        
        return cell
    }
    
    func editButtonTapped(_ detail: Detail) {
        
        switch detail {
        case .Personal:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "PersonalDetailsViewController") as! PersonalDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case .Work:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "WorkDetailsViewController") as! WorkDetailsViewController
            vc.isForUpdate = true
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case .Income:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "IncomeDetailsViewController") as! IncomeDetailsViewController
            vc.isForUpdate = true
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case .Banking:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "BankingDetailsViewController") as! BankingDetailsViewController
            vc.isForUpdate = true
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            print("Default")
        }
    }
}

//MARK:- APIs
extension ProfileViewController {
    func requestToUpdateProfileImage(_ imageData: Data, fileName: String) {
        let param = [
                        "user_id": AppUser.shared.id!
                    ]
            
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithDataWithoutHeader(URLConstant.updateProfileImage, params: param, fileData: imageData, fileKey: "image_url", fileName: fileName) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "Loggin User")
                        
                        let appUser = AppUser(data)
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                    }
                }else {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
