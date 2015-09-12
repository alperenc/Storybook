//
//  StoryPartViewController.m
//  Storybook
//
//  Created by Alp Eren Can on 11/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "StoryPartViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Story.h"

@interface StoryPartViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (strong, nonatomic) Story *story;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.story = [[Story alloc] initWithTitle:@"First Story" author:@"Alp E. Can"];
    self.audioRecorder.delegate = self;
    
    if ([self.audioRecorder isRecording]) {
        self.recordButton.hidden = YES;
        self.stopButton.hidden = NO;
    } else {
        self.recordButton.hidden = NO;
        self.stopButton.hidden = YES;
    }
}

- (IBAction)chooseImage:(UIButton *)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    pickerController.mediaTypes = @[(__bridge NSString *)kUTTypeImage, (__bridge NSString *)kUTTypeMovie];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo or Video" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerController animated:YES completion:nil];
            
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        self.player = [AVPlayer playerWithURL:url];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        playerLayer.frame = self.imageView.frame;
        
        [self.view.layer addSublayer:playerLayer];
        
        
        [self.player play];
        
        
    } else {
        self.story.coverImage = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = self.story.coverImage;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recordAudio:(UIButton *)sender {
    self.recordButton.hidden = YES;
    self.stopButton.hidden = NO;
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"audio.aac"];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    
    self.story.audioURL = fileURL;
    
    NSDictionary *recordSettings = @{
                                     AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                     AVLinearPCMBitDepthKey:@16,
                                     AVLinearPCMIsBigEndianKey:@0,
                                     AVLinearPCMIsFloatKey:@0,
                                     AVNumberOfChannelsKey:@2,
                                     AVSampleRateKey:@44100
                                     };;
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:recordSettings error:nil];
    
    [self.audioRecorder record];
}

//-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
//    if (flag) {
//        self.story.audioURL = [recorder url];
//    }
//}

- (IBAction)playAudio:(UITapGestureRecognizer *)sender {
    
    self.player = [AVPlayer playerWithURL:self.story.audioURL];
    
    [self.player play];
}

- (IBAction)stopRecording:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    self.recordButton.hidden = NO;
    self.stopButton.hidden = YES;
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
