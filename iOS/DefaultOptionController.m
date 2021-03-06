/*
 * This file is part of MAME4iOS.
 *
 * Copyright (C) 2013 David Valdeita (Seleuco)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses>.
 *
 * Linking MAME4iOS statically or dynamically with other modules is
 * making a combined work based on MAME4iOS. Thus, the terms and
 * conditions of the GNU General Public License cover the whole
 * combination.
 *
 * In addition, as a special exception, the copyright holders of MAME4iOS
 * give you permission to combine MAME4iOS with free software programs
 * or libraries that are released under the GNU LGPL and with code included
 * in the standard release of MAME under the MAME License (or modified
 * versions of such code, with unchanged license). You may copy and
 * distribute such a system following the terms of the GNU GPL for MAME4iOS
 * and the licenses of the other code concerned, provided that you include
 * the source code of that other code when and as the GNU GPL requires
 * distribution of source code.
 *
 * Note that people who make modified versions of MAME4iOS are not
 * obligated to grant this special exception for their modified versions; it
 * is their choice whether to do so. The GNU General Public License
 * gives permission to release a modified version without this exception;
 * this exception also makes it possible to release a modified version
 * which carries forward this exception.
 *
 * MAME4iOS is dual-licensed: Alternatively, you can license MAME4iOS
 * under a MAME license, as set out in http://mamedev.org/
 */

#import "DefaultOptionController.h"
#import "Globals.h"
#import "Options.h"
#if TARGET_OS_IOS
#import "OptionsController.h"
#elif TARGET_OS_TV
#import "TVOptionsController.h"
#endif
#import "ListOptionController.h"
#import "EmulatorController.h"

#include "myosd.h"

@implementation DefaultOptionController

- (id)init {
    if (self = [super init]) {
#if TARGET_OS_IOS
        switchTvoutNative = nil;
        switchCheats = nil;
        switchVsync = nil;
        switchThreaded = nil;
        switchDblbuff = nil;
        switchHiscore = nil;
        switchVAntialias = nil;
        switchVBean2x = nil;
        switchVFlicker = nil;
#endif
        arraySoundValue = [[NSArray alloc] initWithObjects:@"Off", @"On (11 KHz)", @"On (22 KHz)",@"On (33 KHz)", @"On (44 KHz)", @"On (48 KHz)", nil];
        arrayMainPriorityValue = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10",nil];
        arrayVideoPriorityValue = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10",nil];
        
        arrayMainThreadTypeValue = [[NSArray alloc] initWithObjects:@"Normal", @"Real Time RR", @"Real Time FIFO",nil];
        arrayVideoThreadTypeValue = [[NSArray alloc] initWithObjects:@"Normal", @"Real Time RR", @"Real Time FIFO",nil];
        
        self.title = @"Default Options";
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return 3;
        case 1: return 4;
        case 2: return 7;
    }
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0: return @"Vector Defaults";
        case 1: return @"Game Defaults";
        case 2: return @"App Defaults";
    }
    return @"Error!";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat: @"%d:%d", (int)[indexPath indexAtPosition:0], (int)[indexPath indexAtPosition:1]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        UITableViewCellStyle style;
        
        style = UITableViewCellStyleValue1;
        
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"CellIdentifier"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    
    Options *op = [[Options alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.textLabel.text  = @"Beam 2x";
#if TARGET_OS_IOS
                    switchVBean2x = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchVBean2x;
                    [switchVBean2x setOn:[op vbean2x] animated:NO];
                    [switchVBean2x addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op vbean2x]];
#endif
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text   = @"Antialias";
#if TARGET_OS_IOS
                    switchVAntialias  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchVAntialias ;
                    [switchVAntialias setOn:[op vantialias] animated:NO];
                    [switchVAntialias addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op vantialias]];
#endif

                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"Flicker";
#if TARGET_OS_IOS
                     switchVFlicker  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchVFlicker ;
                    [switchVFlicker setOn:[op vflicker] animated:NO];
                    [switchVFlicker addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op vflicker]];
#endif
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.textLabel.text   = @"Sound";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arraySoundValue objectAtIndex:op.soundValue];
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text   = @"Cheats";
#if TARGET_OS_IOS
                    switchCheats  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchCheats ;
                    [switchCheats setOn:[op cheats] animated:NO];
                    [switchCheats addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op vflicker]];
#endif

                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"Force 60Hz Sync";
#if TARGET_OS_IOS
                    switchVsync  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchVsync ;
                    [switchVsync setOn:[op vsync] animated:NO];
                    [switchVsync addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op vsync]];
#endif
                    break;
                }
                case 3:
                {
                    cell.textLabel.text   = @"Save Hiscores";
#if TARGET_OS_IOS
                    switchHiscore  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchHiscore ;
                    [switchHiscore setOn:[op hiscore] animated:NO];
                    [switchHiscore addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op hiscore]];
