import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RenterComponent } from './renter/renter.component';
import { RenteeComponent } from './rentee/rentee.component';
import { AddListingComponent } from './renter/component/add-listing/add-listing.component';

const routes: Routes = [
  { path: 'renter', component: RenterComponent },
  { path: 'rentee', component: RenteeComponent  }

];

@NgModule({
  imports: [ RouterModule.forRoot(routes)],
  exports : [RouterModule]
})
export class AppRoutingModule { }
