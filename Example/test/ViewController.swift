//
//  ViewController.swift
//  test
//
//  Created by Ismail el Habbash on 18/07/2016.
//  Copyright © 2016 ismail el habbash. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IEHKeyboardBarProtocol {

    @IBOutlet weak var tableView: IEHTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.keyboardBar.iehKeyboardDelegate = self
    }

    func iehKeyboardFinishing(text: String) {
        print(text)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath)"
        return cell ?? UITableViewCell()
    }
}



