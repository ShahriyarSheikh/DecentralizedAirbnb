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


roomtype : string [] = ['Shared','Private', 'Entire room' ];
amentities : string [] = ['Kitchen','Heating' , 'Air conditioning','Shampoo'];
facilities : string [] = ['parking', 'gym', 'hot-tub', 'pool'];
property :  string [] = ['house', 'Apartment', 'bed', 'breakfast', 'bunglow'];
rules : string [] = ['Pets Allowed', 'Smoking', 'events' ];
language : string [] = ['english', 'francis'];


selectedRoom = {};

  constructor(private listingForm : Listings) { }

  ngOnInit() {
    this.renterForm = this.listingForm.listingOfRenter;
  }
  


onSubmit() {
  console.log(this.renterForm.value);
}



}
