import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton: UIButton!
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver : NSObjectProtocol?
    
  /*  override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            addObserver()
        }
        
        // Определяем конструктор, необходимый при декодировании
        // класса из Storyboard
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            addObserver()
        }
    
    deinit {
            removeObserver()
        }
    
    private func addObserver() {
            NotificationCenter.default.addObserver(                 // 1
                self,                                               // 2
                selector: #selector(updateAvatar(notification:)),   // 3
                name: ProfileImageService.didChangeNotification,    // 4
                object: nil)                                        // 5
        }
    
    private func removeObserver() {
            NotificationCenter.default.removeObserver(              // 6
                self,                                               // 7
                name: ProfileImageService.didChangeNotification,    // 8
                object: nil)                                        // 9
        }
    
    @objc                                                       // 10
    private func updateAvatar(notification: Notification) {     // 11
        guard
            isViewLoaded,                                       // 12
            let userInfo = notification.userInfo,               // 13
            let profileImageURL = userInfo["URL"] as? String,   // 14
            let url = URL(string: profileImageURL)              // 15
        else { return }
        
    } */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addLogoutButton()
        addDescriptionLabel()
        updateProfileDetails()
    }
    
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
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
      //  profileImageView.image = UIImage(named: "profile_image")
        
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
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}
