//
//  MBBookListTableViewCell.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit

/// Single cell to display book info
class MBBookListTableViewCell: UITableViewCell {

    static let cellIdentifier = "MBBookListTableViewCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var ratingAverageLabel: UILabel!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var backgroundCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        bookImageView.layer.cornerRadius = 20
        bookImageView.clipsToBounds = true
        
        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.cornerRadius = 3
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.black.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        ratingAverageLabel.text = nil
        ratingCountLabel.text = nil
        bookImageView.image = nil
    }

    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Configure cell to display information
    /// - Parameter viewModel: Information to display
    public func configure(with viewModel: MBBookListTableViewCellViewModel){
        
        titleLabel.text = viewModel.title.uppercased()
        authorLabel.text = viewModel.author
        ratingAverageLabel.text = String(format: "%.2f", viewModel.ratingAverage)///Rounding off to 2 decimal places
        ratingCountLabel.text = "\(viewModel.ratingCount)"
        
        viewModel.fetchImage { [weak self] result in
            
            switch result{
                
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.bookImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
            
        }
        
    }

}
