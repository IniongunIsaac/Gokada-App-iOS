//
//  ProfileDetailsViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profileDetailsViewModel: IProfileDetailsViewModel?
    
    @IBOutlet weak var profileImageView: ImageViewWithBorderAttributes!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var editProfileButton: ButtonWithBorderAttributes!
    @IBOutlet weak var profileItemsTableView: UITableView!
    @IBOutlet weak var logoutView: UIView!
    
    override func getViewModel() -> BaseViewModel {
        return profileDetailsViewModel as! BaseViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileDetailsViewModel?.viewDidLoad1()
        
        profileItemsTableView.delegate = self
        profileItemsTableView.dataSource = self
        
        profileItemsTableView.rx.itemSelected.bind { indexPath in
            //remove grey background from table view cell upon selection using no animation
            self.profileItemsTableView.deselectRow(at: indexPath, animated: false)
        }.disposed(by: disposeBag)
        
        //setImage(imageUrl: "https://www.searchpng.com/wp-content/uploads/2019/02/Men-Profile-Image.png")
    
        navigationItem.title = "Account"
        
        //bindProfileItems()
        
        profileDetailsViewModel!.getLoggedInUserDetails()
        
        bindUserDetails()
        
        addTapListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileDetailsViewModel!.proItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemTableViewCell", for: indexPath) as! ProfileItemTableViewCell
        cell.profileItem = profileDetailsViewModel!.proItems[indexPath.row]

        return cell
    }
    
    fileprivate func addTapListeners() {
        
        logoutView.addTapGesture { [weak self] in
            self?.profileDetailsViewModel!.logUserOut()
            self?.view.window?.rootViewController?.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                self?.navigationController?.setViewControllers([vc], animated: true)
            }
        }
        
        editProfileButton.rx.tap.bind {
            //navigate to edit profile screen
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    fileprivate func bindUserDetails() {
        
        let user = profileDetailsViewModel!.user
        
        if let userImage = user?.profileImage {
            setImage(imageUrl: userImage)
        }

        if let fname = user?.firstName, let lname = user?.lastName {
            userFullNameLabel.text = "\(fname) \(lname)"
        } else {
            userFullNameLabel.text = "Nil Nil"
        }

        if let email = user?.email {
            userEmailLabel.text = email
        }
        
        print("Entered bindUserDetails()")
        
//        profileDetailsViewModel!
//            .userDetails?.asObservable()
        print(profileDetailsViewModel == nil)
        profileDetailsViewModel!
            .userDetails.asObservable()
            .bind { [weak self] user in

                print("gre0j0wfioh989ewu8wnoiv9j9jw99hv9wh9w9h9hw")

                if let userImage = user.profileImage {
                    self?.setImage(imageUrl: userImage)
                }

                if let fname = user.firstName, let lname = user.lastName {
                    self?.userFullNameLabel.text = "\(fname) \(lname)"
                } else {
                    self?.userFullNameLabel.text = "Nil Nil"
                }

                if let email = user.email {
                    self?.userEmailLabel.text = email
                }

        }
        .disposed(by: disposeBag)
        
        print("Exited bindUserDetails()")
    }
    
    fileprivate func bindProfileItems() {
        profileDetailsViewModel?
            .profileItems
            .observeOn(MainScheduler.instance)
            .bind(to: profileItemsTableView.rx.items(cellIdentifier: "ProfileItemTableViewCell", cellType: ProfileItemTableViewCell.self)) {  row, profileItem, cell in
                cell.profileItem = profileItem
            }
            .disposed(by: disposeBag)
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

}
