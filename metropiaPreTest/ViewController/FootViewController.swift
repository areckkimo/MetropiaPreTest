//
//  FootViewController.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit

class FootViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Property
    var refreshControl = UIRefreshControl()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // stepView
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        refreshControl.addTarget(self, action: #selector(rfreshSpotData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //MARK: - Others
    @objc func rfreshSpotData(){
        tableView.reloadData()
        refreshControl.endRefreshing()
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

//MARK: - UITableViewDataSource
extension FootViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpotsStorage.shared.spots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotTableViewCell
        let spot = SpotsStorage.shared.spots[indexPath.row]
        cell.setupView(spot: spot, indexPath: indexPath, tableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "最近10筆"
    }
}
//MARK: - UITableViewDelegate
extension FootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
