//
//  ViewController.m
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/27.
//

#import "PMAlertController.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btAction:(id)sender {
    
    PMAlertController *vc = [PMAlertController alertControllerWithTitle:@"Test" message:@"AAAAAA"
                                                         preferredStyle:PMAlertControllerStyleAlert];
    [vc addAction:[PMAlertAction actionWithTitle:@"确定" style:PMAlertActionStyleDefault handler:^(PMAlertAction * _Nonnull action) {

    }]];
    
    [vc addAction:[PMAlertAction actionWithTitle:@"AAA" style:PMAlertActionStyleDefault handler:^(PMAlertAction * _Nonnull action) {

    }]];
    
    [vc addAction:[PMAlertAction actionWithTitle:@"取消" style:PMAlertActionStyleCancel handler:^(PMAlertAction * _Nonnull action) {

    }]];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
