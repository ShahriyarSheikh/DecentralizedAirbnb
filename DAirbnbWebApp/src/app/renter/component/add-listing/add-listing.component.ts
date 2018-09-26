import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Listings } from '../../../models/listings.model';

@Component({
  selector: 'app-add-listing',
  templateUrl: './add-listing.component.html',
  styleUrls: ['./add-listing.component.scss'],
  providers:[Listings]
})
export class AddListingComponent implements OnInit {

renterForm : FormGroup ;


roomtype :  Array<CheckedBoxModel> = [{value : 'Shared' , isChecked: false}, {value: 'Private', isChecked: false},{value :  'Entire room',  isChecked: false}];
amentities :  Array<CheckedBoxModel> = [{value : 'Kitchen', isChecked: false},{value: 'Heating' , isChecked: false},{value : 'Air conditioning', isChecked: false},{value : 'Shampoo', isChecked: false}];
facilities :  Array<CheckedBoxModel> = [{value: 'parking', isChecked: false},{ value :  'gym', isChecked: false},{value :  'hot-tub', isChecked: false},{ value : 'pool', isChecked: false}];
property :   Array<CheckedBoxModel> = [{value : 'house', isChecked: false},{ value : 'Apartment', isChecked: false},{ value : 'bed', isChecked: false},{ value :  'breakfast', isChecked: false},{value : 'bunglow', isChecked: false}];
rules :  Array<CheckedBoxModel> = [{value: 'Pets Allowed', isChecked: false},{ value :  'Smoking', isChecked: false}, {value : 'events', isChecked: false} ];
language : Array<CheckedBoxModel> = [{ value : 'english' , isChecked: false }, { value: 'francis', isChecked: false }];


selectedRoom = {};

  constructor(private listingForm : Listings) { }

  ngOnInit() {
    this.renterForm = this.listingForm.listingOfRenter;
  }
  


onSubmit() {
   this.renterForm.value.lang = this.language.filter(x=>x.isChecked).map(x=>x.value );
   
   

  this.renterForm.value.rooms = this.roomtype.filter(x=>x.isChecked).map(x=>x.value );
  this.renterForm.value.aments = this.amentities.filter(x=>x.isChecked).map(x=>x.value );
  this.renterForm.value.facility = this.facilities.filter(x=>x.isChecked).map(x=>x.value );
  this.renterForm.value.proper = this.property.filter(x=>x.isChecked).map(x=>x.value );
  this.renterForm.value.rule = this.rules.filter(x=>x.isChecked).map(x=>x.value );
  console.log(this.renterForm.value);
}

changeCheckbox(model : CheckedBoxModel  ) {
model.isChecked = !model.isChecked ; 
}


}
 class CheckedBoxModel {
   value :  string ;
   isChecked :  boolean ;
 }