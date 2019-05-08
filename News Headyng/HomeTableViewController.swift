//
//  HomeTableViewController.swift
//  News Headyng
//
//  Created by Mohammad Yunus on 08/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let decoder = JSONDecoder()
    
    let cache = NSCache<NSString, NSData>()
    
    var allNews: Body?
    
    @IBOutlet weak var refreshControlOutlet: UIRefreshControl!
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getAllNewsFrom(url: String){
        if let youareL = URL(string: url){
            let task = URLSession.shared.dataTask(with: youareL) { [weak self] (data, response, error) in
                if error != nil{
                    print(error!)
                    //
                }else{
                    if let d = data{
                        do{
                            self?.allNews = try self?.decoder.decode(Body.self, from: d)
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                                self?.refreshControlOutlet.endRefreshing()
                            }
                        }catch{
                            print(error)
                            //
                        }
                    }else{
                        print("d is not equal to data")
                        //
                    }
                }
            }
            task.resume()
        }else{
            print("string provided can not be converted to URL")
            //
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allNews?.num_results ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    

}
