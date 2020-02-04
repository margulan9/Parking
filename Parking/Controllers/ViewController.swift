//
//  ViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 1/29/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let infoSliders = [InfoSlider(label1: "Slide 1", title: "Sign In or Sign Up", subtitle: "Create an account and add your vehicle"),
    InfoSlider(label1: "Slide 2", title: "Choose a parking zone", subtitle: "Choose parking zone where you want to park and park your vehicle"),
    InfoSlider(label1: "Slide 3", title: "Once you parked", subtitle: "Application will count every minute of your parking time and manage available places of parking")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = infoSliders.count
    }
    
    var currentIndex = 0
    


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoSliders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoSliderCell", for: indexPath) as! InfoSliderCell
               
               cell.label1.text = infoSliders[indexPath.item].label1
               cell.title.text = infoSliders[indexPath.item].title
               cell.subtitle.text = infoSliders[indexPath.item].subtitle
               return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
}

