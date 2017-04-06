//
//  ViewController.swift
//  BBShangJia
//
//  Created by cbwl on 16/12/5.
//  Copyright © 2016年 CYT. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
//    var tableView = UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设置"

        self.view.addSubview(tableView)
        
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor=UIColor.purple
        
        btn.frame = CGRect(x: 50, y: 50, width: 150, height: 50)
        btn.backgroundColor=UIColor.green
        btn .setTitle("这是按钮", for: .normal)
        btn.setImage(UIImage(named:"btn_back"), for: UIControlState.normal)
        btn .addTarget(self , action:#selector(leftBackClick), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    func leftBackClick() {
        
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate lazy var tableView:UITableView = {
        let tableView=UITableView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height-50),style:UITableViewStyle.plain)
        tableView.delegate=self
        tableView.dataSource=self
//    self.view
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 30
            
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return 2
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        if cell.isEqual(nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text="这个是设置"
        cell.backgroundColor=UIColor.red
        cell.selectionStyle = .none
        //        cell.strr="dferfrfr"
        //        cell.delegate=self
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
