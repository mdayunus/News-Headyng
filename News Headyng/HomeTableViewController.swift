//
//  HomeTableViewController.swift
//  News Headyng
//
//  Created by Mohammad Yunus on 08/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit
import SafariServices

class HomeTableViewController: UITableViewController {
    
    let decoder = JSONDecoder()
    
    let cache = NSCache<NSString, NSData>()
    
    var allNews: Body?
    
    @IBOutlet weak var refreshControlOutlet: UIRefreshControl!
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
        getAllNewsFrom(url: Constants.newsURL)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllNewsFrom(url: Constants.newsURL)
    }
    
    func getAllNewsFrom(url: String){
        if let youareL = URL(string: url){
            let task = URLSession.shared.dataTask(with: youareL) { [weak self] (data, response, error) in
                if error != nil{
                    print(error!)
                    let ac = UIAlertController(title: "Error", message: "can not complete season", preferredStyle: .alert)
                    let action = UIAlertAction(title: "dismiss", style: .destructive)
                    ac.addAction(action)
                    self?.present(ac, animated: true)
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
                            let ac = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "dismiss", style: .destructive)
                            ac.addAction(action)
                            self?.present(ac, animated: true)
                        }
                    }else{
                        print("d is not equal to data")
                        //
                        let ac = UIAlertController(title: "Error", message: "can not convert data from url to specified body type", preferredStyle: .alert)
                        let action = UIAlertAction(title: "dismiss", style: .destructive)
                        ac.addAction(action)
                        self?.present(ac, animated: true)
                    }
                }
            }
            task.resume()
        }else{
            print("string provided can not be converted to URL")
            //
            let ac = UIAlertController(title: "Error", message: "string cannot be converted into url", preferredStyle: .alert)
            let action = UIAlertAction(title: "dismiss", style: .destructive)
            ac.addAction(action)
            present(ac, animated: true)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allNews?.num_results ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = allNews?.results[indexPath.row].title
        cell.detailTextLabel?.text = allNews?.results[indexPath.row].byline
        if (allNews?.results[indexPath.row].multimedia.count)! > 0{
            let nsString = (allNews?.results[indexPath.row].multimedia[0].url)! as NSString
            if cache.object(forKey: nsString) != nil{
                let data = (cache.object(forKey: nsString))! as Data
                cell.imageView?.image = UIImage(data: data)
            }else{
                let url = allNews?.results[indexPath.row].multimedia[0].url
                let t = URLSession.shared.dataTask(with: URL(string: url!)!) { (data, response, error) in
                    if error != nil{
                        print(error!)
                        //
                    }else{
                        DispatchQueue.main.async { [weak self] in
                            self?.cache.setObject(data! as NSData, forKey: nsString)
                            tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                    }
                }
                t.resume()
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = allNews?.results[indexPath.row].url{
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = true
            config.entersReaderIfAvailable = true
            let svc = SFSafariViewController(url: URL(string: url)!, configuration: config)
            present(svc, animated: true)
        }
    }
    
    

}
