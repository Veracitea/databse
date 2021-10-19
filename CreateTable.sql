FORMAT:
CREATE TABLE ContactPerson(
     userID CHAR(7) NOT NULL,
     companyID CHAR(7) NOT NULL,
     PRIMARY KEY (userID),
     UNIQUE (companyID),
     FOREIGN KEY (userID) REFERENCES User(userID), 
     ON DELETE CASCADE ON UPDATE CASCADE
     FOREIGN KEY (companyID) REFERENCES Company(companyID)
     ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO CheckInOut
   (UserID,LocationID,CheckinTime,CheckoutTime)
VALUES 
('user_1', 'loc_1',1000,2000),
('user_2', 'loc_2',2000,3000), 
('user_3', 'loc_3',3000,4000),
('user_4', 'loc_4',4000,5000),
('user_5', 'loc_6',5000,6000),
('user_6', 'loc_6',6000,7000),
('user_7', 'loc_7',7000,8000)
