//
//  View+Modal.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import SwiftUI

struct ModalView<T: View>: UIViewControllerRepresentable {
    let view: T
    @Binding var isModal: Bool
    let onDismissalAttempt: (()->())?
    
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        let modalView: ModalView
        
        init(_ modalView: ModalView) {
            self.modalView = modalView
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            modalView.isModal
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            modalView.onDismissalAttempt?()
        }
    }
}

extension View {
    func presentation(isModal: Binding<Bool>, onDismissalAttempt: (()->())? = nil) -> some View {
        ModalView(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}

struct ModalViewBool<T: View>: UIViewControllerRepresentable {
    let view: T
    @State var isModal: Bool
    let onDismissalAttempt: (()->())?
    
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        let modalView: ModalViewBool
        
        init(_ modalView: ModalViewBool) {
            self.modalView = modalView
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            modalView.isModal
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            modalView.onDismissalAttempt?()
        }
    }
}

extension View {
    func presentationBool(isModal: Bool, onDismissalAttempt: (()->())? = nil) -> some View {
        ModalViewBool(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}