#endif

                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.textLabel.text   = @"Native TV-OUT";
#if TARGET_OS_IOS
                    switchTvoutNative  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchTvoutNative ;
                    [switchTvoutNative setOn:[op tvoutNative] animated:NO];
                    [switchTvoutNative addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op tvoutNative]];
#endif
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text   = @"Threaded Video";
#if TARGET_OS_IOS
                    switchThreaded  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchThreaded ;
                    [switchThreaded setOn:[op threaded] animated:NO];
                    [switchThreaded addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op threaded]];
#endif
                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"Video Thread Priority";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayVideoPriorityValue objectAtIndex:op.videoPriority];
                    break;
                }
                case 3:
                {
                    cell.textLabel.text   = @"Video Thread Type";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayVideoThreadTypeValue objectAtIndex:op.videoThreadType];
                    break;
                }
                case 4:
                {
                    cell.textLabel.text   = @"Double Buffer";
#if TARGET_OS_IOS
                    switchDblbuff  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchDblbuff ;
                    [switchDblbuff setOn:[op dblbuff] animated:NO];
                    [switchDblbuff addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
#elif TARGET_OS_TV
                    cell.accessoryView = [TVOptionsController labelForOnOffValue:[op dblbuff]];
#endif
                    break;
                }
                case 5:
                {
                    cell.textLabel.text   = @"Main Thread Priority";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayMainPriorityValue objectAtIndex:op.mainPriority];
                    break;
                }
                case 6:
                {
                    cell.textLabel.text   = @"Main Thread Type";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayMainThreadTypeValue objectAtIndex:op.mainThreadType];
                    break;
                }
            }
            break;
        }
    }
    
    return cell;
}

#if TARGET_OS_IOS
- (void)optionChanged:(id)sender
{
    Options *op = [[Options alloc] init];

	if(sender == switchTvoutNative)
        op.tvoutNative = [switchTvoutNative isOn];
    
    if(sender == switchCheats)
        op.cheats = [switchCheats isOn];
    
    if(sender == switchVsync)
        op.vsync = [switchVsync isOn];
    
    if(sender == switchThreaded)
        op.threaded = [switchThreaded isOn];
    
    if(sender == switchDblbuff)
        op.dblbuff = [switchDblbuff isOn];
    
    if(sender == switchHiscore)
        op.hiscore = [switchHiscore isOn];
    
    if(sender == switchVBean2x)
        op.vbean2x = [switchVBean2x isOn];
    
    if(sender == switchVAntialias)
        op.vantialias = [switchVAntialias isOn];
    
    if(sender == switchVFlicker)
        op.vflicker = [switchVFlicker isOn];
    
    [op saveOptions];
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
#if TARGET_OS_TV
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Options *op = [[Options alloc] init];
    if ( section == 0 ) {
        if ( row == 0 ) {
            op.vbean2x = op.vbean2x ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.vbean2x];
        } else if ( row == 1 ) {
            op.vantialias = op.vantialias ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.vantialias];
        } else if ( row == 2 ) {
            op.vflicker = op.vflicker ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.vflicker];
        }
    } else if ( section == 1 ) {
        if ( row == 1 ) {
            op.cheats = op.cheats ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.cheats];
        } else if ( row == 2 ) {
            op.vsync = op.vsync ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.vsync];
        } else if ( row == 3 ) {
            op.hiscore = op.hiscore ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.hiscore];
        }
    } else if ( section == 2 ) {
        if ( row == 0 ) {
            op.tvoutNative = op.tvoutNative ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.tvoutNative];
        } else if ( row == 1 ) {
            op.threaded = op.threaded ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.threaded];
        } else if ( row == 4 ) {
            op.dblbuff = op.dblbuff ? 0 : 1;
            [TVOptionsController setOnOffValueForCell:cell optionValue:op.dblbuff];
        }
    }
    [op saveOptions];
#endif
    
    if(section==1 && row==0)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                      type:kTypeSoundValue list:arraySoundValue];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if (section==2 && row==2){
        ListOptionController *listController = [[ListOptionController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                      type:kTypeVideoPriorityValue list:arrayVideoPriorityValue];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if (section==2 && row==3){
        ListOptionController *listController = [[ListOptionController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                      type:kTypeVideoThreadTypeValue list:arrayVideoThreadTypeValue];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if (section==2 && row==5){
        ListOptionController *listController = [[ListOptionController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                      type:kTypeMainPriorityValue list:arrayMainPriorityValue];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if (section==2 && row==6){
        ListOptionController *listController = [[ListOptionController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                      type:kTypeMainThreadTypeValue list:arrayMainThreadTypeValue];
        [[self navigationController] pushViewController:listController animated:YES];
    }

}


@end
