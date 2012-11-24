//
//  TextFieldCell.m
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TextFieldCell.h"

@interface TextFieldCell(){
    UITextField *textField;
}

@end

@implementation TextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    textField = (UITextField*)[self viewWithTag:1];
    
    //setto il bottom border per il textField
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height-10, textField.frame.size.width, 1.5f);
    
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.cornerRadius = 2;
    
    [textField.layer addSublayer:bottomBorder];
}

@end
