//
//  FTCalendar.m
//  FTCalendar
//
//  Created by Mousa AlSahbi on 1/28/15.
//  Copyright (c) 2015 SyncoApp. All rights reserved.
//

#import "FTCalendar.h"
#import "DateUtil.h"
#import "SACalendarCell.h"
#import "FTCalendarAppearance.h"

@implementation FTCalendar

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SACalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
    cell.dateLabel.textColor = [UIColor blackColor];
    int monthToLoad = [self monthToLoad:(int)collectionView.tag];
    int yearToLoad = [self yearToLoad:(int)collectionView.tag];
    
    // number of days in the month we are loading
    int daysInMonth = (int)[DateUtil getDaysInMonth:monthToLoad year:current_year];
    
    // if cell is out of the month, do not show
    if (indexPath.row < firstDay || indexPath.row >= firstDay + daysInMonth)
    {
        cell.topLineView.hidden = cell.dateLabel.hidden = cell.circleView.hidden = cell.selectedView.hidden = YES;
    }
    else
    {
        cell.topLineView.hidden = NO;
        cell.dateLabel.hidden = NO;
        cell.circleView.hidden = YES;
        
        UIFont *font = cellFont;
        UIFont *boldFont = cellBoldFont;
        
        // if the cell is the current date, display the red circle
        BOOL isToday = NO;
        if (indexPath.row - firstDay + 1 == current_date && monthToLoad == current_month && yearToLoad == current_year)
        {
            cell.circleView.hidden = NO;
            
            cell.dateLabel.textColor = currentDateTextColor;
            
            cell.dateLabel.font = boldFont;
            
            isToday = YES;
        }
        else
        {
            cell.dateLabel.font = font;
            cell.dateLabel.textColor = dateTextColor;
        }
        
        // if the cell is selected, display the black circle
        if (indexPath.row == selectedRow)
        {
            cell.selectedView.hidden = NO;
            cell.dateLabel.textColor = currentDateTextColor;
            cell.dateLabel.font = boldFont;
        }
        else
        {
            cell.selectedView.hidden = YES;
            if (!isToday)
            {
                cell.dateLabel.font = font;
                cell.dateLabel.textColor = dateTextColor;
            }
        }
        
        // set the appropriate date for the cell
        cell.dateLabel.text = [NSString stringWithFormat:@"%i",(int)indexPath.row - firstDay + 1];
        
        if ([self.availableDates count] != 0)
        {
            NSString *currentDateString = [NSString stringWithFormat:@"%li/%i/%i",(indexPath.row - firstDay + 1),month,year];

            if (![self.availableDates containsObject:currentDateString])
            {  
                cell.dateLabel.textColor = isToday? [UIColor whiteColor] : [UIColor lightGrayColor];
                cell.dateLabel.font = font;
                cell.selectedView.hidden = YES;
            }
            else
                cell.dateLabel.textColor = indexPath.row == selectedRow? [UIColor whiteColor] : [UIColor blackColor];
        }
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currentDateString = [NSString stringWithFormat:@"%li/%i/%i",(indexPath.row - firstDay + 1),month,year];
    
    if ([self.availableDates count] != 0)
        return [self.availableDates containsObject:currentDateString]? YES : NO;
    
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = self.frame.size.width;
    cellSize = CGSizeMake(width/DAYS_IN_WEEKS,35.0f);
    return cellSize;
}

@end
