import UIKit

final class ProfileViewController: UIViewController {
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addLogoutButton()
        addDescriptionLabel()
    }
    
    private func addProfileImageView() {
        profileImageView.image = UIImage(named: "profile_image")
        
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
}
