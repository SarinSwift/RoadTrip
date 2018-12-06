//
//  FriendsViewController.swift
//  RoadTrip
//
//  Created by Sarin Swift on 12/5/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import Foundation
import UIKit

struct Names {
    var title: String
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let names: [Names] = [Names(title: "Stacy"), Names(title: "Macy"), Names(title: "Rosy")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.4470588235, blue: 0.4784313725, alpha: 1)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // popup action to add name, latitude, and loingitude
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Location", message: "Input latitude and longitude", preferredStyle: .alert)
        alert.addTextField { (textFieldName) in
            textFieldName.placeholder = "Name"
        }
        alert.addTextField { (textFieldLat) in
            textFieldLat.placeholder = "Latitude"
        }
        alert.addTextField { (textFieldLong) in
            textFieldLong.placeholder = "Longitude"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text as Optional)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text as Optional)")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! FriendsTableViewCell
        cell.name.text = names[indexPath.row].title
        cell.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.4470588235, blue: 0.4784313725, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected index: \(indexPath.row)")
    }
    
}

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
}
