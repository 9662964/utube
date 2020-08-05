//
//  HypeListViewController.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import UIKit

class HypeListViewController: UIViewController {
    
    //MARK : Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()

    }
    //MARK: Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    
    
    //MARK: Helper methods
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        refresher.attributedTitle = NSAttributedString(string: "Pull to see new Hypes!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresher)
    }
    
    @objc func loadData() {
        HypeController.shared.fetchAllHypes { (result) in
            switch result {
                
            case .success(let hypes):
                HypeController.shared.hypes = hypes
                self.updateViews()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    func presentAddHypeAlert() {
        let alertController = UIAlertController(title: "Get Hype", message: "What is Hype may never die!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "What is Hype today"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {return}
            HypeController.shared.saveHype(body: text) { (result) in
                switch result {
                    
                case .success(let hype):
                    HypeController.shared.hypes.insert(hype, at: 0)
                    self.updateViews()
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addHypeAction)
        self.present(alertController, animated: true)
    }//End of Function
    
    @IBAction func addBtnTapped(_ sender: Any) {
        presentAddHypeAlert()
    }
}//End of class


extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        let hype = HypeController.shared.hypes[indexPath.row]
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.dateAsString()
        
        return cell
    }
    
    
}
