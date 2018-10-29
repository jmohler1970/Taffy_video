# This video picks up where the last one ended.

Let's do a quick recap of what have done done so far.

We have the Commandbox's box.json and server.json ready. We have done and install of the Github repositories We need. I can see

* Taffy
* Formutils
* And the database setup

dot gitignore is setup to ignore these external libraries.

application.cfc has everything has extends component. There is OnApplicationStart(). There is onTaffyRequest().

We have a bean called statesProvinces dot cfc that will be exposed via a Taffy resource file.

We started up our Taffy site and the Taffy Dashboard came up.

As soon as we try to run it we get an error  because we did not have a database or a database connection.

Everything is just as we left it.





# Let's get our database running.

We need to use Commandbox to shutdown our website. Let's use the 

docker ps -a to 

find out how SQL Server is doing. It looks like it needs to be started. Let's type

Docker start sql_server_demo

And we are up. Before I used Docker, I used to run SQL Server in a Windows VM on my Mac. That would take a couple of minutes to get going. If Windows needed to install an update, and it always did, that would take a few minutes. After the update were installed, my VM software wanted to delete an old snapshot and make a new one. It could take a while before SQL Server was running. With Docker it is really fast.

# I downloaded the create scripts as a part of my demo

I can use VS Code to look at the dot .sql files. It will do the syntax highlighting and make nice icons for each of the file types, but it is difficult to run this code. Yes it could be done in the terminal, but what I really want is a full GUI take care of the DB. 

#

If I were on Windows, I would be using SQL Server Management Studio; but on my Mac I am using Microsoft Azure Data Studio. Let's talk about the good things and the not so good things about Azure Data Studio.

First the good

1. It exists. It works on Windows, MacOS, and Linux. It is everywhere
2. It looks and behaves a lot like VS Code. It even has github integration which is something Managment Studio does not have
3. It shows databases in a similar format to Management Studio
4. Like VS Code, it is themeable!

The result is, it is instantly familiar to work With

Now the not so good.

1. It's name is confusing. Yes you can do Azure with it, but more importantly you can do ANY SQL server with it.
2. The icons might look like Management Studio, but as as you right click on one, it has almost none of the options.
3. Because it has almost none of the options, you have to know how to script everything OR have a Windows box handy and have it create the scripts.

The verdict?

If you would have told me five years ago that SQL Server was going to happy run on MacOS, I would never have believed you. Now I can do all my development in the environment I want. All the skills I learn apply equality to Windows too.

# Now that I have been talking about how wonderful Azure Data Studio is, let make it do something

Start it up

Connect to the Server

Let's open up the folder. It takes a second to load

Let's open up NorthAmerica dot sql

Even though I opened up the file, it still wants me to connect to a server

The run button is enabled, but let's examine this file before just running it.

The beginning part of the code is going to setup the files that the database will be using.

Line 6 and 8 have the data and log file respectively. If you come from a Windows background, those paths might look really strange. Those are the Linux paths that are inside of Docker. If you were to navigate MacOS file system, you wouldn't find these file. It is outside the scope of this presentation to go over how all that works.

# Let's go to the next section
We are making some logins. In no way are these use name and passwords setup idea. I am sure there are DBs out there that are cringing over this. This is not meant for a production system.

# Now we have our table 

* ID will become our primary key. It has two characters always
* Country is 15 charactors long 
* CountrySort is a calculated field. It is not persisted so it won't even take up any space
* LongName is long
* We add a default value for Country

Nothing particularly complicated. I have to admit I scripted this on a Windows VM and copy pasted it over. Now that I have this handy, I can add and edit to it as necessary

# Let's look at the next part of the create script

Wow, what is going on with 146 to 149? Data_compression = Page ?

What is that about? I am going to cover that in detail in another video. The short version of why I do this is to lower the storage requirements

Country is going to have a lot of repeated data. Way back when I was in college, they would say that this is a place where the data can be normalized and split into two tables. Namely a Countries table and a statesProvinces table. 

I don't want to do all that work. So by used a compressed table, SQL Server can deal with redunancy and I can happy interact with one table rather than two. 

# I don't know about you, but I am ready to run this.

# It is almost a perfect run. The error happened because I ran this earlier today, and I forgot to delete out the Login. The error basically says it can't create it because it already exists


Let's select some data. This right click does work, so I am going to be using it.

Tada!

Let's do an order by

Let's look at the fields. Things are looking good.

Hmmm. I see my two letter state/province codes. The country. The sort and the long name. Getting SQL Server for Linux to run on a Mac inside of Docker is an achievement on its own. It took me a good day to get all that running before I made this video. If it takes you a while, don't be fustrated it can be done.


# Let's get back to Taffy. I want to serve some data

Back to Commandbox.

Type in start

The default page loads and crashes... The datasource "NorthAmerica" cannot be found.

Way up on the menubar is an icon for ColdFusion. I want to go to the Administrator.

Log into the Adminstrator. BTW, the secret password is "commandbox". Make sure to change that on production systems.

Go to the data Sources

# And let's pause for a second. 

Do we have to do anything special? The answer is NOOOOOO. It just works.

The datasource has been successfully created.

# Let's watch Taffy do its thing

Ladies and Gentlemen, we have successfully pulled the rabbit out of the hat.

I think I am going to leave this up on the screen for a while.

In order to get the stateprovince info on the screen, we had to do the following.

* We brought up a ColdFusion server
* That uses the Taffy REST framework to handle the request.
* The request made it to a CFC that used ORM to query a database table.
* That database table is running on SQL Server for Linux.
* SQL Server is running inside of Docker which is actually running on MacOS, not Linux
* When the data was returned from SQL Server, it was put into an array of Entities.
* Later that was converted to a query, then an array again, and finally into a JSON resentation.
* Taffy lastly made sure that the JSON was correct and that response headers were populated.


This is the foundation to build larger REST applications. Thank you for watching. If you have any questions, leave them in the comments below.


Until next time.

Happy Coding!


# Resources:

https://github.com/atuttle/Taffy

http://taffy.io/

https://stackoverflow.com/questions/tagged/taffy

https://github.com/jmohler1970/Taffy_video

VS Code

Azure Data Studio

Docker

MS SQL for Linux [sic]





