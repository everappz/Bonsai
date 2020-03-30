//
//  ViewController.swift
//  BonsaiController
//
//  Created by Warif Akhand Rishi on 22/5/18.
//  Copyright © 2018 Warif Akhand Rishi. All rights reserved.
//

import UIKit
import BonsaiController
import AVKit // Needed for AVPlayerViewController example

private enum TransitionType {
    case none
    case bubble
    case slide(fromDirection: Direction)
    case menu(fromDirection: Direction)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var popButton: UIButton!
    
    private var transitionType: TransitionType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Show Small View controller
    private func showSmallVC(transition: TransitionType) {
        
        transitionType = transition
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SmallVC") as! SmallViewController
        vc.view.backgroundColor = UIColor(red: 208/255.0, green: 5/255.0, blue: 30/255.0, alpha: 1)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare Segue")
        
        if segue.destination is SmallViewController {
            transitionType = .slide(fromDirection: .bottom)
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
        }
    }
}

// MARK:- Button Actions
extension ViewController {
    
    // MARK: Slide in Buttons
    @IBAction func leftButtonAction(_ sender: Any) {
        print("Left Button Action")
        showSmallVC(transition: .slide(fromDirection: .left))
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        print("Right Button Action")
        showSmallVC(transition: .slide(fromDirection: .right))
    }
    
    @IBAction func topButtonAction(_ sender: Any) {
        print("Top Button Action")
        showSmallVC(transition: .slide(fromDirection: .top))
    }
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        print("Bottom Button Action")
        showSmallVC(transition: .slide(fromDirection: .bottom))
    }
    
    // MARK: Menu Buttons
    @IBAction func leftMenuButtonAction(_ sender: Any) {
        print("Left Menu Button Action")
        showSmallVC(transition: .menu(fromDirection: .left))
    }
    
    @IBAction func rightMenuButtonAction(_ sender: Any) {
        print("Right Menu Button Action")
        showSmallVC(transition: .menu(fromDirection: .right))
    }
    
    // MARK: Popup Button
    @IBAction func showAsPopupButtonAction(_ sender: Any) {
        print("Popup Button Action")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmallVC") as! SmallViewController
        BonsaiPopupUtility.shared.show(viewController: vc)
    }
    
    // MARK: Notification Button
    @IBAction func notificationButtonAction(_ sender: Any) {
        print("Notification Button Action")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SmallVC") as! SmallViewController
        BonsaiNotificationUtility.shared.show(viewController: vc)
    }
    
    // MARK: Bubble Button
    @IBAction func bubbleButtonAction(_ sender: Any) {
        print("Bubble Button Action")
        showSmallVC(transition: .bubble)
    }
    
    // MARK: Native Buttons
    @IBAction func imagePickerButtonAction(_ sender: Any) {
        print("Image Picker Button Action")
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Source type not available")
            return
        }
        
        transitionType = .slide(fromDirection: Direction.randomDirection())
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        
        imagePicker.transitioningDelegate = self
        imagePicker.modalPresentationStyle = .custom
        
        self.present(imagePicker, animated: true, completion: nil)
    }
        
    @IBAction func fullScreenPopButtonAction(_ sender: UIButton) {
        print("Video Player Button Action")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SmallVC") as! SmallViewController
        
        BonsaiFullScreenPopUtility.shared.show(viewController: vc, fromView: sender)
    }
}

// MARK:- BonsaiController Delegate
extension ViewController: BonsaiControllerDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var blurEffectStyle = UIBlurEffect.Style.dark
        
        if #available(iOS 13.0, *) {
            blurEffectStyle = .systemChromeMaterial
        }
        
        let backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        switch transitionType {
        case .none:
            return nil
            
        case .bubble:
            
            // With Blur Style
            // return BonsaiController(fromView: popButton, blurEffectStyle: blurEffectStyle,  presentedViewController: presented, delegate: self)
        
            // With Background Color
            return BonsaiController(fromView: popButton, backgroundColor: backgroundColor, presentedViewController: presented, delegate: self)
            
        case .slide(let fromDirection), .menu(let fromDirection):
            
            // With Blur Style
            // return BonsaiController(fromDirection: fromDirection, blurEffectStyle: blurEffectStyle, presentedViewController: presented, delegate: self)
            
            // With Background Color
            return BonsaiController(fromDirection: fromDirection, backgroundColor: backgroundColor, presentedViewController: presented, delegate: self)
        }
    }
    
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        switch transitionType {
        case .none:
            return CGRect(origin: .zero, size: containerViewFrame.size)
        case .slide:
            return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
        case .bubble:
            return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / 2))
        case .menu(let fromDirection):
            var origin = CGPoint.zero
            if fromDirection == .right {
                origin = CGPoint(x: containerViewFrame.width / 2, y: 0)
            }
            return CGRect(origin: origin, size: CGSize(width: containerViewFrame.width / 2, height: containerViewFrame.height))
        }
    }
    
    func didDismiss() {
        print("didDismiss")
    }
}
