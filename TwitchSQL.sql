   /**This project contains a selection of statements that query data from overall Twitch streaming data.
   Twitch is an interactive livestreaming service for content spanning gaming, entertainment, sports and music.
   The data covers how much time viewers watch a channel's content, how many followers a channel has, as well as other factors. 
   Most of the data is numeric.
   
   No present chalenges with the data.
   
   Tasks/Queries:
   1. Find average, maximum and minimum for the average viewers
   2. Which streamer received the highest overall watch time?
   3. Find the twitch streamers who may have explicit names (uses "xxx")
   4. Categorize Twitch streamers by language
   5. Given our subset, how many Languages are being streamed on Twitch? 
   6. Who has the overall best performance channel per language? (Best Performance = (Followers + Average Viewers)/ Stream Time) Separte ties with followers gained.
   **/
   
   
   
   
   /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [Channel]
      ,[Watch time(Minutes)]
      ,[Stream time(minutes)]
      ,[Peak viewers]
      ,[Average viewers]
      ,[Followers]
      ,[Followers gained]
      ,[Views gained]
      ,[Partnered]
      ,[Mature]
      ,[Language]
  FROM [master].[dbo].[twitchdata-update]

 --Find average, maximum and minimum for the average viewers
    ---------------------------------------------------------------------------------------------------------
  Select avg([Average viewers]) as Avg_Views, Max([Average viewers]) as Max_views, Min([Average viewers]) as Min_views
  From [twitchdata-update]
  /*Results*/
  /*
  Avg_Views	Max_views	Min_Views
  4781		147643		235
  */
  
  --Which streamer received the highest overall watch time? 
  ---------------------------------------------------------------------------------------------------------
  Select Top(1) Channel, [Watch time(Minutes)]
  from [twitchdata-update]
  Order by [Watch time(Minutes)] DESC
  /*Results*/
  /*
  Channel	Watch time(Minutes)
	xQcOW	6196161750
  */
  

  --Find the twitch streamers who may have explicit names (uses "xxx")
  ---------------------------------------------------------------------------------------------------------
    Select Distinct(Channel) /*this helps eliminates duplicates*/
	from [twitchdata-update]
	Where Channel like '%xxx%'
	/*Results*/
	/*
	Dmitry_Lixxx
	*/


  --Categorize Twitch streamers by language
    ---------------------------------------------------------------------------------------------------------
	Select Channel, Language 
	from [twitchdata-update]
	Order by Language ASC
  --Given our subset, how many Languages are being streamed on Twitch? 
    ---------------------------------------------------------------------------------------------------------
  	Select count(Distinct(Language))
	from [twitchdata-update]
	/*21 Different languages*/


	--Who has the overall best performance channel per language? (Best Performance = (Followers + Average Viewers)/ Stream Time) Separte ties with followers gained.
	------------------------------------------------------------------------------------------------------------------------------------------------------
	with PerformanceMeasure (ChannelName, Language, PerformanceScore, Followers_gained) as
	(
	SELECT  [Channel], Language, round((cast([Followers] + [Average viewers] as float)/ cast([Stream time(minutes)] as float)),5) as PerformanceScore, [Followers gained]
	FROM [master].[dbo].[twitchdata-update]
	)
	Select Distinct(ChannelName),Language, PerformanceScore
	from PerformanceMeasure
	Where PerformanceScore = (select max(PerformanceScore) from PerformanceMeasure as pm where pm.language = PerformanceMeasure.language)
	Order by PerformanceScore DESC;

	/*Results*/
	/*
ChannelName	Language	PerformanceScore
Fortnite		English		298.1547
SLAKUN10		Spanish		198.20387
Faker			Korean		160.42559
dota2ti_ru		Russian		107.80888
UNLOSTV			Turkish		79.90448
Squeezie		French		72.83177
MontanaBlack88		German		43.47254
NOBRU			Portuguese	40.66206
GarenaTW		Chinese		34.0452
ixxYjYxxi		Arabic		23.12178
IzakOOO			Polish		11.3516
ilMasseo		Italian		6.7105
RiotGamesJP		Japanese	5.90158
WeAreTheVR		Hungarian	5.44261
Herdyn			Czech		3.34312
Esports_Alliance	Thai		3.27074
resttpowered		Slovak		1.71407
OfficialAndyPyro	Finnish		1.2242
CyrusTWO		Swedish		0.76292
Pun1shers_TV		Greek		0.68304
LigaPro1		Other		0.13814
*/
	
