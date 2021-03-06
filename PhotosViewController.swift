//
//  PhotosViewController.swift
//  TumblrViewer
//
//  Created by Keith Tan on 1/16/19.
//  Copyright © 2019 keithatan. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var posts: [[String: Any]] = []

    @IBOutlet weak var UITable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITable.delegate = self
        UITable.dataSource = self

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                print(self.posts.count)
                
                self.UITable.reloadData();
                
                // TODO: Reload the table view
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        if let photos = post["photos"] as? [[String: Any]] {
            print(photos)
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.
            let urlString = originalSize["url"] as! String
            // 4.
            let url = URL(string: urlString)
            
            cell.PostImage.af_setImage(withURL: url!)
            cell.PostImage.contentMode = .scaleAspectFit
            cell.PostImage.clipsToBounds = true
            cell.PostImage.layer.masksToBounds = true



        }
        
        // Configure YourCustomCell using the outlets that you've defined.
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
