CREATE TABLE Swipes
(
	instigator VARCHAR(100),
	recipient VARCHAR(100),
	swipeAction int, -- 1 = like 0 = dislike
	CONSTRAINT Swipe_PK PRIMARY KEY(instigator, recipient)
)

CREATE TABLE Matches
(
	personA VARCHAR(100),
	personB VARCHAR(100)
	CONSTRAINT Matches_PK PRIMARY KEY(personA, personB)
)
