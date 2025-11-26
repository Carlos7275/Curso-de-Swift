import UIKit

class ReelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionVideos: UICollectionView!

    let videos: [Reels] = [
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", title: "Big Buck Bunny"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", title: "Elephants Dream"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", title: "Sintel"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", title: "Tears of Steel"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4", title: "Volkswagen GTI Review"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4", title: "Bullrun"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", title: "For Bigger Blazes"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", title: "For Bigger Escapes"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4", title: "For Bigger Fun"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4", title: "For Bigger Joyrides"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4", title: "For Bigger Meltdowns"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", title: "For Bigger Escapes 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4", title: "For Bigger Fun 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4", title: "For Bigger Joyrides 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4", title: "For Bigger Meltdowns 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", title: "Elephants Dream 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", title: "Sintel 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", title: "Tears of Steel 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4", title: "Volkswagen GTI Review 2"),
        Reels(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", title: "Big Buck Bunny 2")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionVideos.delegate = self
        collectionVideos.dataSource = self
        collectionVideos.clipsToBounds = true
        collectionVideos.isPagingEnabled = true
        collectionVideos.decelerationRate = .fast

        if let layout = collectionVideos.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.estimatedItemSize = .zero
        }

        collectionVideos.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
    }

  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionVideos.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        // Tamaño exacto de la celda: full screen menos safe area inferior
        let bottomInset = view.safeAreaInsets.bottom
        layout.itemSize = CGSize(width: collectionVideos.bounds.width,
                                 height: collectionVideos.bounds.height - bottomInset)
        
        layout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        if let url = URL(string: videos[indexPath.row].url) {
            cell.configure(videoURL: url, title: videos[indexPath.row].title) { [weak self] in
                guard let self = self else { return }
                let nextIndex = indexPath.row + 1
                if nextIndex < self.videos.count {
                    let nextIndexPath = IndexPath(row: nextIndex, section: 0)
                    self.collectionVideos.scrollToItem(at: nextIndexPath, at: .centeredVertically, animated: true)
                } else {
                    let firstIndexPath = IndexPath(row: 0, section: 0)
                    self.collectionVideos.scrollToItem(at: firstIndexPath, at: .centeredVertically, animated: true)
                }
            }
        }
        return cell
    }

    // MARK: - Auto play
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? VideoCell)?.play()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? VideoCell)?.pause()
    }

   
}
