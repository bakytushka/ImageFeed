import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setImage(url: String) {
        guard let url = URL(string: url) else { return }
        cellImage.kf.indicatorType = .activity
        self.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "stub"))
        
        // stub не становится перед фоточкой, надо пофиксить это
    }
    
    func setIsLiked(_ curentLike: Bool) {
       // likeButton.setImage(UIImage(named: curentLike ? "like_button_on" : "like_button_off"), for: .normal)
        let likeImage = curentLike ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
