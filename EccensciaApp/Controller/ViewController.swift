//
//  ViewController.swift
//  EccensciaApp
//
//  Created by Jigneshkumar Patil on 2021/08/05.
//

import UIKit
import CryptoKit
import CommonCrypto

class ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    var firstName: String?
    var lastName: String?
    var firstNameOdd: String?
    var lastNameEven: String?
    var FullNameEvenOdd: String?
    
    @IBOutlet weak var button1Label: UILabel!
    @IBOutlet weak var button23Label: UILabel!
    @IBOutlet weak var sha256Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNameTextField.delegate = self
        surnameTextField.delegate = self
    }

    @IBAction func button1Pressed(_ sender: Any) {
        firstName = firstNameTextField.text ?? ""
        lastName = surnameTextField.text ?? ""
        
        FullNameEvenOdd = oddString() + " " + evenString()
        // Display this in the app
        button1Label.text = FullNameEvenOdd
        // Display results in the log
        print("Odd Even Name: \(FullNameEvenOdd!)")
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        if let safeFullNameEvenOdd = FullNameEvenOdd {
            print(safeFullNameEvenOdd.stringToBinary())
            button23Label.text = safeFullNameEvenOdd.stringToBinary()
            sha256Label.text = safeFullNameEvenOdd.hash256()
        }

    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        if let safeFullNameEvenOdd = FullNameEvenOdd {
            print(safeFullNameEvenOdd.stringToHex())
            button23Label.text = safeFullNameEvenOdd.stringToHex()
            sha256Label.text = safeFullNameEvenOdd.hash256()
            print(safeFullNameEvenOdd.hash256())
        }
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.endEditing(true)
        surnameTextField.endEditing(true)
        firstName = firstNameTextField.text!
        lastName = surnameTextField.text!
        return true
    }
}


extension ViewController {
    
    //MARK: - Even String
    func evenString() -> String {
        if let string = lastName {
            var index = 0
            lastNameEven = string.filter { _ in
                defer { index += 1 }
                return index % 2 == 1
            }
        }
        return lastNameEven ?? ""
    }

    //MARK: - Odd String
    func oddString() -> String {
        if let string = firstName {
            var index = 0
            firstNameOdd = string.filter { _ in
                defer { index += 1 }
                return index % 2 == 0
            }
        }
        return firstNameOdd ?? ""
    }
}



//MARK: - Binary


extension String {
    func stringToBinary() -> String {
        let st = self
        var result = ""
        for char in st.utf8 {
            var tranformed = String(char, radix: 2)
            while tranformed.count < 8 {
                tranformed = "0" + tranformed
            }
            let binary = "\(tranformed) "
            result.append(binary)
        }
        return result
    }
}

//MARK: - Hexadecimal
// REF: https://stackoverflow.com/questions/40605484/swift3-convert-string-value-to-hexadecimal-string
extension String {
    func stringToHex(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }
}

//MARK: - SHA256

extension String {
    func hash256() -> String {
        let inputData = Data(utf8)
        
        if #available(iOS 13.0, *) {
            let hashed = SHA256.hash(data: inputData)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            inputData.withUnsafeBytes { bytes in
                _ = CC_SHA256(bytes.baseAddress, UInt32(inputData.count), &digest)
            }
            return digest.makeIterator().compactMap { String(format: "%02x", $0) }.joined()
        }
    }
}


