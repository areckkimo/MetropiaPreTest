//
//  SpotTableViewCell.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit

class SpotTableViewCell: UITableViewCell {
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(spot: Spot, indexPath: IndexPath, tableView: UITableView) {
        
        dateTimeLabel.text = spot.dateString
        addressLabel.text = spot.address
        mapImageView.image = nil
        
        let API_KEY = "AIzaSyBz1TSprs1K20BF4dWXc2UGHxHu2gpJapE"
        let mapImageWidth = Int(mapImageView.frame.size.width)
        let mapImageHeight = Int(mapImageView.frame.size.height)
        let staticMapURLString: String = "https://maps.google.com/maps/api/staticmap?markers=\(spot.latitude),\(spot.longitude)&\("zoom=15&size=\(mapImageWidth)x\(mapImageHeight)")&scale=2&key=\(API_KEY)"
        
        guard let staticMapURL = URL(string: staticMapURLString) else {
            return
        }
        PhotoDownloadManager.shared.downloadPhoto(with: staticMapURL, indexPath: indexPath) { (result) in
            switch result {
            case .success(let (image, indexPath)):
                DispatchQueue.main.async {
                    let spotCell = tableView.cellForRow(at: indexPath) as? SpotTableViewCell
                    spotCell?.mapImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

}
