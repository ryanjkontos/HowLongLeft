//
//  CustomTextField.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 15/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {

  class Coordinator: NSObject, UITextFieldDelegate {

     @Binding var text: String
     @Binding var nextResponder : Bool?
     @Binding var isResponder : Bool
      var placeholder: String
      
      var onEndEditing: ((String?) -> ())
      
      init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool>, placeholder: String, onEndEditing: @escaping (String?) -> ()) {
          self.onEndEditing = onEndEditing
       _text = text
       _isResponder = isResponder
       _nextResponder = nextResponder
          self.placeholder = placeholder
     }

     func textFieldDidChangeSelection(_ textField: UITextField) {
       text = textField.text ?? ""
     }
   
     func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.isResponder = true
        }
     }
   
     func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.onEndEditing(textField.text)
            // print("Ended editing")
            self.isResponder = false
            if self.nextResponder != nil {
                self.nextResponder = true
            }
        }
     }
      
      
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          
          self.isResponder = false
          return true
      }
 }

 @Binding var text: String
 @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool
    
    var onEndEditing: ((String?) -> ())
    
    var placeholder: String

 var isSecured : Bool = false
 var keyboard : UIKeyboardType

    var textField: UITextField?
    
 func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
    let textField = UITextField(frame: .zero)
     textField.placeholder = placeholder
     textField.isSecureTextEntry = isSecured
     textField.autocapitalizationType = .none
     textField.autocorrectionType = .no
     textField.keyboardType = keyboard
     textField.delegate = context.coordinator
     textField.tintColor = .orange
     textField.returnKeyType = .done
     textField.clearButtonMode = .whileEditing
     
     return textField
 }

 func makeCoordinator() -> CustomTextField.Coordinator {
     return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder, placeholder: placeholder, onEndEditing: onEndEditing)
 }

 func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
      uiView.text = text
     
      if isResponder {
          uiView.becomeFirstResponder()
      } else {
          // print("Resign")
          uiView.endEditing(true)
      }
 }

}
