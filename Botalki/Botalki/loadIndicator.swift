//
//  loadIndicator.swift
//  Botalki
//
//  Created by Сергей Николаев on 23.10.2022.
//

import Foundation
import PinLayout
import NVActivityIndicatorView

final class LoadindIndicatorView: UIView {

    // MARK: - Private Properties

    private weak var rootVC: UIViewController?
    private var dismissDelay = 0.2
    private let activityIndicator = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 67, height: 67),
        type: .ballClipRotateMultiple,
        color: UIColor.label,
        padding: 0
    )

    private let successView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    private let failureView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))

    // MARK: - Intialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func pinToRootVC(rootVC: UIViewController, dismissWithDelay: Double? = nil) {
        self.rootVC = rootVC

        rootVC.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: 100),
            self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func pinToRootView(rootView: UIView, frame: CGRect? = nil) {
        rootView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: rootView.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: frame?.width ?? 100),
            self.heightAnchor.constraint(equalToConstant: frame?.height ?? 100)
        ])
    }

    func pinToRootButton(rootButton: UIButton, frame: CGRect? = nil) {
        rootButton.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: rootButton.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: rootButton.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: frame?.width ?? 100),
            self.heightAnchor.constraint(equalToConstant: frame?.height ?? 100),

            activityIndicator.widthAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.7),
            activityIndicator.heightAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.7),

            successView.widthAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.8),
            successView.heightAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.8),

            failureView.widthAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.8),
            failureView.heightAnchor.constraint(equalToConstant: min(frame?.width ?? 100, frame?.height ?? 100) * 0.8)
        ])
    }

    func start() {
        isHidden = false

        if rootVC != nil {
            rootVC?.view.isUserInteractionEnabled = false
        }

        UIView.animate(withDuration: 0.3, delay: 0) {
            self.activityIndicator.startAnimating()
            self.alpha = 1
            self.activityIndicator.alpha = 1
        }
    }

    func stopSuccess(duration: Double = 0.3, delay: Double = 0.5, completion: (() -> Void)? = nil) {
        self.successView.alpha = 1
        if self.rootVC != nil {
            self.rootVC?.view.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: duration, delay: delay) {
            self.activityIndicator.stopAnimating()
            self.alpha = 0
            self.successView.alpha = 0
        } completion: { res in
            if res {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.isHidden = true
                    completion?()
                }
            }
        }
    }

    func stopFailure(duration: Double = 0.3, delay: Double = 0.5, completion: (() -> Void)? = nil) {
        self.failureView.alpha = 1
        if self.rootVC != nil {
            self.rootVC?.view.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: duration, delay: delay) {
            self.activityIndicator.stopAnimating()
            self.alpha = 0
            self.failureView.alpha = 0
        } completion: { res in
            if res{
                DispatchQueue.main.asyncAfter(deadline: .now() + self.dismissDelay) {
                    self.isHidden = true
                    completion?()
                }
            }
        }
    }

    func stopInstantly() {
        self.activityIndicator.stopAnimating()
        self.alpha = 0
        self.isHidden = true
        if self.rootVC != nil {
            self.rootVC?.view.isUserInteractionEnabled = true
        }
    }

    // MARK: - Private Methods

    private func setup() {
        isHidden = true
        activityIndicator.color = .label
        activityIndicator.alpha = 0
        successView.tintColor = .label
        successView.alpha = 0
        failureView.tintColor = .label
        failureView.alpha = 0

        backgroundColor = .systemGray4
        layer.masksToBounds = true
        layer.cornerRadius = 12
        alpha = 0

        successView.translatesAutoresizingMaskIntoConstraints = false
        failureView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        // autolayout
        addSubview(activityIndicator)
        addSubview(successView)
        addSubview(failureView)

        alpha = 0

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 67),
            activityIndicator.heightAnchor.constraint(equalToConstant: 67),

            successView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successView.centerYAnchor.constraint(equalTo: centerYAnchor),
            successView.widthAnchor.constraint(equalToConstant: 70),
            successView.heightAnchor.constraint(equalToConstant: 70),

            failureView.centerXAnchor.constraint(equalTo: centerXAnchor),
            failureView.centerYAnchor.constraint(equalTo: centerYAnchor),
            failureView.widthAnchor.constraint(equalToConstant: 70),
            failureView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
