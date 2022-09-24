//
//  TextFieldAlert.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 14/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

public struct AlertConfiguration {
    public var showTextField: Bool
    public var title: String // Title of the dialog
    public var message: String? // Dialog message
    public var prefill: String?
    public var placeholder: String = "" // Placeholder text for the TextField
    public var accept: String = "OK" // The left-most button label
    public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
    public var secondaryActionTitle: String? = nil // The optional center button label
    public var secondaryActionStyle: UIAlertAction.Style = .default // The optional center button label
    public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
    public var action: ((String?) -> Void)? // Triggers when either of the two buttons closes the dialog
    public var secondaryAction: (() -> Void)? = nil // Triggers when the optional center button is tapped

}

extension UIAlertController {
    convenience init(alert: AlertConfiguration) {
        
      self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        self.view.tintColor = .orange
        
        if alert.showTextField {
          addTextField {
             $0.placeholder = alert.placeholder
             $0.keyboardType = alert.keyboardType
              
              $0.text = alert.prefill
              
          }
        }
        
          if let cancel = alert.cancel {
            addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
              alert.action?(nil)
            })
          }
      
      let textField = self.textFields?.first
        textField?.clearButtonMode = .always
       
      addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
        alert.action?(textField?.text)
      })
        
        if let secondaryActionTitle = alert.secondaryActionTitle {
            addAction(UIAlertAction(title: secondaryActionTitle, style: alert.secondaryActionStyle, handler: { _ in
             alert.secondaryAction?()
           }))
        }
        
    }
  }

struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var show: Bool
  var alert: AlertConfiguration?
  let content: Content

  func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
    UIHostingController(rootView: content)
  }

  final class Coordinator {
    var alertController: UIAlertController?
    init(_ controller: UIAlertController? = nil) {
       self.alertController = controller
    }
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }

  func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
      
   
      
    uiViewController.rootView = content
    if var alert = alert, uiViewController.presentedViewController == nil {
      
      alert.action = {
          self.alert?.action?($0)
          self.show = false
      }
      context.coordinator.alertController = UIAlertController(alert: alert)
      uiViewController.present(context.coordinator.alertController!, animated: true)
        DispatchQueue.main.async {
            context.coordinator.alertController?.textFields?.first?.becomeFirstResponder()
        }
    }
    if alert == nil && uiViewController.presentedViewController == context.coordinator.alertController {
      uiViewController.dismiss(animated: true)
    }
  }
}


extension View {
    public func textFieldAlert(show: Binding<Bool>, configuration: AlertConfiguration?) -> some View {
        AlertWrapper(show: show, alert: configuration, content: self)
  }
}
