//
//  ToastView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 31.12.2024.
//

import UIKit

final class ToastView: UIView {
    
    // MARK: Properties
    private let style: ToastStyle
    var onDismiss: (() -> Void)?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    init(style: ToastStyle, message: String) {
        self.style = style
        super.init(frame: .zero)
        setupView()
        configure(message: message)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func setupView() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(messageLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configure(message: String) {
        messageLabel.text = message
        messageLabel.textColor = style.textColor
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        iconImageView.image = UIImage(systemName: style.iconName, withConfiguration: iconConfig)
        iconImageView.tintColor = style.textColor
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .changed:
            if translation.y < 0 {
                transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            let velocity = gesture.velocity(in: self)
            if translation.y < -30 || velocity.y < -200 {
                onDismiss?()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        default:
            break
        }
    }
}
