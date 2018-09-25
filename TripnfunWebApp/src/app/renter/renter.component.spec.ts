import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RenterComponent } from './renter.component';

describe('RenterComponent', () => {
  let component: RenterComponent;
  let fixture: ComponentFixture<RenterComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RenterComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RenterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
