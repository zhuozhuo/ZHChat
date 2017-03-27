//
//  ZHRootTableViewController.swift
//  ZHChatSwift
//
//  Created by aimoke on 16/12/15.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit

class ZHRootTableViewController: UITableViewController {
    var dataArray: [String] = ["Push","Present"];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init();
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RootreuseIdentifier", for: indexPath);
        cell.textLabel?.text = dataArray[indexPath.row];

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        switch indexPath.row {
        case 0:
            let messagesVC: ZHCDemoMessagesViewController = ZHCDemoMessagesViewController.init();
            messagesVC.presentBool = false;
            self.navigationController?.pushViewController(messagesVC, animated: true);
        case 1:
            let messagesVC: ZHCDemoMessagesViewController = ZHCDemoMessagesViewController.init();
            messagesVC.presentBool = true;
            let nav: UINavigationController = UINavigationController.init(rootViewController: messagesVC);
            self.navigationController?.present(nav, animated: true, completion: nil);
        default:
            break;
        }
       
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
