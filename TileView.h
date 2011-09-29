//
//  TileView.h
//  DummyProject
//
//  Created by Vignesh R on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView
{
    int gap;
    NSMutableArray *buttonTiles;
    NSMutableArray *correctOrder;
    BOOL shuffle;
    NSTimer *shuffleTimer;
}

-(NSArray *)pointsAroundGapPoint;
-(NSArray *)getTileImagesFromUIImage:(UIImage *)image;
-(BOOL)ispuzzleSolved;
-(void)shuffleTiles;
-(void)exchageGapWithTappedIndex:(int)tappedIndex;

@end
