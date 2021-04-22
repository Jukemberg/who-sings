//
//  Utils.swift
//  WhoSings
//
//  Created by netfarm on 05/04/21.
//

import Foundation
import UIKit

class DarkVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .systemGray5
    }
    
}

func createALImage(from resource:String, aspect:UIView.ContentMode = .scaleAspectFill) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: resource)
    imageView.contentMode = aspect
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}

func createALLabel(text:String?, font:UIFont, color:UIColor = .white, textAlign:NSTextAlignment = .left) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = color
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = textAlign
    return label
}

func createALTextView(text:String?, font:UIFont, color:UIColor = .white, textAlign:NSTextAlignment, editable:Bool = false, scrollable:Bool = false) -> UITextView {
    let textView = UITextView()
    textView.backgroundColor = .clear
    textView.text = text
    textView.font = font
    textView.textColor = color
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textAlignment = textAlign
    textView.isEditable = editable
    textView.isScrollEnabled = scrollable
    return textView
}

func createBorderALButton(title:String?) -> UIButton{
    return createALButton(type: .custom, title: title, font: .systemFont(ofSize: 24), border: true)
}

func createALButton(type:UIButton.ButtonType, title:String?, font:UIFont, title_color:UIColor = .white, image:UIImage? = nil, border:Bool = false) -> UIButton {
    let button = UIButton(type: type)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = font
    button.titleLabel?.lineBreakMode = .byTruncatingTail
    button.setTitleColor(title_color, for: .normal)
    if (image != nil) {
        button.tintColor = title_color
        button.setImage(image, for: .normal)
        button.imageEdgeInsets.left = 8
    }
    if border {
        button.titleEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = title_color.cgColor
    }
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

func createALStackView(spacing:CGFloat, axis:NSLayoutConstraint.Axis = .vertical, distribution:UIStackView.Distribution = .equalSpacing, color:UIStackView.Alignment = .center) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis  = axis
    stackView.distribution  = distribution
    stackView.alignment = .center
    stackView.spacing = spacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
}

func createALSubView() -> UIView {
    let subView = UIView()
    subView.backgroundColor = .clear
    subView.translatesAutoresizingMaskIntoConstraints = false
    return subView
}

func getPlayerNameAlert(completionHandler: @escaping (_ player_name:String?) -> ()) -> UIAlertController{
    let alertController = UIAlertController(title: "What's your name?", message: "", preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = "Name"
        textField.text = player_name
        textField.keyboardType = .default
    }
    let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
        guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
        let new_player_name = textField.text
        player_name = new_player_name
        completionHandler(new_player_name)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    return alertController
}


func getErrorWithRetryAlert(error:String?, code:Int?, completionHandler: @escaping (_ retry:Bool) -> ()) -> UIAlertController{
    let alertController = UIAlertController(title: "An error as occurred \(code ?? 400)", message: error, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Retry", style: .default) { _ in completionHandler(true) }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) }
    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    return alertController
}

public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
