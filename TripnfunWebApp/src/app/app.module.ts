import { BrowserModule } from '@angular/platform-browser';
import { NgModule ,CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './/app-routing.module';
import { RenterComponent } from './renter/renter.component';
import { RenteeComponent } from './rentee/rentee.component';
import { AddListingComponent } from './renter/component/add-listing/add-listing.component';
import { RemoveListingComponent } from './renter/component/remove-listing/remove-listing.component';
import { ModifyListingComponent } from './renter/component/modify-listing/modify-listing.component';
import {HttpClientModule} from '@angular/common/http';

@NgModule({
  declarations: [
    AppComponent,
    RenterComponent,
    RenteeComponent,
    AddListingComponent,
    RemoveListingComponent,
    ModifyListingComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
    
  ],
  schemas: [ CUSTOM_ELEMENTS_SCHEMA ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
