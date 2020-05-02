//
//  JobTableViewCell.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageCompanyLogo: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    public func set(job: Job, indexPath: IndexPath) {
        labelTitle.text = job.title
        labelLocation.text = job.location
        labelDate.text = job.createdDate
        labelCompany.text = job.company
        labelDescription.text = job.description.nonHtmlText()
        
        setRoundedImage()
        guard let imageUrl = job.imageUrl, let url = URL(string: imageUrl) else {
            return
        }
        imageCompanyLogo.setImage(url: url) { image in
            DispatchQueue.main.async {
                if self.tag == indexPath.row {
                    self.imageCompanyLogo.image = image
                }
            }
        }
    }
    public func setRoundedImage() {
        imageCompanyLogo.layer.cornerRadius = imageCompanyLogo.frame.size.width/2
        imageCompanyLogo.layer.masksToBounds = true
    }
}
