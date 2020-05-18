//
//  ViewController.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 30/01/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import UIKit

protocol ContactDetailsVCDelegate : class {
    func reloadTableView()
    func updateUI()
    func popVc()
    func setFavorite()
    func showNetworkErrorMessage(with error:HTTPError)
    func setImage(sender : UIButton)
}

protocol ContactDetailsTableCellDelegate : class {
    func setCurrentTextField(textfield:UITextField)
    func setValue(with value:String , for textfield:UITextField)
}

enum OperationType {
    case save
    case edit
}
class ContactDetailViewController: UIViewController, ContactDetailsVCDelegate  {
    
    
    @IBOutlet weak var detailTableView: UITableView!
    let cellReuseIdentifier = "detailCell"
    var operationtype : OperationType = .edit
    @IBOutlet weak var headerView: HeaderView!
    var viewModel = ContactDetailViewModel(networkManager:NetworkManager(httpClient:HttpClient(session: URLSession(configuration: URLSessionConfiguration.default))),
                                           dataManager: Datamanager())
    var save : UIBarButtonItem?
    var edit : UIBarButtonItem?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.decorateView()
        headerView.delegate = self

        self.detailTableView?.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.detailTableView?.dataSource = viewModel
        self.detailTableView?.delegate = viewModel
        viewModel.delegate = self
        
        
        save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContact))
        save?.tintColor = UIColor(red: 83.0/255.0, green: 227.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        
        edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(saveContact))
        edit?.tintColor = UIColor(red: 83.0/255.0, green: 227.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        
        if(operationtype == .save) {
            navigationItem.rightBarButtonItems = [save!]
            
        } else {
            navigationItem.rightBarButtonItems = [edit!]
            viewModel.fetchContactDetails()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailViewController.keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailViewController.keyboardWasShown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func saveContact(){
        self.viewModel.currentTextField?.resignFirstResponder()
        if(operationtype == .edit) {
            viewModel.isEditing = !viewModel.isEditing
            print(viewModel.isEditing)
            navigationItem.rightBarButtonItems?[0] =  viewModel.isEditing ?   save! : edit!
            reloadTableView()
            //PUT the contact
            if (viewModel.isEditing == false) {
                let parameters: [String: Any] = [
                    "first_name":  viewModel.contactToSave.first_name as Any,
                    "last_name": viewModel.contactToSave.last_name as Any ,
                    "phone_number" : viewModel.contactToSave.phone_number as Any,
                    "email" : viewModel.contactToSave.email as Any,
                    "favorite" :  viewModel.contactToSave.favorite
                ]
                viewModel.updateContactDetails(with: parameters)
                
            }
            
            
        } else {
            //POST the contact
            
            let parameters: [String: Any] = [
                "first_name":  viewModel.contactToSave.first_name as Any,
                "last_name": viewModel.contactToSave.last_name as Any ,
                "phone_number" : viewModel.contactToSave.phone_number as Any,
                "email" : viewModel.contactToSave.email as Any,
                "favorite" :  viewModel.contactToSave.favorite
            ]
            viewModel.addContact(with: parameters)
            
        }
    }
    
    
    func setFavorite() {
        guard viewModel.isEditing else {
            return
        }
        self.viewModel.contactToSave.favorite  = !self.viewModel.contactToSave.favorite!
        print(self.viewModel.contactToSave.favorite!)
        headerView.contactToShow = self.viewModel.contactToSave
        headerView.decorateView()
    }
    
    
    func reloadTableView() {
        self.detailTableView.reloadData()
        
    }
    
    func updateUI() {
        headerView.contactToShow =  ContactToSave(first_name: self.viewModel.contactDetails?.first_name, last_name: self.viewModel.contactDetails?.last_name , email: self.viewModel.contactDetails?.email , phone_number: self.viewModel.contactDetails?.phone_number , profile_pic: "", favorite:   self.viewModel.contactDetails?.favorite)
        self.headerView.decorateView()
    }
    
    func popVc() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showNetworkErrorMessage(with error:HTTPError) {
        let messageString  = NSMutableString()
        for message in error.errors! {
            messageString.append(String(format: "\n%@", message))
        }
        
        let alert = UIAlertController(title: "Warning", message: messageString as String , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWasShown (notification: NSNotification)
    {
        print("keyboard was shown")
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        var contentInsets:UIEdgeInsets
        if UIApplication.shared.statusBarOrientation.isPortrait {
            contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize?.height)!, right: 0.0);
        }
        else {
            contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize?.width)!, right: 0.0);
        }
        detailTableView.contentInset = contentInsets
        detailTableView.scrollToRow(at: IndexPath(row: self.viewModel.currentTextField?.tag ?? 0 , section: 0), at: .top, animated: true)
        detailTableView.scrollIndicatorInsets = detailTableView.contentInset
    }
    
    func setImage(sender : UIButton) {
        guard  viewModel.isEditing else {
            return
        }
           let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
              alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                  self.openCamera()
              }))

              alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                  self.openGallary()
              }))

              alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

              /*If you want work actionsheet on ipad
              then you have to use popoverPresentationController to present the actionsheet,
              otherwise app will crash on iPad */
              switch UIDevice.current.userInterfaceIdiom {
              case .pad:
                  alert.popoverPresentationController?.sourceView = sender
                  alert.popoverPresentationController?.sourceRect = sender.bounds
                  alert.popoverPresentationController?.permittedArrowDirections = .up
              default:
                  break
              }

              self.present(alert, animated: true, completion: nil)
       }
       
     //MARK: - Open the camera
          func openCamera(){
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                  //If you dont want to edit the photo then you can set allowsEditing to false
                  imagePicker.allowsEditing = true
                  imagePicker.delegate = self
                  self.present(imagePicker, animated: true, completion: nil)
              }
              else{
                  let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
          }

       
       //MARK: - Choose image from camera roll
       func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           //If you dont want to edit the photo then you can set allowsEditing to false
           imagePicker.allowsEditing = true
           imagePicker.delegate = self
           self.present(imagePicker, animated: true, completion: nil)
       }
}

//MARK: - UIImagePickerControllerDelegate

extension ContactDetailViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   // private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    internal   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[.editedImage] as? UIImage{
            self.headerView.imageView.setBackgroundImage(editedImage, for: .normal)
            self.headerView.imageView.sizeToFit()
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
