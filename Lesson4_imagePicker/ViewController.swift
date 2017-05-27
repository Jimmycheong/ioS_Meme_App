//
//  ViewController.swift
//  Lesson4_imagePicker
//
//  Created by Jimmy Cheong on 26/05/2017.
//  Copyright © 2017 jimmycheong. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Structs
    
    struct Meme {
        
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
        
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Delegates
    
    let customField = customTextFieldDelegate()
    
    
    // MARK: LifeCycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the share button if no image is selected yet.
        shareButton.isEnabled = false
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.red,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSParagraphStyleAttributeName: style,
            NSStrokeWidthAttributeName: 0.0]
        
        topTextField.delegate = customField
        bottomTextField.delegate = customField
        navigationBar.delegate = self as? UINavigationBarDelegate
        toolBar.delegate = self as? UIToolbarDelegate
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
    }

    
    // MARK: Keyboard toggle
    
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        print("Keyboard height: " + String(describing: keyboardSize.cgRectValue.height))
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    }
    
    // MARK: Image Picker methods
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            print("Enabled sharebutton")
            shareButton.isEnabled = true

        }
        
        
        dismiss(animated: true, completion: nil)
        
    }

    // MARK: Saving & Share Meme methods
    
    @IBAction func shareAction(_ sender: Any) {
    
        let genImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [genImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide the navigation bar and toolbar
        
        print("Hiding nav and tool bars")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)

        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show the navigation bar and toolbar
        print("Showing nav and tool bars")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
        
    }
    

    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    

}

