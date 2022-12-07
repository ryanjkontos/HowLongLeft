//
//  ManageNicknamesTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class ManageNicknamesTableViewController: HLLAppearenceTableViewController {

    var objects = [NicknameObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nicknames"
        self.navigationItem.largeTitleDisplayMode = .never
        tableView.register(IconButtonTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let removeAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
        self.navigationItem.rightBarButtonItem = removeAllButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    func update() {
        objects = NicknameManager.shared.nicknameObjects
        self.navigationItem.rightBarButtonItem?.isEnabled = !objects.isEmpty
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      //  cell.backgroundColor = HLLColors.groupedCell
        cell.accessoryType = .none
        if indexPath.row != 0 {
            let object = objects[indexPath.row-1]
            var config = UIListContentConfiguration.subtitleCell()
            config.text = object.nickname
            config.secondaryText = object.originalName
            config.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = config
        } else {
            var config = UIListContentConfiguration.cell()
            config.text = "Add Nickname"
            config.textProperties.color = .systemOrange
            cell.contentConfiguration = config
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Nicknames"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Use nicknames to specify how an event's title should appear in How Long Left. This may be useful if you use a calendar that is read-only."
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editor = NicknameEditorTableViewController(style: .insetGrouped)
        editor.dismissedDelegate = self
        if indexPath.row != 0 {
            editor.object = objects[indexPath.row-1]
        } else {
            editor.object = NicknameObject("", nickname: nil, compactNickname: nil)
        }
        self.present(HLLNavigationController(rootViewController: editor), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let objects = objects
        if indexPath.row == 0 { return nil }
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
            self.deleteNicknames(nicknamesToDelete: [objects[indexPath.row-1]])
            
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func deleteNicknames(nicknamesToDelete: [NicknameObject]) {
        let indexPaths = nicknamesToDelete.map({ IndexPath(row: self.objects.firstIndex(of: $0)!+1, section: 0) })
        NicknameManager.shared.deleteNicknameObjects(nicknamesToDelete)
        update()
        self.tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    @objc func deleteAll() {
        deleteNicknames(nicknamesToDelete: objects)
    }

}

extension ManageNicknamesTableViewController: SheetDismissedDelegate {
    
    func sheetDismissed() {
        update()
        tableView.reloadData()
    }
    
}
