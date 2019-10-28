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

class ProfileDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profileDetailsViewModel: IProfileDetailsViewModel?
    
    @IBOutlet weak var profileItemsTableView: UITableView!
    
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
    
        navigationItem.title = "Account"
        
        bindUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        profileDetailsViewModel!.getLoggedInUserDetails()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileDetailsViewModel!.proItems.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailsTableViewCell", for: indexPath) as! ProfileDetailsTableViewCell
            cell.user = profileDetailsViewModel!.user!
            
            cell.editProfileButton.addTapGesture { [weak self] in
                self?.performSegue(withIdentifier: "showEditProfileViewController", sender: nil)
            }
            
            return cell
            
        } else if indexPath.row == profileDetailsViewModel!.proItems.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutTableViewCell", for: indexPath) as! LogoutTableViewCell
            
            cell.logoutView.addTapGesture { [weak self] in
                self?.profileDetailsViewModel!.logUserOut()
                self?.view.window?.rootViewController?.dismiss(animated: true) {
                    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                    self?.navigationController?.setViewControllers([vc], animated: false)
                }
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemTableViewCell", for: indexPath) as! ProfileItemTableViewCell
            cell.profileItem = profileDetailsViewModel!.proItems[indexPath.row - 1 ]
            
            return cell
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    fileprivate func bindUserDetails() {
        profileDetailsViewModel!
            .userDetails.asObservable()
            .bind { [weak self] user in

        }
        .disposed(by: disposeBag)
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
    

}
