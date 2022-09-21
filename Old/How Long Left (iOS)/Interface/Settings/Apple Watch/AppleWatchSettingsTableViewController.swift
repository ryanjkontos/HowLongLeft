//
//  AppleWatchSettingsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 20/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class AppleWatchSettingsTableViewController: UITableViewController {

    var previewing: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        self.navigationItem.title = "Apple Watch"
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        print("AW NoS")
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell
        
        if indexPath.section == 0 {
            
            cell.title = "Interface"
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
        
        if indexPath.section == 1 {
        
            if indexPath.row == 0 {
            
        if IAPHandler.shared.hasPurchasedComplication() {
        
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            switchCell.cellLabel.text = "Show Events"
            switchCell.getAction = { return HLLDefaults.complication.complicationEnabled }
            switchCell.setAction = { value in
                
                HLLDefaults.complication.complicationEnabled = value
            }
            
            return switchCell
            
            
        } else {
           
            
            cell.title = "Show Events"
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            cell.detailLabel.text = IAPHandler.complicationPriceString
            IAPHandler.shared.complicationPriceCell = cell
            return cell
            
        }
            
        }
            
        }
        
        if indexPath.section == 2 {
            
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            switchCell.cellLabel.text = "Sync Preferences With iPhone"
            switchCell.getAction = { return HLLDefaults.watch.syncPreferences }
            switchCell.setAction = { value in
                          
                HLLDefaults.watch.syncPreferences = value
                HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
                      
            }
            return switchCell
            
            
        }
        
        return cell
            
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Complication"
            
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "Manage How Long Left's Apple Watch interface."
            
        }
        
        if section == 1 {
            
            return "Show a countdown for the current or upcoming event on your watch face."
            
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            var tableViewType = UITableView.Style.grouped
            if #available(iOS 13.0, *) {
                tableViewType = .insetGrouped
            }
                
            self.navigationController?.pushViewController(WatchInterfaceTableViewController(style: tableViewType), animated: true)
            
        }
        
        if indexPath.section == 1 {
            
            if IAPHandler.shared.hasPurchasedComplication() == false {
            
                self.present(BackgroundFunctions.shared.getPurchaseComplicationViewController(with: self), animated: true, completion: nil)
            
            }
        }
        
    }

}

@available(iOS 13.0, *)
extension AppleWatchSettingsTableViewController {
   
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if IAPHandler.shared.hasPurchasedComplication() == false, indexPath.section == 1, indexPath.row == 0 {
            
            let viewController = BackgroundFunctions.shared.getPurchaseComplicationViewController(with: self, preview: true)
            
            return UIContextMenuConfiguration(identifier: NSString("ComplicationContextMenu"), previewProvider: { return viewController }, actionProvider: { _ in
                
                if IAPHandler.shared.hasPurchasedComplication() == false {
                
                var priceString = "Price Unavailable"
                if let realPriceString = IAPHandler.complicationPriceString {
                    priceString = realPriceString
                }
                
                    let purchaseAction = UIAction(title: "Buy", image: UIImage(systemName: "cart"), identifier: nil, discoverabilityTitle: priceString, state: .off, handler: { _ in

                    DispatchQueue.main.async {
                    IAPHandler.shared.purchaseMyProduct(index: 0)
                    }
                
                })
                    
                let restoreAction = UIAction(title: "Restore", image: UIImage(systemName: "purchased"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in

                    DispatchQueue.main.async {
                        IAPHandler.shared.restorePurchase()
                    }
                    
                })
                    
                return UIMenu(title: "", children: [purchaseAction, restoreAction])
                    
           
        } else {
            
            return nil
            
        }
        
            })
            
        }
            
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        if configuration.identifier as? String == "ComplicationContextMenu" {
        
        animator.addCompletion {
            
            let viewController = BackgroundFunctions.shared.getPurchaseComplicationViewController(with: self)
            
            self.present(viewController, animated: true, completion: nil)

            
            
            }
            
        }
        
    }
    
}

extension AppleWatchSettingsTableViewController: DefaultsTransferObserver {
    
    func defaultsUpdated() {
        
        DispatchQueue.main.async {
        
        for cell in self.tableView.visibleCells {
            
            if let switchCell = cell as? SwitchCell {
                
                switchCell.update()
                
            }
            
        }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                
                self.tableView.reloadData()
                
            })
            
        }
        
    }
    
}
