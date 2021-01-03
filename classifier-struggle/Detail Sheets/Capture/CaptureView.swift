//
//  CameraView.swift
//  CameraAndGalleryTutorial
//
//  Created by Anton Davydov on 20.07.2020.
//  Copyright © 2020 Duy Bui. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

/**
 Shows an image picker that shows either gallery images or a camera with an overlay.
*/
public struct CaptureView {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var isModalShown: Bool
    @Binding var result: Result?
    var sourceType: Coordinator.SourceType
    
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown,
                                  isModalShown: $isModalShown,
                                  result: $result,
                                  sourceType: sourceType)
    }
}

extension CaptureView: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureView>) -> CaptureViewController {
        
        //Load the storyboard
        let loadedStoryboard = UIStoryboard(name: "CaptureStoryboard", bundle: nil)
        let pickerController = loadedStoryboard.instantiateViewController(withIdentifier: "pickerVC") as! CaptureViewController
        pickerController.delegate = context.coordinator
        
        //Load the ViewController
        return pickerController
        
    }
    
    public func updateUIViewController(_ uiViewController: CaptureViewController, context: UIViewControllerRepresentableContext<CaptureView>) {
    }
    
}


extension CaptureView {
    public class Coordinator: NSObject {
        
        enum SourceType: String, CaseIterable, Hashable, Identifiable, CustomStringConvertible {
            case camera
            case photoLibrary
            
            var name: String {
                return "\(self)".map {
                    $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
            }
            
            var id: SourceType {self}
            
            var description: String {
                rawValue.prefix(1).uppercased() + rawValue.dropFirst()
            }
        }
        
        @Binding var isShown: Bool
        @Binding var isModalShown:Bool
        @Binding var result: Result?
        var sourceType: SourceType
        
        init(isShown: Binding<Bool>,
             isModalShown: Binding<Bool>,
             result: Binding<Result?>,
             sourceType: SourceType) {
            
            _isShown = isShown
            _isModalShown = isModalShown
            _result = result
            self.sourceType = sourceType
            
        }
        
    }
}
