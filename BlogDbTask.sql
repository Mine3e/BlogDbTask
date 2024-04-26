create database BlogDb
use BlogDb 
create table Categories(
id int primary key identity,
Name nvarchar(50) not null unique
)
create table Tags(
Id int primary key identity,
Name nvarchar(50) not null unique
)
create table Users(
Id int primary key identity,
Username nvarchar(60) not null unique,
FullName nvarchar(60) not null,
Age int Check(Age>0 and Age<150)
)
create table Blogs (
Id int primary key Identity,
Title nvarchar(50) not null,
[Description] nvarchar(100) not null,
isDleted bit default 0,
UserId int references Users(Id),
CategoryId int references Categories(Id)
)

create table Comments(
Id int primary key identity,
Content nvarchar(250) not null,
UserId int references Users(Id),
BlogId int references Blogs(Id)
)
create table BlogTags(
Id int primary key identity,
BlogId int references Blogs(Id),
TagId int references Tags(Id)
)

create view BlogsUsersVies as
select b.Title, u.UserName, u.FullName
From Blogs b
join Users u
On b.Id=u.Id
select * from BlogsUsersVies

create view BlogsCategories as
select b.title, c.Name
from Blogs b
join Categories c
on b.CategoryId=c.id
select * from BlogsCategories

create procedure usp_GetUserComents @userId int 
as
select c.Content
From Comments c
where UserId=@userId	
exec usp_GetUserComents 2

create  procedure usp_GetUserBlogs( @userId int)
as
select Blogs.Title, Blogs.Description
From Blogs
where UserId=@userId
exec usp_GetUserBlogs 2


create function usp_GetBlogCountByCategory  (@categoryId int)
returns int 
as
begin
declare @count int 
select @count=COUNT(*)
From Blogs 
where CategoryId=@categoryId
return @count 
end
select dbo.usp_GetBlogCountByCategory(1) asBlogCounts

create function usp_GetUserBlogsTable (@userId int )
returns table 
as
return
(
select *
from Blogs 
where UserId=@userId
)
select *from dbo.usp_GetUserBlogsTable(3) as UserBlogsTable


create trigger DeleteBlogTrigger
on Blogs
instead of delete
as
begin
update Blogs
set isDeleted=1
where Id in (Select deleted.Id from deleted )
end


select *from Blogs 
where isDeleted=0;

insert into Categories(Name)
Values ('Technology'),
       ('Science'),
       ('Art');
Insert into Tags ( Name)
VALUES ('Programming'),
       ('Machine Learning'),
       ('Space');
insert into Users(UserName, FullName, Age)
Values ('Rufet12', 'Rufet Eliyev',20),
       ('Kenan23', 'Kenan Quliyev',25),
	   ('Nail54','Nail Memmedli',18);
insert into Blogs(Title, [Description],UserId, CategoryId)
Values ('C#',' Learning programming languages',1,1),
       ('AI', 'impact of artificial intelligence',2,2),
	   ('Beauty', 'Learning Kocmoc',3,3);

insert into Comments(Content,UserId,BlogId)
Values ('Enjoying',1,1),
       ('Boring',2,2),
	   ('Amazing',3,3);