//
//  ViewController.swift
//  LoginFireBaseAsgm
//
//  Created by lynnguyen on 18/11/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField! {
        didSet {
            emailField.delegate = self
        }
    }

    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: UIButton? = nil) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLogginError()
            return
        }

        // Firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }

            let user = result.user
            self?.navigationController?.presentingViewController?.dismiss(animated: true)

            let conVC = ConversationViewController()
            conVC.modalPresentationStyle = .fullScreen
            conVC.title = "Conversation"
            self?.present(conVC, animated: true)
        }
    }

    private func alertUserLogginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButton()
        }
        return true
    }
}

