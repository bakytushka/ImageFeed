import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    var imageUrl: URL?
    
    @IBOutlet private var singleImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        setSingleImage()
       // scrollView.delegate = self
        
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func setSingleImage() {
        UIBlockingProgressHUD.show()
        singleImageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(
            title: "Не надо",
            style: .default
        )
        let action = UIAlertAction(
            title: "Повторить",
            style: .default
        ) { _ in
            self.setSingleImage()
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    @objc
    private func handleDoubleTap() {
        scrollView.setZoomScale(1, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        guard scale != 1.0 else {
            return
        }
        
        scrollView.setZoomScale(1, animated: true)
    }
}
