//
//  FISSongViewController.m
//  Jukebox-TableViews
//
//  Created by Gan Chau on 6/17/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "FISSongViewController.h"
#import "FISSong.h"

@interface FISSongViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *songProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *songPlayingLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumPlayingLabel;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;

@end

@implementation FISSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlist.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    
    NSUInteger row = indexPath.row;
    FISSong *song = self.playlist.songs[row];
    cell.textLabel.text = song.title;
    cell.detailTextLabel.text = song.artist;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISSong *selectedSong = self.playlist.songs[indexPath.row];
    NSString *artistAlbum = [NSString stringWithFormat:@"%@ - %@", selectedSong.artist, selectedSong.album];
    self.songPlayingLabel.text = selectedSong.title;
    self.artistAlbumPlayingLabel.text = artistAlbum;

    [self setupAVAudioPlayWithFileName:selectedSong.fileName];
    //[self.songProgressBar setProgress:0.1 animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];
    [self.audioPlayer play];
    [self.controlButton setBackgroundImage:[UIImage imageNamed:@"stop_icon"] forState:UIControlStateNormal];

}

- (void)updateProgressBar:(NSTimer *)timer
{
    CGFloat currentProgress = self.audioPlayer.currentTime / self.audioPlayer.duration;
    [self.songProgressBar setProgress:currentProgress animated:YES];
}

- (void)setupAVAudioPlayWithFileName:(NSString *)fileName
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:fileName
                                         ofType:@"mp3"]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:url
                        error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
}

- (IBAction)controlButtonPressed:(id)sender
{
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [self.controlButton setBackgroundImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
    } else {
        [self.audioPlayer play];
        [self.controlButton setBackgroundImage:[UIImage imageNamed:@"stop_icon"] forState:UIControlStateNormal];
    }
}

- (IBAction)segmentedControlPressed:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.playlist sortSongsByTitle];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        [self.playlist sortSongsByArtist];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        [self.playlist sortSongsByAlbum];
    }
    [self.songsTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
