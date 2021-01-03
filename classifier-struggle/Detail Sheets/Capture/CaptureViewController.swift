/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The main view controller for this sample app.
 */

import UIKit
import AVFoundation
import YPImagePicker

/**
 Handles the image picker, adds overlay to camera.
 See [this website](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/customizing_an_image_picker_controller) for details.
 */
public class CaptureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    weak var delegate: CaptureView.Coordinator?
    
    /// An image picker controller instance.
    var imagePickerController = UIImagePickerController()
    
    var didTakePicture = false
    
    // MARK: - View Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePickerController.modalPresentationStyle = .currentContext
        /*
         Assign a delegate for the image picker. The delegate receives
         notifications when the user picks an image or movie, or exits the
         picker interface. The delegate also decides when to dismiss the picker
         interface.
         */
        imagePickerController.delegate = self
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        //        if !didTakePicture {
        //            showImagePicker()
        //        }
        switch delegate?.sourceType {
        case .camera:
            showYT()
        case .photoLibrary:
            showImagePicker()
        default:
            showImagePicker()
        }
    }
    
    // MARK: - Toolbar Actions
    
    func showImagePicker() {
        
        switch delegate?.sourceType {
        case .camera:
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        case .photoLibrary:
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        default:
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        // MARK: Overlay
        
        if delegate?.sourceType == .camera {
            
            let overlayRect = CGRect(x: 40, y: 125, width: 304, height: 194)
            
            let imageLayer = CALayer()
            imageLayer.frame = overlayRect
            imageLayer.contents = UIImage(named: "overlay")!.cgImage
            
            imagePickerController.view.layer.addSublayer(imageLayer)
        }
        
        /*
         The creation and configuration of the camera or media browser
         interface is now complete.
         
         Asynchronously present the picker interface using the
         `present(_:animated:completion:)` method.
         */
        present(imagePickerController, animated: true, completion: {
            // The block to execute after the presentation finishes.
        })
    }
    
    func finishAndDismiss() {
        dismiss(animated: true, completion: {
            /*
             The dismiss method calls this block after dismissing the image picker
             from the view controller stack. Perform any additional cleanup here.
             */
        })
        self.didTakePicture = true
        self.delegate?.isShown = false
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    /**
     You must implement the following methods that conform to the
     `UIImagePickerControllerDelegate` protocol to respond to user interactions
     with the image picker.
     
     When the user taps a button in the camera interface to accept a newly
     captured picture, the system notifies the delegate of the user’s choice by
     invoking the `imagePickerController(_:didFinishPickingMediaWithInfo:)`
     method. Your delegate object’s implementation of this method can perform
     any custom processing on the passed media, and should dismiss the picker.
     The delegate methods are always responsible for dismissing the picker when
     the operation completes.
     */
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }
        let recognitionHandler = ModelDataHandler(
            modelFileInfo: MobileNet.modelInfo,
            labelsFileInfo: MobileNet.labelsInfo
          )
        self.delegate!.result = recognitionHandler!.runModel(photo: image)
        finishAndDismiss()
        self.delegate?.isModalShown = true
    }
    
    /**
     If the user cancels the operation, the system invokes the delegate's
     `imagePickerControllerDidCancel(_:)` method, and you should dismiss the
     picker.
     */
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        finishAndDismiss()
    }
    
    func showYT() {
        
        // in YPCameraView.swift line 30 overlayView was moved to the top of view hierarchy
        // to fix focus on tap as in the issue below
        // https://github.com/Yummypets/YPImagePicker/pull/287
        
        // in YPLibraryVC.swift line 247 function checkPermissionToAccessPhotoLibrary
        // ".limited" was removed from the switch cases
        // to fix building for iOS 13.0
        
        var config = YPImagePickerConfiguration()
        
        config.showsPhotoFilters = false
        config.screens = [.photo]
        config.hidesStatusBar = true
        config.onlySquareImagesFromCamera = false
        config.targetImageSize = YPImageSize.original
        config.shouldSaveNewPicturesToAlbum = false
        config.usesFrontCamera = false

        // replace default capture icon
        // https://github.com/Yummypets/YPImagePicker/issues/402
        // get capture icon from system icon
        let newCapturePhotoImage = UIImage(systemName: "largecircle.fill.circle")?
            .imageWith(newSize: CGSize(width: 168, height: 168))
            .withTintColor(.systemYellow)
            ?? config.icons.capturePhotoImage
        
        config.icons.capturePhotoImage = newCapturePhotoImage
        
//        config.icons.flashAutoIcon = config.icons.flashAutoIcon.withTintColor(.systemYellow)
//        config.icons.flashOffIcon = config.icons.flashOffIcon.withTintColor(.systemYellow)
        config.icons.flashOnIcon = config.icons.flashOnIcon.withTintColor(.systemYellow)
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                self.delegate?.result = nil
                
                picker.dismiss(animated: true, completion: nil)
                
                self.delegate?.isShown = false
                
                self.delegate?.isModalShown = false
            }
            
            if let photo = items.singlePhoto {
                
                guard let recognitionHandler = ModelDataHandler(
                    modelFileInfo: MobileNet.modelInfo,
                    labelsFileInfo: MobileNet.labelsInfo
                ) else {
                    return
                }
                self.delegate?.result = recognitionHandler.runModel(photo: photo.image)
                
                picker.dismiss(animated: true, completion: nil)
                
                self.delegate?.isShown = false
                
                self.delegate?.isModalShown = true
            }
            
        }
        
        let overlayRect = CGRect(x: 40, y: 200, width: 304, height: 194)
        
        let imageLayer = CALayer()
        imageLayer.frame = overlayRect
        imageLayer.contents = UIImage(named: "overlay")!.cgImage
        
        picker.view.layer.addSublayer(imageLayer)
        
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - Utilities
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
