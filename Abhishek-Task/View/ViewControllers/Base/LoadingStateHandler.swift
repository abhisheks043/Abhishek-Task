//
//  LoadingStateHandler.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(Error)
}

protocol LoadingStateHandler: AnyObject {
    var loadingState: LoadingState { get set }
    func updateUI(for state: LoadingState)
    func showError(_ error: Error)
    
    // hooks for vcs to add additional updated
    func onStateChange(to state: LoadingState)
}

// MARK: - Default Implementation -
extension LoadingStateHandler where Self: UIViewController {
    func updateUI(for state: LoadingState) {
        switch state {
        case .idle:
            hideLoader()
            
        case .loading:
            showLoader()
            
        case .loaded:
            hideLoader()
            
        case .error(let error):
            hideLoader()
            showError(error)
        }
        
        onStateChange(to: state)
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Something went wrong",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Helper Methods
    private func showLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.tag = 9999 // To identify and remove later
        view.addSubview(activityIndicator)
    }

    private func hideLoader() {
        if let loader = view.viewWithTag(9999) as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
    }
}
