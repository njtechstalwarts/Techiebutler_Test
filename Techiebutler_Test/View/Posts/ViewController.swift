//
//  ViewController.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var postsList = [GetPostsResponse]()
    var masterList = [GetPostsResponse]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getPosts()
    }
    
    func setUpView() {
        tableView.prefetchDataSource = self
        self.navigationItem.title = "Posts(\(postsList.count))"
    }
    
    func getPosts() {
        Common.shared.showHUD()
        
        Task {
            let response = try await ApiService().getPosts().async()
            
            if response.isEmpty {
                Common.shared.showAlert(title: "Error", message: "No Data Found", vc: self)
            } else {
                masterList = response
                postsList = Array(masterList.prefix(10))
                tableView.reloadData()
            }
            setUpView()
            
            Common.shared.hideHUD()
            
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        self.postsList[indexPath.row].startTime = Date()
        cell.configureCell(data: postsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "PostCommentsViewController") as? PostCommentsViewController {
            vc.data = postsList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        GCDHelper.backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            if indexPath.row == self.postsList.count - 3 {
                if self.masterList.count >= ((self.pageNo + 1) * 10) {
                    self.pageNo += 1
                    let newElements = self.masterList.filter { self.postsList.count < $0.id!  && (self.pageNo * 10) >= $0.id! }
                    self.postsList.append(contentsOf: newElements)
                    GCDHelper.mainQueue.async {
                        tableView.reloadData()
                        self.setUpView()
                    }
                }
            }
            
            GCDHelper.mainQueue.async { [weak self] in
                guard let self  = self else { return }
                if let cell = cell as? PostsTableViewCell {
                    if let date = self.postsList[indexPath.row].startTime {
                        let elapsed = Date().timeIntervalSince(date)
                        cell.timeLabel.text = "\(String(format: "%.3f", elapsed)) sec"
                    }
                }
            }
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("Did Display \(indexPath.row)")
//        GCDHelper.mainQueue.async { [weak self] in
//            guard let self  = self else { return }
//            if let cell = cell as? PostsTableViewCell {
//                if let date = self.postsList[indexPath.row].startTime {
//                    let elapsed = Date().timeIntervalSince(date)
//                    cell.timeLabel.text = "\(elapsed) seconds"
//                }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for index in indexPaths {
            postsList[index.row].startTime = Date()
        }
        
    }
    
}
