//
//  CategoryControl.swift
//  Satz
//
//  Created by Yogesh Rokhade on 05.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@IBDesignable class CategoryControlView: UIView {
       
    private let categoryTitleLabel =  UILabel()
    private var categoryTitleView = UIView()
  
        
    @IBInspectable private var categoryTitle: String = "" {
        didSet{
            setCategoryTitle()
        }
    }
    @IBInspectable var bodyColor: UIColor? {
        didSet{
            layer.backgroundColor = bodyColor?.cgColor
        }
    }
    @IBInspectable var titleBackgroundColor: UIColor? {
        didSet{
            categoryTitleView.layer.backgroundColor = titleBackgroundColor?.cgColor
        }
    }
    @IBInspectable private var showCategories: Bool = false {
        didSet{
            updateCategories()
        }
    }
    
    private var categoryItems = [UIStackView]()
    private var categoryItemAndPictures = [CategoryItemView]()



    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()

    }
    
    private func setupView() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        //addTitleSubview()

    }
    
    private func updateCategories() {
        if showCategories == true {
            addCategories()
        }else{
            removeCategories()
        }
    }
    

    
    private func addCategories() {
        
        //creates a Hstackview
        let categoryItems = UIStackView(frame: CGRect(x: 15, y: 25, width: self.frame.width - 28, height: 100))
        categoryItems.axis = .horizontal
        categoryItems.alignment = .center
        categoryItems.distribution = .equalSpacing
        self.addSubview(categoryItems)
        
        let categoriesAvailable = [
            "All Day" : "chincoteague",
            "Office" : "rainbowlake",
            "Casual" : "yukon_charleyrivers",
            "News": "stmarylake"
                                    
        ]
        
        for key in categoriesAvailable.keys {
            let myCategoryItem = CategoryItemView()
            myCategoryItem.imageLabel = key
            myCategoryItem.imageToDisplay = UIImage(named: categoriesAvailable[key]!)
            myCategoryItem.statusLabel = ""
            myCategoryItem.translatesAutoresizingMaskIntoConstraints = false
            myCategoryItem.axis = .vertical
            categoryItems.addArrangedSubview(myCategoryItem)
            categoryItemAndPictures.append(myCategoryItem)
        }

        //adds Hstackview Content

    }
    
    private func removeCategories() {
        //removes Vstackview(Image, Label) in Hstackview
        for item:CategoryItemView in categoryItemAndPictures {
            item.removeAllSubViewswithContent()
        }
        //remove Hstackview
        for item: UIStackView in categoryItems {
            item.removeFromSuperview()
        }
    }

    
    private func addTitleSubview() {
        categoryTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        categoryTitleView.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.75)
        self.addSubview(categoryTitleView)
        
        categoryTitleLabel.frame = CGRect(x: 10, y: 2.5, width: self.frame.width, height: 15)
        setCategoryTitle()
        categoryTitleView.addSubview(categoryTitleLabel)
        
        
    }
    
    private func setCategoryTitle(){
        categoryTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        categoryTitleLabel.textAlignment = .left
        categoryTitleLabel.text = categoryTitle
        categoryTitleLabel.textColor = .black
    }


}
extension UIStackView {
    func addBackground() {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

