//
//  UpdatePlanCollectionViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 14/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit



class Cell: ScalingCarouselCell {}

class UpdatePlanCollectionViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var carouselBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var output: UILabel!
    
    var amountArray = ["1", "9", "99"]
    var decimalArray = [".99", ".99", ".00"]
    var storageArray = ["100gb", "1tb", ".10tb"]
    var colorArray = [#colorLiteral(red: 0.359110117, green: 0.7624588609, blue: 0.8323337436, alpha: 1), #colorLiteral(red: 0.7064456344, green: 0.8312065005, blue: 0.5807609558, alpha: 1), #colorLiteral(red: 0.9670340419, green: 0.7922397852, blue: 0.8196813464, alpha: 1)]
    
    
    private struct Constants {
        static let carouselHideConstant: CGFloat = -250
        static let carouselShowConstant: CGFloat = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // carouselBottomConstraint.constant = Constants.carouselHideConstant
        
//        carouselBottomConstraint.constant = (carouselBottomConstraint.constant == Constants.carouselShowConstant ? Constants.carouselHideConstant : Constants.carouselShowConstant)
//        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.layoutIfNeeded()
//        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carousel.deviceRotated()
    }
    // MARK: - Button Actions
    
    @IBAction func showHideButtonPressed(_ sender: Any) {
        
        carouselBottomConstraint.constant = (carouselBottomConstraint.constant == Constants.carouselShowConstant ? Constants.carouselHideConstant : Constants.carouselShowConstant)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

typealias CarouselDatasource = UpdatePlanCollectionViewController
extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
           // scalingCell.mainView.backgroundColor = .red
            
            scalingCell.amountLabel.text = amountArray[indexPath.row]
            scalingCell.decimalAmountLabel.text = decimalArray[indexPath.row]
            scalingCell.storageLabel.text = storageArray[indexPath.row]
            scalingCell.buyNowBtn.backgroundColor = colorArray[indexPath.row]



        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

typealias CarouselDelegate = UpdatePlanCollectionViewController
extension UpdatePlanCollectionViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
        
     //   output.text = String(describing: currentCenterIndex)
    }
}

private typealias ScalingCarouselFlowDelegate = UpdatePlanCollectionViewController
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
