import UIKit
import Kingfisher


public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
    func showAlert(alert: UIAlertController)
}
    
    
    
final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
 
    var presenter: ProfilePresenterProtocol?
    private let profileImageService = ProfileImageService.shared
    
    
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton: UIButton!
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        let presenter = ProfilePresenter(view: self)
        self.presenter = presenter
        presenter.viewDidLoad()
    
        updateAvatar()
        
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addLogoutButton()
        addDescriptionLabel()
        updateProfileDetails()
    }
    
    func updateAvatar() {
        
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "user_pick"),
                                     options: [.processor(processor), .transition(.fade(1))],
                                     progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Изображение успешно загружено: \(value.image)")
            case .failure(let error):
                print("Ошибка при загрузке изображения: \(error)")
            }
        }
    }
    
    private func addProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.accessibilityIdentifier = "Username"
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func addLoginNameLabel() {
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.accessibilityIdentifier = "@username"
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func addDescriptionLabel() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func addLogoutButton() {
        logoutButton = UIButton.systemButton(
            with: UIImage(named: "exit_button")!,
            target: self,
            action: #selector(didTapButton)
        )
        logoutButton.accessibilityIdentifier = "logoutButton"
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.widthAnchor.constraint(equalToConstant: 48),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapButton() {
        presenter?.showLogoutConfirmationAlert()
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
