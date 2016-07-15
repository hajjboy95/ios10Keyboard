//
//  ViewController.swift
//  Swift3_tableviewcontroller
//
//  Created by Ismail el Habbash on 12/07/2016.
//  Copyright © 2016 ismail el habbash. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: CustomTableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 100
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(indexPath)"
            cell?.detailTextLabel?.text = "hello"

            self.tableView.iehBecomeFirstResponder(forIndex: IndexPath(item: 0, section: 0 ))
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment")
            cell?.textLabel?.text = "comment"
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

