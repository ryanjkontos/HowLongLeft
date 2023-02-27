//
//  NicknameEditorTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class NicknameEditorTableViewController: HLLAppearenceTableViewController {

    var object: NicknameObject!
    
    var preExisting = false
    
    var originalNameField: UITextField!
    var nicknameField: UITextField!
    
    var dismissedDelegate: SheetDismissedDelegate?
    
    var showAlertOnSave = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(IconButtonTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        preExisting = NicknameManager.shared.nicknameObjects.contains(where: { $0.originalName == object.originalName })
        
        self.navigationItem.title = "Manage Nickname"
        self.navigationItem.largeTitleDisplayMode = .never
        
        let cancelItem = UIBarButtonItem(systemItem: .cancel)
        cancelItem.target = self
        cancelItem.action = #selector(close)
        
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let doneItem = UIBarButtonItem(systemItem: .save)
        doneItem.target = self
        doneItem.action = #selector(done)
        
        self.navigationItem.rightBarButtonItem = doneItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func close() {
        
        self.dismissSheet()
        
    }
    
    @objc func done() {
        
        let original = object.originalName
        let nickname = object.nickname ?? ""
        
        if (original.isEmpty || nickname.isEmpty) {
            showErrorAlert()
        } else {
            NicknameManager.shared.saveNicknameObject(object)
            
            if dismissedDelegate == nil {
                InfoAlertBox.shared.showAlert(text: "Nickname Saved")
            }
            
            self.dismissSheet()
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            if self.preExisting == false {
                self.nicknameField?.becomeFirstResponder()
            } else {
                self.originalNameField?.becomeFirstResponder()
                
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return preExisting ? 3 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
        //    cell.backgroundColor = HLLColors.groupedCell
            self.originalNameField = cell.field
            cell.field.placeholder = "Event Name"
            cell.field.text = object.originalName
            cell.field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.selectionStyle = .none
            return cell
            
        }
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
         //   cell.backgroundColor = HLLColors.groupedCell
            self.nicknameField = cell.field
            cell.field.placeholder = "Nickname"
            cell.field.text = object.nickname
            cell.field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.selectionStyle = .none
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
       // cell.backgroundColor = HLLColors.groupedCell
        var config = UIListContentConfiguration.cell()
        config.text = "Delete Nickname"
        config.textProperties.color = .systemRed
        cell.contentConfiguration = config
        cell.accessoryType = .none
        return cell
        
            
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Events Named"
        }
        
        if section == 1 {
            return "Should Appear In How Long Left As"
        }
        
        return nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            NicknameManager.shared.deleteNicknameObject(object)
            dismissSheet()
            
        }
    }
    
    func dismissSheet() {
        
        
        
        self.dismissedDelegate?.sheetDismissed()
        self.dismiss(animated: true)
        
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
            
        DispatchQueue.main.async { [self] in
            if textField == self.originalNameField {
                guard let text = textField.text else { return }
                object.originalName = text
            }
            
            if textField == nicknameField {
                guard let text = textField.text else { return }
                object.nickname = text
            }
        }
        
    }
    
    func showErrorAlert() {

        let alert = UIAlertController(title: "Could Not Save", message: "You must provide an original name and a nickname", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}


