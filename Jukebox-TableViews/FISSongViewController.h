//
//  FISSongViewController.h
//  Jukebox-TableViews
//
//  Created by Gan Chau on 6/17/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FISPlaylist.h"

@interface FISSongViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) FISPlaylist *playlist;

@end
