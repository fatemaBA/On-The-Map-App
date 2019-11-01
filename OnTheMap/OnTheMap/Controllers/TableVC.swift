//
//  TableVC.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/11/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation
import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: Lifecycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    //MARK: TableView Delegte functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InformationList.studentInformationList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        let location = InformationList.studentInformationList[(indexPath as NSIndexPath).row]
        
        // Set the image and the label
        cell.textLabel?.text = location.firstName + " " + location.lastName
        cell.detailTextLabel?.text = location.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
        
    }
    
}
