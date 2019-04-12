//
//  MealCollectionViewController.swift
//  Recipes
//
//  Created by SunXinzhuo on 4/12/19.
//  Copyright © 2019 FV iMAGINATION. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MealCollectionViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
}

extension MealCollectionViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
        var meals = [Meal(title: "Stuffed Cucumber",
                          featuredImage: UIImage(named: "cucumber.jpg") as! UIImage),
                     Meal(title: "Black Bean Breakfast Burrito", featuredImage: UIImage(named: "burrito.jpg") as! UIImage)]
        cell.meal = meals[indexPath.item]
        return cell
    }
}

extension MealCollectionViewController: UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewLayout
        //        let cellWidthIncludingSpacing =
    }
}
