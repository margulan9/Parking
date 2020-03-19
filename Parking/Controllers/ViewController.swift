//
//  ViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 1/29/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentUser: User?
    
    let infoSliders = [InfoSlider(label1: "Smart Parking", title: "Sign In or Sign Up", subtitle: "Create an account and add your vehicle"),
    InfoSlider(label1: "Smart Parking", title: "Choose a parking zone", subtitle: "Choose parking zone where you want to park and park your vehicle"),
    InfoSlider(label1: "Smart Parking", title: "Once you parked", subtitle: "Application will count every minute of your parking time and manage available places of parking")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = infoSliders.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil {
            transitionToTabBar()
        }
    }
    func transitionToTabBar() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
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

