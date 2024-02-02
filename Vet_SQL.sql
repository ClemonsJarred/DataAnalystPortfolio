/**
JBC2023
This project assumes I am the analyst for a veternary. The company marketing team has a few questions regarding the data,
which ranges from the pet name and vaccinations to owner's name and their address. My tasks are to answer and provide spreadsheets
based on the requested information. This project has separate tables for the pet's information table, general procedure table, owner information table,
and lastly procedures per pet table.

No present challenges with the data.

Tasks/Queries:

1. Extract Information on Pets names and Owners names side-by-side
2. Which pets from this clinic had procedures performed?
3. Make a list of all procedures matched with their descriptions
4. Match all Pets to their procedure history
5. Extract a table that shows Owner, procedures and total cost per procedure.

**/



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [OwnerID]
      ,[Name]
      ,[Surname]
      ,[StreetAddress]
      ,[City]
      ,[State]
      ,[StateFull]
      ,[ZipCode]
  FROM [Vet_Clinic].[dbo].[P9-Owners]


  --1. Extract Information on Pets names and Owners names side-by-side
  ----------------------------------------------------------------------
  SELECT p.Name as 'PetName', o.Name as 'Owner_FirstName', o.Surname as 'Owner_Surname'
  from [Vet_Clinic].[dbo].[P9-Pets] as p 
  LEFT JOIN  [Vet_Clinic].[dbo].[P9-Owners] as o
  ON p.OwnerID = o.OwnerID
  ORDER BY p.Name;
  /*---Sample Results---*/
/*PetName	Owner_FirstName	Surname
Angel		      Lee		McKenzie
Antigone	      Julia		Gowan
Bandit		William	Tea
Bandit		Robert	Partridge
Bandit		Jeffrey	Moore
Biscuit		Mary		Hurtado
Biscuit		Connie	Pauley
Biscuit		Bessie	Yen*/

--2. Which pets from this clinic had procedures performed?
----------------------------------------------------------------------
  SELECT DISTINCT(p.PetID), p.Name --THERE MAY BE MULTIPLE OF THE SAME NAMES
  from [Vet_Clinic].[dbo].[P9-Pets] as p
  LEFT JOIN [Vet_Clinic].[dbo].[P9-ProceduresHistory] as ph 
  ON ph.PetID = p.PetID
  WHERE ph.ProcedureType is not NULL
  ORDER BY p.Name;
    /*---Sample Results---*/
/*PetID	Name
H2-8586	Antigone
F1-1855	Bandit
O6-3123	Biscuit
T0-5705	Biscuit
U8-6473	Biscuit
J6-8562	Blackie
U6-4890	Blackie*/



--3. Make a list of all procedures matched with their descriptions
----------------------------------------------------------------------
  SELECT ProcedureType, [Description]
  from [Vet_Clinic].[dbo].[P9-ProceduresDetails] as pd
  ORDER BY ProcedureType
   /*---Sample Results---*/
/*
ProcedureType	Description
GENERAL SURGERIES	Anal Gland Caut
GENERAL SURGERIES	Aural Hematoma
GENERAL SURGERIES	Declaw
GENERAL SURGERIES	Dissolvable Suture
GENERAL SURGERIES	Ear Crop
GENERAL SURGERIES	Gastric Torsion
GENERAL SURGERIES	Hernia
*/


--4. Match all Pets to their procedure history
----------------------------------------------------------------------
  SELECT p.PetID, p.Name, pd.ProcedureType, pd.Description  
  from [Vet_Clinic].[dbo].[P9-Pets] as p
  LEFT JOIN [Vet_Clinic].[dbo].[P9-ProceduresHistory] as ph --LEFT OR INNER JOIN WORKS
  ON ph.PetID = p.PetID
  LEFT JOIN [Vet_Clinic].[dbo].[P9-ProceduresDetails] as pd
  ON pd.ProcedureType = ph.ProcedureType
  WHERE ph.ProcedureType is not NULL
  ORDER BY p.Name;
   /*---Sample Results---*/
  /*
  PetID	Name	      ProcedureType	Description
H2-8586	Antigone	VACCINATIONS	Galaxie (DHLPP)
H2-8586	Antigone	VACCINATIONS	Leukemia
H2-8586	Antigone	VACCINATIONS	Lyme
H2-8586	Antigone	VACCINATIONS	PCR
H2-8586	Antigone	VACCINATIONS	Rabies
H2-8586	Antigone	VACCINATIONS	Bordetella
F1-1855	Bandit	VACCINATIONS	Galaxie (DHLPP)
F1-1855	Bandit	VACCINATIONS	Leukemia
F1-1855	Bandit	VACCINATIONS	Lyme
F1-1855	Bandit	VACCINATIONS	PCR
F1-1855	Bandit	VACCINATIONS	Rabies
F1-1855	Bandit	VACCINATIONS	Bordetella
U8-6473	Biscuit	VACCINATIONS	Galaxie (DHLPP)
U8-6473	Biscuit	VACCINATIONS	Leukemia
U8-6473	Biscuit	VACCINATIONS	Lyme
U8-6473	Biscuit	VACCINATIONS	PCR*/


--5. Extract a table that shows Owner, procedures and total cost per procedure.
-----------------------------------------------------------------------------------------
  SELECT o.Name + ' ' + o.Surname as OwnerName, ph.ProcedureType, pd.Description, pd.Price,
  SUM(Price) OVER(PARTITION BY o.OwnerID) as TotalPrice
  from [Vet_Clinic].[dbo].[P9-Owners] as o 
  LEFT JOIN [Vet_Clinic].[dbo].[P9-Pets] as p
  ON o.OwnerID = p.OwnerID
  LEFT JOIN [Vet_Clinic].[dbo].[P9-ProceduresHistory] as ph
  ON p.petID = ph.petID 
  LEFT JOIN [Vet_Clinic].[dbo].[P9-ProceduresDetails] as pd
  ON ph.ProcedureType = pd.ProcedureType
  WHERE ph.ProcedureType is not NULL;
  /*---Sample Results---*/
  /*
  OwnerName			ProcedureType	Description			Price	      TotalPrice
Jessica Velazquez	      VACCINATIONS	Galaxie (DHLPP)		15.00	      125.00
Jessica Velazquez	      VACCINATIONS	Leukemia			20.00	      125.00
Jessica Velazquez	      VACCINATIONS	Lyme				15.00	      125.00
Jessica Velazquez	      VACCINATIONS	PCR				15.00	      125.00
Jessica Velazquez	      VACCINATIONS	Rabies			10.00	      125.00
Jessica Velazquez	      VACCINATIONS	Bordetella			10.00	      125.00
Jessica Velazquez	      GROOMING		Bath				15.00	      125.00
Jessica Velazquez	      GROOMING		Flea Dip			15.00	      125.00
Jessica Velazquez	      GROOMING		Flea Spray			10.00	      125.00
Joseph Blow			VACCINATIONS	Galaxie (DHLPP)		15.00	      85.00
Joseph Blow			VACCINATIONS	Leukemia			20.00	      85.00
Joseph Blow			VACCINATIONS	Lyme				15.00	      85.00
Joseph Blow			VACCINATIONS	PCR				15.00	      85.00
Joseph Blow			VACCINATIONS	Rabies			10.00	      85.00
Joseph Blow			VACCINATIONS	Bordetella			10.00	      85.00
Carolyn Crane		VACCINATIONS	Galaxie (DHLPP)		15.00	      85.00
Carolyn Crane		VACCINATIONS	Leukemia			20.00	      85.00
*/
