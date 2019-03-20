//
//  EGGoogleDriveViewController.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/9/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class EGGoogleDriveViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingButton: EGButton!
    
    private let driveCell = "DriveCell"
    
    fileprivate let service = GTLRDriveService()
    private var drive: EGGoogleDrive?
    
    fileprivate var files: [GTLRDrive_File] = []
    fileprivate var folderID: String? = nil
    
    private func setupGoogleSignIn() {
        self.drive = EGGoogleDrive(service)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveFile]
        GIDSignIn.sharedInstance().signInSilently()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.folderID == nil {
            self.setupGoogleSignIn()
        }
        else {
            self.loadTableViewForFolder(self.folderID)
        }
        self.loadFloatingButton()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideListView()
    }
    
    func loadFloatingButton() {
        self.floatingButton.add(color: UIColor.white, title: "Add Folder", image: UIImage(named: "folder")) { (_) in
            self.addFolder()
        }
        
        self.floatingButton.add(color: UIColor.white, title: "Add Photo", image: UIImage(named: "image")) { (_) in
            self.addPhoto()
        }
    }
    
    func showHideListView() {
        let status = GIDSignIn.sharedInstance().hasAuthInKeychain()
        self.floatingButton.isHidden = !status
        self.tableView.isHidden = !status
        self.signOutButton.isHidden = !status
        self.signInButton.isHidden = status
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func tapSignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func tapSignOutButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
        GIDSignIn.sharedInstance()?.signOut()
        self.showHideListView()
    }
    
    func addFolder() {
        let alert = UIAlertController(title: "Enter Folder Name", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textFeild) in
            textFeild.placeholder = "Folder Name"
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            guard let textField = alert.textFields?.first, let string = textField.text, string.count > 0 else {
                //TODO: Show error
                return
            }
            self.createFolder(string)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createFolder(_ folder: String) {
        self.drive?.createFolder(self.folderID, name: folder, onCompleted: { (file, error) in
            if let error = error {
                print(error)
            } else if let file = file {
                self.files.append(file)
                self.tableView.reloadData()
            }
            else {
                //TODO: Show error
            }
        })
    }
    
    func addPhoto() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openImagePickerForSource(.camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openImagePickerForSource(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openImagePickerForSource(_ sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func loadTableViewForFolder(_ folderID: String? = nil) {
        self.drive?.listFiles(folderID, onCompleted: { (driveList, error) in
            if let error = error {
                print(error)
                //TODO: Show error
            } else {
                self.files = driveList?.files ?? []
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func didTapDeleteButton(_ button: UIButton) {
        let file = self.files[button.tag]
        guard let fileId = file.identifier else {
            //TODO: Show error
            return
        }
        
        self.drive?.delete(fileId, onCompleted: { (error) in
            if let error = error {
                print(error)
                //TODO: Show error
            }
            else {
                self.files.remove(at: button.tag)
                self.tableView.reloadData()
            }
        })
    }
}

extension EGGoogleDriveViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            service.authorizer = nil
            //TODO: Show error
        } else {
            service.authorizer = user.authentication.fetcherAuthorizer()
            self.showHideListView()
            self.loadTableViewForFolder()
        }
    }
}

extension EGGoogleDriveViewController: GIDSignInUIDelegate { }

extension EGGoogleDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriveCell", for: indexPath) as! EGGoogleDriveCell
        
        let file = self.files[indexPath.row]
        cell.fileName.text = file.name
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(EGGoogleDriveViewController.didTapDeleteButton(_:)), for: .touchUpInside)
        
        if let type = file.mimeType, type == "application/vnd.google-apps.folder" {
            cell.fileIcon.image = UIImage(named: "folder")?.withRenderingMode(.alwaysTemplate)
            cell.deleteButton.isHidden = true
        }
        else {
            cell.fileIcon.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
            cell.deleteButton.isHidden = false
        }
        
        return cell
    }
}

extension EGGoogleDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = self.files[indexPath.row]
        let stoyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let type = file.mimeType, type == "application/vnd.google-apps.folder" {
            guard let viewController = stoyBoard.instantiateViewController(withIdentifier: "GoogleDriveViewController") as? EGGoogleDriveViewController else {
                return
            }
            viewController.folderID = file.identifier
            viewController.drive = self.drive
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else {
            guard let viewController = stoyBoard.instantiateViewController(withIdentifier: "ShowImageViewController") as? EGShowImageViewController else {
                return
            }
            
            viewController.fileId = file.identifier
            viewController.drive = self.drive
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

class EGGoogleDriveCell: UITableViewCell {
    @IBOutlet weak var fileIcon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            self.deleteButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        self.deleteButton.setImage(image, for: .normal)
    }
}

//ImagePickerController

extension EGGoogleDriveViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage, let url = info[.imageURL] as? URL else {
            return
        }
        
        let imageName = url.lastPathComponent
        
        self.drive?.uploadFile(image, imageName: imageName, folderID: self.folderID, onCompleted: { (file, error) in
            if let error = error {
                print(error)
            } else if let file = file {
                self.files.append(file)
                self.tableView.reloadData()
            }
            else {
                //TODO: Show error
            }
        })
    }
}
