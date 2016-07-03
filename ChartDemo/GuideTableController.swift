//
//  GuideTableController.swift
//  ChartDemo
//
//  Created by Andrew on 16/7/3.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit

class GuideTableController: UIViewController,UITableViewDelegate,
UITableViewDataSource,JSQDemoViewControllerDelegate {
    
    var tableview:UITableView!
    var arrayData:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安路"
        
        arrayData = ["push","Modal"]
        
        tableview = UITableView(frame: self.view.bounds)
        tableview.delegate=self
        tableview.dataSource=self
        self.view.addSubview(tableview)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if(cell == nil){
          cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        let name = arrayData[indexPath.row] as! String
        cell?.textLabel?.text = name
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        let vc = ViewController()
        if(indexPath.row == 1){
         vc.delegateModal = self
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didDismissJSQDemoViewController(vc: ViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
