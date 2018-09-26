import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-renter',
  templateUrl: './renter.component.html',
  styleUrls: ['./renter.component.scss']
})
export class RenterComponent implements OnInit {

  isAdd:boolean = false;
  isAdd1:boolean = false;
  isAdd2:boolean = false;
  constructor() { }

  ngOnInit() {
  }

  enableListing(){
    this.isAdd = !this.isAdd
  }

  enableModify () {
    this.isAdd1 = !this.isAdd1
  }

  enableRemove () {
    this.isAdd2 = !this.isAdd2 ;
  }

}
