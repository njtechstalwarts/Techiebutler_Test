//
//  PostCommentsViewController.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import UIKit

class PostCommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data: GetPostsResponse? = nil
    
    var commentsList = [GetComments.Response]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        navigationItem.title = data?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getComments()
    }
    
    func getComments() {
        Common.shared.showHUD()
        Task {
            let response = try await ApiService().getComments(request: GetComments.Request(postId: data?.id ?? 0)).async()
            
            if response.isEmpty {
                Common.shared.showAlert(title: "Error", message: "No Data Found", vc: self)
            } else {
                commentsList = response
                tableView.reloadData()
            }
            
            Common.shared.hideHUD()
                        
        }
        
    }
    
}

extension PostCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            1
        } else {
            commentsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            0.001
        } else {
            UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect.zero)
        } else {
            guard let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderTableViewCell else {
                return UIView(frame: CGRect.zero)
            }
            header.configureCell(header: "Comments(\(commentsList.count))")
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let data = data {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellTop", for: indexPath) as? PostsTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureCell(data: data)
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostCommentsTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(data: commentsList[indexPath.row])
            return cell
        }
    }
    
}
