import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private var photos: [Photo] = []
    private var imageListService = ImagesListService.shared //пофиксить название на imagesListService
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageListService.fetchPhotosNextPage()
        configureNotificationObserver()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageName = photosName[indexPath.row]
            guard let imageUrl = URL(string: imageListService.photos[indexPath.row].largeImageURL) else { return }
            viewController.imageUrl = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        // ...
        // indexPath.row + 1 == photos.count
        if indexPath.row + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    @objc func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func configureNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )}
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        //guard let image = UIImage(named: photosName[indexPath.row]) else {
        //   return
        
        cell.setImage(url: imageListService.photos[indexPath.row].thumbImageURL)
        /* if let url = URL(string: imageListService.photos[indexPath.row].thumbImageURL) {
         cell.cellImage.kf.indicatorType = .activity
         cell.cellImage.kf.setImage(with: url,
         placeholder: UIImage(named: "stub")) { [weak self] _ in
         guard let self = self else { return }
         self.tableView.reloadRows(at: [indexPath], with: .automatic)
         } */
        
        
        //   cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        //let isLiked = indexPath.row % 2 == 0
        //let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        //cell.likeButton.setImage(likeImage, for: .normal)
        let isLiked = isLiked(indexPath: indexPath)
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.setIsLiked(photos[indexPath.row].isLiked)
        cell.delegate = self
    }
    
    private func isLiked(indexPath: IndexPath) -> Bool {
        return imageListService.photos[indexPath.row].isLiked == false
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //   guard let image = UIImage(named: photosName[indexPath.row]) else {
        //       return 0
        // }
        let image = imageListService.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Error changing like: \(error)")
                // TODO: ПОказать ошибку с использованием UIAlertController
            }
        }
    }
}


