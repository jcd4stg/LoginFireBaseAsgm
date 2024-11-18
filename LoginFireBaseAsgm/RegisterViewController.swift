//
//  RegisterViewController.swift
//  LoginFireBaseAsgm
//
//  Created by lynnguyen on 18/11/2024.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func registerButtonTapped(_ sender: UIButton? = nil) {

        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()

        guard 
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6
        else {
            alertUserLogginError()
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            
            let user = result.user
            print("created su: \(user)")
            self?.navigationController?.popViewController(animated: true)
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}
