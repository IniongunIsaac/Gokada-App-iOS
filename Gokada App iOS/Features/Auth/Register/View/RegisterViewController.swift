//
//  RegisterViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 24/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities
import RSKImageCropper

class RegisterViewController: BaseViewController {

    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentUser: User!
    
    //var keyboardHeight: CGFloat!
    var keyboardActive = false
    
    var registerViewModel: IRegisterViewModel?
    var profileImage = ""
    
    override func getViewModel() -> BaseViewModel {
        return self.registerViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUploadBtn()
        
        self.phoneField.text = currentUser.phoneNumber?.replacingOccurrences(of: "+234", with: "+234 - ")
        
        configureBinding()
        
        addScrollViewListener(constraint: scrollViewBottomConstraint)
    }
    
    func configureBinding() {
        registerViewModel?.registerResponse.bind { [weak self] res in
            self?.performSegue(withIdentifier: "showProfile", sender: self)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func selectProfileImage(_ sender: UIButton) {
        self.configureActionSheet()
    }
    
    @IBAction func createAccountBtnClicked(_ sender: UIButton) {
        var profileDetails = [String: String]()
        profileDetails[AuthRequestKeyConstants.FIRST_NAME_KEY] = firstNameField.text
        profileDetails[AuthRequestKeyConstants.LAST_NAME_KEY] = lastNameField.text
        profileDetails[AuthRequestKeyConstants.EMAIL_ADDRESS_KEY] = emailField.text
        profileDetails[AuthRequestKeyConstants.PROFILE_IMAGE_KEY] = profileImage
        profileDetails[AuthRequestKeyConstants.PROFILE_IMAGE_NAME_KEY] = getProfileImageName()
        registerViewModel?.registerUser(profileDetails: profileDetails)
    }
    
    func configureUploadBtn() {
        uploadBtn.titleLabel?.numberOfLines = 0
        uploadBtn.titleLabel?.lineBreakMode = .byWordWrapping
        uploadBtn.titleLabel?.textAlignment = .center
    }

}

extension RegisterViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension RegisterViewController: RSKImageCropViewControllerDelegate, UIImagePickerControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profileImageView.image = croppedImage
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        var imageCropVC: RSKImageCropViewController!
        imageCropVC = RSKImageCropViewController(image: selectedImage, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.7)
        self.profileImage = imageData!.base64EncodedString()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func profileImageFromCamera() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    func profileImageFromibrary() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    func configureActionSheet() {
        let alertController = UIAlertController(title: "Select Source", message: "Select the source to select a profile image", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.profileImageFromCamera()
        }
        let library = UIAlertAction(title: "Library", style: .default) { (action) in
            self.profileImageFromibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(camera)
        alertController.addAction(library)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
