//
//  ViewController.swift
//  DAY03
//
//  Created by Zuleykha Pavlichenkova on 11.08.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // приложение должно отображать скаченные из интернета картинки, для этого нужен массив картинок
    let pictureURLs: [URL] = [
        URL(string: "https://apod.nasa.gov/apod/image/2112/JupiterStorms_JunoGill_1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2208/M16_final_1024.jpg")!,
        URL(string: "https://apod.nasa.gov/_final_1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2108/ThreeNightsPerseids1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2204/JupiterDarkSpot_JunoTT_1080.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2201/JupiterOpal_HubbleMasztalerz_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2111/ActiveSun_NuSTAR_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2207/EuropaJupiter_Voyager_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2204/ISS002-E-7377_1024c.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2207/C2017k2cumuloM10v4_1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2207/FindTheMoon_soltanolkotabi_1080.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2207/Phobos_MRO_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2206/gamma-cygni-nebula-and-sadr1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2204/LyridoverChinaJeffDai1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2203/Arp244-LRGB1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2202/NGC4945-Dietmar-Eric-crop1024.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2202/TerminatorMoon_Shet_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2202/HeartB_Jensen_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2202/Ngc6217_Hubble_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2204/DevilsWay_Kiczenski_960.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2206/M51_HubbleMiller_1080.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2208/MeteorM31_hemmerich_960.jpg")!
    ]
    
    // создаею CollectionView с вертикальным скроллингом
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        return collectionView
    }()
    
    // после загрузки вышестоящего вью нужно добавить в него как сабвью выше созданный collectionView, а также в нем регистрирую ячейку
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Images"
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // numberOfItemsInSection (ячеек)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs.count // будет отображать ровно столько, сколько в массиве pictureURLs
    }
    
    // cellForItemAt - именно тут конфигурируются ячейки - в них передаются картинки, см метод configure() у класса ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let imageURLForCell = pictureURLs[indexPath.item]
        cell.configureCell(with: imageURLForCell, errorHandler: showError)
        
        return cell
    }
    
    // функция для отображения алерта, передается в configure() как параметр и будет отображаться в collectionView
    func showError(with url: URL) {
        let alert = UIAlertController(title: "Error", message: "Cannot access to \(url)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // задаем размер каждой картинки относительно размера фрейма
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (view.frame.size.width/3) - 3
        return CGSize(
            width: size,
            height: size
        )
    }
    
    // minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    //insetForSectionAt какие-то расстрояния в сетке коллекшен вью
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    // пока тут только распечатывается, когда что-то нажму
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let cell = collectionView.visibleCells.
        // create ViewController and push it into navigation stack
        let viewController = PhotoViewController()
        let urlForImage = pictureURLs[indexPath.item]
//        print(">>>", urlForImage)
        guard let image = DefaultImageCache.shared.getImage(forKey: urlForImage.absoluteString) else { return }
        
        viewController.configure(with: image)
        
        navigationController?.pushViewController(viewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

