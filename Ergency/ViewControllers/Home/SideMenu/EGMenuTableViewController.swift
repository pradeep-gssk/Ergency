//
//  EGMenuTableViewController.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/8/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class EGMenuTableViewController: UITableViewController {
    
    enum Menu: Int {
        case home
        case drive
        case logout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menu = Menu(rawValue: indexPath.row) else { return }
        
        switch menu {
        case .home:
            self.revealViewController()?.revealToggle(animated: true)
        case .logout:
            UserDefaults.standard.set(false, forKey: USER_PROFILE_DATA)
            appDelegate.showLoginView()
        default:
             break
        }
    }
}
