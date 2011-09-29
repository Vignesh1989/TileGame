//
//  TileView.m
//  DummyProject
//
//  Created by Vignesh R on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TileView.h"

@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        float width = frame.size.width/4;
        float height = frame.size.height/4;
        int tag = 0 ;
        NSArray *tileImages = [self getTileImagesFromUIImage:[UIImage imageNamed:@"sanFran.jpg"]];
        buttonTiles= [[NSMutableArray alloc] init];
        correctOrder = [[NSMutableArray alloc] init];
         // Initialization code
        for (int i = 0 ; i < 4; i++) {
            for (int j =0 ; j< 4; j++)
            {
                 UIButton *tileButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [tileButton setBackgroundColor:[UIColor blueColor]];
                [tileButton setImage:[tileImages objectAtIndex:tag] forState:UIControlStateNormal];
                tileButton.imageEdgeInsets=UIEdgeInsetsMake(2,2,2,2);
                tileButton.frame = CGRectMake(width*j, height*i, width, height);
                tileButton.tag = tag++;
                [tileButton addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:tileButton];
                [buttonTiles addObject:tileButton];
                [correctOrder addObject:tileButton];
            }
        }
        [[self viewWithTag:tag-1] removeFromSuperview];
       
        gap = tag-1;
        shuffleTimer = nil;
        
    }
    return self;
}
-(NSArray *)getTileImagesFromUIImage:(UIImage *)image
{
   
    NSMutableArray *tileArray = [[[NSMutableArray alloc] init] autorelease];
    float width = image.size.width/4;
    float height = image.size.height/4;
    // Initialization code
    for (int i = 0 ; i < 4; i++) {
        for (int j =0 ; j< 4; j++)
        {
          
            [tileArray addObject: [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(width*j, height*i, width, height))]];
         
        }
    }
    
    
    return tileArray;
}
-(void)tileTapped:(id)sender
{
    if (!shuffle) 
    {
        if (!shuffleTimer)
        {
            shuffleTimer =  [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(shuffleTiles) userInfo:nil repeats:YES];
  
        }
        else
        {
            [shuffleTimer invalidate];
            shuffleTimer = nil;
            shuffle = YES;
        }
                
    }
    else
    {
        [self exchageGapWithTappedIndex:((UIButton*)sender).tag];
        if ([self ispuzzleSolved]) 
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"You have Won!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [view show];
            [view release];
        }

        
    }
    
  
}
-(BOOL)ispuzzleSolved
{
    int i = 0;
    int equal = 1;
    for (UIButton *button in buttonTiles) 
    {
        
        if (button.tag != ((UIButton *)[correctOrder objectAtIndex:i++]).tag) 
        {
            equal = 0;
        }
        
    }
    return equal;
}

-(NSArray *)pointsAroundGapPoint
{
    NSMutableArray *pts = [[[NSMutableArray alloc] init] autorelease];
    
    int prevRow = gap/4 -1;
    int nextRow =  gap/4 +1;
    int col = gap % 4;
    
 
        
    if (!(gap%4 == 0)) {
        [pts addObject:[NSNumber numberWithInt:gap-1]];
    }
    if (!(gap%4 == 3)) {
        [pts addObject:[NSNumber numberWithInt:gap+1]];
    }
    if (!(prevRow*4 +col < 0)) {
        [pts addObject:[NSNumber numberWithInt:prevRow*4 +col]];
    }
    if (!(nextRow*4+col > 15)) {
        [pts addObject:[NSNumber numberWithInt:nextRow*4 +col]];
    }
            
   
    return pts;
}
-(void)shuffleTiles
{
       
        NSArray *pointsAroungGap = [self pointsAroundGapPoint];
        int randomTile = arc4random() % [pointsAroungGap count];
        
        [self exchageGapWithTappedIndex:[[pointsAroungGap objectAtIndex:randomTile] intValue]];
        
   
    
}
-(void)exchageGapWithTappedIndex:(int)tappedIndex
{
    UIButton *tapped = [buttonTiles objectAtIndex:tappedIndex];
    UIButton *gapButton = [buttonTiles objectAtIndex:gap];
    CGRect tappedFrame = tapped.frame;

    if ([[self pointsAroundGapPoint] containsObject:[NSNumber numberWithInt:tappedIndex]]) 
    {
        [buttonTiles exchangeObjectAtIndex:tappedIndex withObjectAtIndex:gap];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        tapped.frame = gapButton.frame;
        gapButton.frame =tappedFrame;
        [UIView commitAnimations];
        tapped.tag = gap;
        gapButton.tag= tappedIndex;
        gap = tappedIndex;
        
    }

}
-(void)dealloc
{
    [buttonTiles removeAllObjects];
    [buttonTiles release];
    [super dealloc];
}
@end
