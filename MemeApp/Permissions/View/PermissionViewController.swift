//
//  PermissionViewController.swift
//  MemeApp
//
//  Created by UbiiPagos on 1/6/23.
//

import UIKit
import AVFoundation

class PermissionViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var allowButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    //MARK: Permission
    var permissionEnum: Permission = .camera
    
    //MARK: View Model
    var viewModel: PermissionViewModel?
    
    //MARK: - View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        allowButton.ubiiCardButtonGradient(colours: [K.firstGradientColor, K.secondGradientColor], cornerMultiplier: 0.5)
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View Model
        viewModel = PermissionViewModel()
        
        //MARK: Setup Info
        if let permissionInfo = viewModel?.getPermissionInformation(permissionEnum: permissionEnum) {
            if let image = UIImage(named: permissionInfo.iconName) {
                iconImageView.image = image
            }
            titleLabel.text = permissionInfo.title
            descriptionLabel.text = permissionInfo.description
        }
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
    
    //MARK: - Allow
    @IBAction func allowButtonAction(_ sender: Any) {
        switch permissionEnum {
            case .camera:
                viewModel?.cameraPermission()
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                        case .success(let message):
                            print("\(message) unread messages.")
                        case .failure(let error):
                            print(error.localizedDescription)
                            
                    }
                }
            case .location:
                print("location")
            case .notification:
                print("notification")
            case .none :
                print("none")
        }
    }
    
    //MARK: - Cancel
    @IBAction func cancelButtonAction(_ sender: Any) {
        
    }
    
}
