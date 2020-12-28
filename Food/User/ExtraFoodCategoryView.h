//
//  ExtraFoodCategoryView.h
//  Food
//
//  Created by meixiang wu on 07/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraFoodCategoryView : UIViewController
@property (strong, nonatomic) NSMutableArray* m_data;
@property (strong, nonatomic) NSMutableDictionary* m_chooseCount;

- (void)refreshTable;
@end
