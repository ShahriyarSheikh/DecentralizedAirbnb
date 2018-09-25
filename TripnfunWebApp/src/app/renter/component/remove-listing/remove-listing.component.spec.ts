import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RemoveListingComponent } from './remove-listing.component';

describe('RemoveListingComponent', () => {
  let component: RemoveListingComponent;
  let fixture: ComponentFixture<RemoveListingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RemoveListingComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RemoveListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
