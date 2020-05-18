//
//  ContactListScreen.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 30/01/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import Foundation

import UIKit

protocol ContactListVCDelegate : class {
    func search(for text:String)
    func showDetailPageVC(_ doc:Contact)
    func reloadTableView()
    
}


class ContactListViewController: UIViewController, ContactListVCDelegate {
    
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let cellReuseIdentifier = "contactCell"
    private let refreshControl = UIRefreshControl()
    
    var viewModel = ContactViewModel(networkManager:NetworkManager(httpClient:HttpClient(session: URLSession(configuration: URLSessionConfiguration.default))),
                                     dataManager: Datamanager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.contactsTableView?.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.contactsTableView?.dataSource = viewModel
        self.contactsTableView?.delegate = viewModel
        //self.searchBar.delegate = self
        viewModel.delegate = self
        
        self.contactsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshContactData(_:)), for: .valueChanged)
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        add.tintColor = UIColor(red: 83.0/255.0, green: 227.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        navigationItem.rightBarButtonItems = [add]
        
        self.title = "Contact"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchContacts()
    }
    @objc private func refreshContactData(_ sender: Any) {
        // Fetch Weather Data
        viewModel.fetchContacts()
    }
    
    @objc func addContact(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailView") as? ContactDetailViewController
        vc?.viewModel.isEditing = true
        vc?.operationtype = .save
        self.navigationController?.pushViewController(vc!, animated: true)    }
    
    func search(for text: String) {
        
    }
    
    func reloadTableView() {
        self.refreshControl.endRefreshing()
        self.contactsTableView.reloadData()
    }
    
    func showDetailPageVC(_ doc: Contact) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailView") as? ContactDetailViewController
        vc?.viewModel.contactToShow = doc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

