//
//  ToastService.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 31.12.2024.
//

import UIKit

protocol ToastServiceProtocol: Sendable {
    func showToast(style: ToastStyle, message: String)
}

final class ToastService: ToastServiceProtocol, @unchecked Sendable {
    
    // MARK: Properties
    @MainActor private var toastWindow: UIWindow?
    @MainActor private var activeToasts: [ToastView] = []
    @MainActor private var dismissTasks: [ToastView: Task<Void, Never>] = [:]
    
    private let toastSpacing: CGFloat = 8
    private let horizontalPadding: CGFloat = 16
    private let dismissDuration: UInt64 = 3_000_000_000 // 3 seconds in nanoseconds
    private let animationDuration: TimeInterval = 1.2
    
    // MARK: Public Methods
    func showToast(style: ToastStyle, message: String) {
        Task { @MainActor [weak self] in
            self?.presentToast(style: style, message: message)
        }
    }
    
    // MARK: Private Methods
    @MainActor
    private func presentToast(style: ToastStyle, message: String) {
        setupWindowIfNeeded()
        
        guard let window = toastWindow else { return }
        
        let toastView = ToastView(style: style, message: message)
        toastView.onDismiss = { [weak self] in
            self?.dismissToast(toastView)
        }
        
        window.addSubview(toastView)
        activeToasts.insert(toastView, at: 0)
        
        setupToastConstraints(toastView, in: window)
        
        // Initial position above screen
        toastView.transform = CGAffineTransform(translationX: 0, y: -100)
        toastView.alpha = 0
        
        // Animate existing toasts down
        repositionActiveToasts(animated: true)
        
        // Animate new toast in
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            toastView.transform = .identity
            toastView.alpha = 1
        }
        
        // Schedule auto dismiss
        scheduleAutoDismiss(for: toastView)
    }
    
    @MainActor
    private func setupWindowIfNeeded() {
        guard toastWindow == nil else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else { return }
        
        let window = PassthroughWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.isHidden = false
        window.isUserInteractionEnabled = true
        
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .clear
        rootVC.view.isUserInteractionEnabled = true
        window.rootViewController = rootVC
        
        self.toastWindow = window
    }
    
    @MainActor
    private func setupToastConstraints(_ toastView: ToastView, in window: UIWindow) {
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: horizontalPadding),
            toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -horizontalPadding),
            toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: toastSpacing)
        ])
    }
    
    @MainActor
    private func repositionActiveToasts(animated: Bool) {
        var yOffset: CGFloat = 0
        
        for (index, toast) in activeToasts.enumerated() {
            if index == 0 {
                yOffset = 0
            } else {
                let previousToast = activeToasts[index - 1]
                yOffset += previousToast.frame.height + toastSpacing
            }
            
            guard index > 0 else { continue }
            
            let transform = CGAffineTransform(translationX: 0, y: yOffset)
            
            if animated {
                UIView.animate(
                    withDuration: animationDuration,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseOut
                ) {
                    toast.transform = transform
                }
            } else {
                toast.transform = transform
            }
        }
    }
    
    @MainActor
    private func scheduleAutoDismiss(for toastView: ToastView) {
        let task = Task { [weak self] in
            try? await Task.sleep(nanoseconds: self?.dismissDuration ?? 3_000_000_000)
            guard !Task.isCancelled else { return }
            self?.dismissToast(toastView)
        }
        dismissTasks[toastView] = task
    }
    
    @MainActor
    private func dismissToast(_ toastView: ToastView) {
        dismissTasks[toastView]?.cancel()
        dismissTasks.removeValue(forKey: toastView)
        
        guard activeToasts.contains(toastView) else { return }
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: .curveEaseIn
        ) {
            toastView.transform = CGAffineTransform(translationX: 0, y: -150)
            toastView.alpha = 0
        } completion: { [weak self] _ in
            toastView.removeFromSuperview()
            if let index = self?.activeToasts.firstIndex(of: toastView) {
                self?.activeToasts.remove(at: index)
            }
            self?.repositionActiveToasts(animated: true)
            self?.hideWindowIfNeeded()
        }
    }
    
    @MainActor
    private func hideWindowIfNeeded() {
        if activeToasts.isEmpty {
            toastWindow?.isHidden = true
            toastWindow = nil
        }
    }
}

// MARK: - PassthroughWindow
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        
        // Pass through touches that don't hit a ToastView
        if hitView is ToastView || hitView.superview is ToastView {
            return hitView
        }
        
        return nil
    }
}
