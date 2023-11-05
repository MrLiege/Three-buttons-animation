//
//  ViewController.swift
//  Three buttons
//
//  Created by Artyom on 04.11.2023.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.systemBlue
        self.setTitleColor(.white, for: .normal)
        self.tintColor = .white
        let image = UIImage(systemName: "arrow.right.circle.fill")?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.semanticContentAttribute = .forceRightToLeft
        
        // - разная ширина. Отступ внутри кнопки от контента 10pt по вертикали и 14pt по горизонтали.
        // - Расстояние между текстом и иконкой 8pt.
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        self.layer.cornerRadius = 10
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        self.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     По нажатию анимировано уменьшать кнопку. Когда отпускаешь - кнопка возвращается к оригинальному размеру. Анимация должна быть прерываемая,
     например, кнопка возвращается к своему размеру, а в процессе анимации снова нажать на кнопку - анимация пойдет из текущего размера, без
     скачков.
     */
    //уменьшается
    @objc func touchDown(sender: UIButton!) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    //когда отпущена к первоначальному размеру
    @objc func touchUpInside(sender: UIButton!) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    //убираем палец, и кнопка опять первоначальному размеру
    @objc func touchDragExit(sender: UIButton!) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    //возвращаем палец, и кнопка уменьшается
    @objc func touchDragEnter(sender: UIButton!) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    //кнопка должны красится: фон в .systemGray2, а текст и иконка в .systemGray3.
    override func tintColorDidChange() {
        super.tintColorDidChange()
        if tintAdjustmentMode == .dimmed {
            self.backgroundColor = .systemGray2
            self.setTitleColor(.systemGray3, for: .normal)
            self.tintColor = .systemGray3
        } else {
            self.backgroundColor = .systemBlue
            self.setTitleColor(.white, for: .normal)
            self.tintColor = .white
        }
    }
}



class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonTitles = ["First Button", "Second Medium Button", "Third"]
        var previousButton: CustomButton? = nil
        
        for title in buttonTitles {
            let button = CustomButton(frame: .zero)
            button.setTitle(title, for: .normal)
            
            if title == "Third" {
                button.addTarget(self, action: #selector(presentModalViewController), for: .touchUpInside)
            }
            
            view.addSubview(button)

            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 10),
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
            }
            
            previousButton = button
        }
    }
    
    @objc func presentModalViewController() {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .pageSheet
        self.present(modalViewController, animated: true, completion: nil)
    }
}
    

