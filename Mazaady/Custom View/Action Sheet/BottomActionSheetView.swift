//
//  BottomActionSheetView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class BottomActionSheetView: UIView {
    
    private let containerView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 16
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.backgroundColor = .white
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var darkView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray.withAlphaComponent(0.5)
        v.alpha = 0
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        return v
    }()
    
    private lazy var dragingInvisibleView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:))))
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        return v
    }()
    
    private let dragView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray.withAlphaComponent(0.5)
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()
    
    private let hasDarkView:Bool
    private var dragingInvisibleViewHeightAnchor:NSLayoutConstraint!
    private var cardViewHeightAnchor:NSLayoutConstraint!
    private var cardViewTopAnchor:NSLayoutConstraint!
    private let height:CGFloat = 250
    internal var cardViewHeight:CGFloat {
        return height
    }
    internal var hasExpanded:Bool = false
    internal var openOnSwipeDown:Bool {
        return false
    }
    internal var expandableHeight:CGFloat? {
        return nil
    }
    internal var isOpened:Bool = false
    var onPanCardView:((_ setActive:Bool, _ fromPan:Bool)->())?
    var didClickOnDragView: (()->())?
    var didFinishAction: ((_ isOpen: Bool)->())?
    
    deinit {
        print("Card view has been deinit")
    }
    
    init(includeDarkView:Bool) {
        self.hasDarkView = includeDarkView
        super.init(frame: .zero)
        setupView()
        setupViews()
        setupAutolayouts()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 16.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc private func dragAction(_ sender:UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        
        let y = sender.translation(in: superview).y
        if y > .zero {
            transform = .init(translationX: 0, y: y)
        } else {
            onPanCardView?(false, true)
            cardViewTopAnchor.constant = -(cardViewHeight)+y
            cardViewHeightAnchor.constant = (cardViewHeight) + abs(y)
            layoutIfNeeded()
        }
        endEditing(false)
        
        if sender.state == .ended {
            let velocityY = sender.velocity(in: superview).y
            if velocityY < -150 && !hasExpanded {
                hasExpanded = true
                performCardViewAnimation(state: true, isDeinit: false)
            } else if y < .zero && abs(y) < superview.frame.height/3 {
                hasExpanded = false
                performCardViewAnimation(state: true, isDeinit: false)
            } else if y < .zero && abs(y) > superview.frame.height/4 && expandableHeight != nil  {
                hasExpanded = true
                performCardViewAnimation(state: true, isDeinit: false)
            } else {
                hasExpanded = false
                performCardViewAnimation(state: openOnSwipeDown, isDeinit: false)
            }
        }
    }
    
    @objc private func tapAction(_ sender:UITapGestureRecognizer) {
        didClickOnDragView?()
        hasExpanded = !hasExpanded
        performCardViewAnimation(state: openOnSwipeDown, isDeinit: false)
    }
    
    func setupViews() {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard var superWindow = keyWindow?.rootViewController?.view else { return }
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                superWindow = topController.view
            }
        }
        
        if hasDarkView {
            superWindow.addSubview(darkView)
            darkView.fillSuperview(isSafeArea: false)
            superWindow.bringSubviewToFront(self)
        }
        
        superWindow.addSubview(self)
        anchor(top: nil, leading: superWindow.leadingAnchor, bottom: nil, trailing: superWindow.trailingAnchor, padding: .zero)
        
        cardViewHeightAnchor = heightAnchor.constraint(equalToConstant: cardViewHeight)
        cardViewHeightAnchor.isActive = true
        cardViewTopAnchor = topAnchor.constraint(equalTo: superWindow.bottomAnchor, constant: 0)
        cardViewTopAnchor.isActive = true
        
        addSubview(containerView)
        addSubview(dragView)
        addSubview(dragingInvisibleView)
        bringSubviewToFront(dragingInvisibleView)
    }
    
    func setupAutolayouts() {
        containerView.fillSuperview(isSafeArea: false)
        dragView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dragView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dragView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        dragView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        dragingInvisibleView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero)
        dragingInvisibleViewHeightAnchor = dragingInvisibleView.heightAnchor.constraint(equalToConstant: 44)
        dragingInvisibleViewHeightAnchor.isActive = true
    }
    
    func performCardViewAnimation(state open:Bool, isDeinit:Bool) {
        guard !isDeinit else {
            darkView.removeFromSuperview()
            self.removeFromSuperview()
            return
        }
        isOpened = open
        cardViewTopAnchor.constant = open ? -(cardViewHeight) : 0
        cardViewHeightAnchor.constant = (cardViewHeight)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            guard let superWindow = self.superview else { return }
            superWindow.layoutIfNeeded()
            if !self.hasExpanded {
                self.transform = .identity
            }
            self.darkView.alpha = open ? 1 : 0
        }) { (isFinished) in
            guard isFinished else { return }
            self.didFinishAction?(open)
            if !self.hasExpanded {
                self.onPanCardView?(true, false)
            } else {
                self.onPanCardView?(false, false)
            }
        }
    }
    
    func getCardViewHeight()->CGFloat {
        return height
    }
    
    func setDragHeight(value:CGFloat) {
        bringSubviewToFront(dragingInvisibleView)
        dragingInvisibleViewHeightAnchor.constant = value
        layoutIfNeeded()
    }
    
    func getDragViewHeight()->CGFloat {
        return dragingInvisibleViewHeightAnchor.constant
    }
    
    
    func addViewToContainer(_ view:UIView) {
        containerView.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
