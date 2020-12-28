//
//  GuestSelectView.h
//  Food
//
//  Created by meixiang wu on 7/3/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>


@interface GuestSelectView : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;

- (IBAction)onSearchLocationClick:(id)sender;
- (IBAction)onBackClick:(id)sender;

@end
