USE master;
GO

-- Delete the DemoDB Database (IF EXISTS)
IF EXISTS(select * from sys.databases where name='CityTours')
DROP DATABASE CityTours;
GO

-- Create a new DemoDB Database
CREATE DATABASE CityTours;
GO

USE [CityTours]
GO
/****** Object:  Table [dbo].[landmark]    Script Date: 4/8/2020 9:36:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[landmark](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[longName] [varchar](100) NOT NULL,
	[shortName] [varchar](100) NULL,
	[streetNumber] [int] NOT NULL,
	[streetName] [varchar](25) NOT NULL,
	[city] [varchar](50) NOT NULL,
	[state] [varchar](20) NOT NULL,
	[stateCode] [varchar](20) NOT NULL,
	[zip] [int] NOT NULL,
	[latitude] [decimal](18, 4) NOT NULL,
	[longitude] [decimal](18, 4) NOT NULL,
	[details] [varchar](2000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[landmark] ON 

INSERT [dbo].[landmark] ([id], [longName], [shortName], [streetNumber], [streetName], [city], [state], [stateCode], [zip], [latitude], [longitude], [details]) VALUES (1, N'Statue Of Liberty', NULL, 1, N' Battery Place', N'New York City', N'New York', N'NY', 10004, CAST(40.6892 AS Decimal(18, 4)), CAST(-74.0445 AS Decimal(18, 4)), N'Presented to the United States in 1886 as a gift from France, Lady Liberty is a near-universal symbol of freedom and democracy, standing 305 feet and 6 inches high on Liberty Island. You can get a sense of the thrill millions of immigrants must have experienced as you approach it on the ferry from Battery Park and see the statue grow from a vaguely defined figure on the horizon into a towering, stately colossus. Here’s Fodor’s Guide to all things New York City.
')
INSERT [dbo].[landmark] ([id], [longName], [shortName], [streetNumber], [streetName], [city], [state], [stateCode], [zip], [latitude], [longitude], [details]) VALUES (2, N'Hoover Dam', NULL, 1305, N'Arizona Street
', N'Boulder City', N'Nevada', N'NV', 89005, CAST(36.0161 AS Decimal(18, 4)), CAST(-114.7377 AS Decimal(18, 4)), N'Holding back the mighty Colorado River, this massive feat of engineering creates hydroelectric power and helps provides water for seven states and a portion of Mexico. In 2010, the Hoover Dam Bypass Bridge opened to allow for faster travel through the area. But it’s still worth stopping to admire the Art Deco wonder and tour the facilities.
')
INSERT [dbo].[landmark] ([id], [longName], [shortName], [streetNumber], [streetName], [city], [state], [stateCode], [zip], [latitude], [longitude], [details]) VALUES (3, N'Gateway Arch', NULL, 11, N' N 4th St', N'St. Louis', N'Missouri', N'MO', 63102, CAST(38.6247 AS Decimal(18, 4)), CAST(-90.1848 AS Decimal(18, 4)), N'Part of the Gateway Arch National Park, this iconic structure symbolizes the importance of St. Louis as the Gateway to the West. Be sure to ride to the top for great views of the city and the Mississippi River.')
INSERT [dbo].[landmark] ([id], [longName], [shortName], [streetNumber], [streetName], [city], [state], [stateCode], [zip], [latitude], [longitude], [details]) VALUES (5, N'Golden Gate Bridge', NULL, 1, N'Golden Gate Bridge', N'San Francisco', N'California', N'CA', 62843, CAST(37.8199 AS Decimal(18, 4)), CAST(-122.4783 AS Decimal(18, 4)), N'The suspension bridge connecting San Francisco with Marin County, completed in 1937, is a triumph in just about every way. With its 1.7-mi span and 746-foot towers, it’s both beautiful and durable—it was built to withstand winds of more than 100 mph and was undamaged by the 1989 Loma Prieta quake. The bridge’s walkway provides unparalleled views of the Bay Area.')
INSERT [dbo].[landmark] ([id], [longName], [shortName], [streetNumber], [streetName], [city], [state], [stateCode], [zip], [latitude], [longitude], [details]) VALUES (6, N'Mount Rushmore', NULL, 13000, N' SD-244', N'Keystone', N'South Dakota', N'SD', 57751, CAST(43.8791 AS Decimal(18, 4)), CAST(-103.4591 AS Decimal(18, 4)), N'In the midst of South Dakota’s Black Hills, 60-foot-high likenesses of Presidents George Washington, Thomas Jefferson, Abraham Lincoln, and Theodore Roosevelt are carved into a massive granite cliff; the result is America’s most famous memorial. From sunset through 9 pm, the majestic faces are dramatically illuminated at night.
')
SET IDENTITY_INSERT [dbo].[landmark] OFF
