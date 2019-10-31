//
//  EditProfileViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Kingfisher
import RSKImageCropper

class EditProfileViewController: BaseViewController {
    
    var editProfileViewModel: IEditProfileViewModel?
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var firstNameTextfield: TextFieldWithBorderAttributes!
    @IBOutlet weak var lastNameTextfield: TextFieldWithBorderAttributes!
    @IBOutlet weak var emailAddressTextfield: TextFieldWithBorderAttributes!
    @IBOutlet weak var profileImageView: ImageViewWithBorderAttributes!
    @IBOutlet weak var changeProfileLabel: UILabel!
    @IBOutlet weak var doneButton: ButtonWithBorderAttributes!
    @IBOutlet weak var parentScrollViewBottomConstraint: NSLayoutConstraint!
    
    var profileImage = ""
    
    override func getViewModel() -> BaseViewModel {
        return editProfileViewModel as! BaseViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileViewModel?.getUserDetails()
        
        bindUserDetails()
        
        bindUserProfileUpdateResponse()
        
        bindButtonTaps()
        
        addChangeProfileImageLabelTappedGesture()
        
        addScrollViewListener(constraint: parentScrollViewBottomConstraint)
    }
    
    fileprivate func bindUserDetails() {
        
        if let user = editProfileViewModel?.user {
            phoneNumberLabel.text = "\(user.phoneNumber!.dropLast(10)) - \(user.phoneNumber!.dropFirst(4))"
            firstNameTextfield.text = user.firstName!
            lastNameTextfield.text = user.lastName!
            emailAddressTextfield.text = user.email!
            
            if let profImg = user.profileImage {
                setImage(imageUrl: profImg)
            }
            
        }
    }
    
    fileprivate func bindUserProfileUpdateResponse() {
        editProfileViewModel?.profileUpdateResponse.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func bindButtonTaps() {
        
        doneButton.rx.tap.bind { [weak self] in
            
            var resquestBody = [
                AuthRequestKeyConstants.FIRST_NAME_KEY : self?.firstNameTextfield.text! ?? "",
                AuthRequestKeyConstants.LAST_NAME_KEY : self?.lastNameTextfield.text! ?? "",
                AuthRequestKeyConstants.EMAIL_ADDRESS_KEY : self?.emailAddressTextfield.text! ?? "",
            ]
            
            if !(self?.profileImage.isEmpty ?? true) {
                resquestBody[AuthRequestKeyConstants.PROFILE_IMAGE_KEY] = self?.profileImage ?? ""
                resquestBody[AuthRequestKeyConstants.PROFILE_IMAGE_NAME_KEY] = getProfileImageName()
            }
            
            self?.editProfileViewModel?.updateUserDetails(requestBody: resquestBody)
            
        }.disposed(by: disposeBag)
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
    }
    
    fileprivate func addChangeProfileImageLabelTappedGesture() {
        changeProfileLabel.addTapGesture { [weak self] in
            self?.showProfileImageActionSheet()
        }
    }
    
    fileprivate func setImage(imageUrl: String) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "profile_image_icon"),
            options: [.transition(.fade(0.2)), .processor(processor)]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension EditProfileViewController: RSKImageCropViewControllerDelegate, UIImagePickerControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profileImageView.image = croppedImage
        let imageData = croppedImage.jpegData(compressionQuality: 0.7)
        self.profileImage = imageData!.base64EncodedString()
        
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
    
    func showProfileImageActionSheet() {
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
