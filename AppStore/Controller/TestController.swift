//
//  TestController.swift
//  AppStore
//
//  Created by t19960804 on 12/14/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    let testTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(handleUserInput), for: .editingChanged)
        tf.backgroundColor = .gray
        return tf
    }()
    let testLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 19)
        lb.text = "Test"
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testTextField)
        view.addSubview(testLabel)
        testTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        testTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        testTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        testLabel.topAnchor.constraint(equalTo: testTextField.bottomAnchor, constant: 9).isActive = true
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    @objc func handleUserInput(textField: UITextField){
        
        testLabel.text = textField.text == "123456" ? "Correct" : "Error"
        testLabel.textColor = textField.text == "123456" ? .green : .red
        print(textField.text)
    }
}
