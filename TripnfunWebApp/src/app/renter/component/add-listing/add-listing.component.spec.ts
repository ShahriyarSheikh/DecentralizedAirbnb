import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddListingComponent } from './add-listing.component';

describe('AddListingComponent', () => {
  let component: AddListingComponent;
  let fixture: ComponentFixture<AddListingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddListingComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
