//
//  BaseViewController.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

// MARK: - Base View Controller -
class BaseViewController: UIViewController, LoadingStateHandler {
    var loadingState: LoadingState = .idle {
        didSet {
            updateUI(for: loadingState)
        }
    }
    
    func onStateChange(to state: LoadingState) { }
}
