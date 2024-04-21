/* =================== Graph DB =================== */

/* Social Network - Populate names */

CREATE DATABASE MyDB
GO

USE MyDB
GO

SET NOCOUNT ON
GO

CREATE SCHEMA r
GO

DROP TABLE IF EXISTS r.FriendOf
DROP TABLE IF EXISTS r.Friend
GO

CREATE TABLE r.Friend(
	Id int NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	Name varchar(25) NULL
)
GO

CREATE TABLE r.FriendOf(
	Id1 int,
	Id2 int,
	CONSTRAINT FK_FriendOf_Friend1 FOREIGN KEY (Id1) REFERENCES r.Friend (Id),
	CONSTRAINT FK_FriendOf_Friend2 FOREIGN KEY (Id2) REFERENCES r.Friend (Id)
)

SET IDENTITY_INSERT r.Friend ON
INSERT INTO r.Friend (Id, Name) VALUES
 (1, 'James'),
 (2, 'John'),
 (3, 'Robert'),
 (4, 'Michael'),
 (5, 'Mary'),
 (6, 'William'),
 (7, 'Lenni'),
 (8, 'Richard'),
 (9, 'Charles'),
 (10, 'Joseph'),
 (11, 'Thomas'),
 (12, 'Patricia'),
 (13, 'Christopher'),
 (14, 'Linda'),
 (15, 'Barbara'),
 (16, 'Daniel'),
 (17, 'Paul'),
 (18, 'Mark'),
 (19, 'Elizabeth'),
 (20, 'Donald'),
 (21, 'Jennifer'),
 (22, 'George'),
 (23, 'Maria'),
 (24, 'Kenneth'),
 (25, 'Susan'),
 (26, 'Steven'),
 (27, 'Edward'),
 (28, 'Margaret'),
 (29, 'Brian'),
 (30, 'Ronald'),
 (31, 'Dorothy'),
 (32, 'Anthony'),
 (33, 'Lisa'),
 (34, 'Kevin'),
 (35, 'Nancy'),
 (36, 'Karen'),
 (37, 'Betty'),
 (38, 'Helen'),
 (39, 'Jason'),
 (40, 'Matthew'),
 (41, 'Gary'),
 (42, 'Timothy'),
 (43, 'Sandra'),
 (44, 'Jose'),
 (45, 'Larry'),
 (46, 'Jeffrey'),
 (47, 'Frank'),
 (48, 'Donna'),
 (49, 'Carol'),
 (50, 'Ruth'),
 (51, 'Scott'),
 (52, 'Eric'),
 (53, 'Stephen'),
 (54, 'Andrew'),
 (55, 'Sharon'),
 (56, 'Michelle'),
 (57, 'Laura'),
 (58, 'Sarah'),
 (59, 'Kimberly'),
 (60, 'Deborah'),
 (61, 'Jessica'),
 (62, 'Raymond'),
 (63, 'Shirley'),
 (64, 'Cynthia'),
 (65, 'Angela'),
 (66, 'Melissa'),
 (67, 'Brenda'),
 (68, 'Amy'),
 (69, 'Jerry'),
 (70, 'Gregory'),
 (71, 'Anna'),
 (72, 'Joshua'),
 (73, 'Virginia'),
 (74, 'Rebecca'),
 (75, 'Kathleen'),
 (76, 'Dennis'),
 (77, 'Pamela'),
 (78, 'Martha'),
 (79, 'Debra'),
 (80, 'Amanda'),
 (81, 'Walter'),
 (82, 'Stephanie'),
 (83, 'Willie'),
 (84, 'Patrick'),
 (85, 'Terry'),
 (86, 'Carolyn'),
 (87, 'Peter'),
 (88, 'Christine'),
 (89, 'Marie'),
 (90, 'Janet'),
 (91, 'Frances'),
 (92, 'Catherine'),
 (93, 'Harold'),
 (94, 'Henry'),
 (95, 'Douglas'),
 (96, 'Joyce'),
 (97, 'Ann'),
 (98, 'Diane'),
 (99, 'Alice'),
 (100, 'Jean'),
 (101, 'Julie'),
 (102, 'Carl'),
 (103, 'Kelly'),
 (104, 'Heather'),
 (105, 'Arthur'),
 (106, 'Teresa'),
 (107, 'Gloria'),
 (108, 'Doris'),
 (109, 'Ryan'),
 (110, 'Joe'),
 (111, 'Roger'),
 (112, 'Evelyn'),
 (113, 'Juan'),
 (114, 'Ashley'),
 (115, 'Jack'),
 (116, 'Cheryl'),
 (117, 'Albert'),
 (118, 'Joan'),
 (119, 'Mildred'),
 (120, 'Katherine'),
 (121, 'Justin'),
 (122, 'Jonathan'),
 (123, 'Gerald'),
 (124, 'Keith'),
 (125, 'Samuel'),
 (126, 'Judith'),
 (127, 'Rose'),
 (128, 'Janice'),
 (129, 'Lawrence'),
 (130, 'Ralph'),
 (131, 'Nicole'),
 (132, 'Judy'),
 (133, 'Nicholas'),
 (134, 'Christina'),
 (135, 'Roy'),
 (136, 'Kathy'),
 (137, 'Theresa'),
 (138, 'Benjamin'),
 (139, 'Beverly'),
 (140, 'Denise'),
 (141, 'Bruce'),
 (142, 'Brandon'),
 (143, 'Adam'),
 (144, 'Tammy'),
 (145, 'Irene'),
 (146, 'Fred'),
 (147, 'Billy'),
 (148, 'Harry'),
 (149, 'Jane'),
 (150, 'Wayne'),
 (151, 'Louis'),
 (152, 'Lori'),
 (153, 'Steve'),
 (154, 'Tracy'),
 (155, 'Jeremy'),
 (156, 'Rachel'),
 (157, 'Andrea'),
 (158, 'Aaron'),
 (159, 'Marilyn'),
 (160, 'Robin'),
 (161, 'Randy'),
 (162, 'Leslie'),
 (163, 'Kathryn'),
 (164, 'Eugene'),
 (165, 'Bobby'),
 (166, 'Howard'),
 (167, 'Carlos'),
 (168, 'Sara'),
 (169, 'Louise'),
 (170, 'Jacqueline'),
 (171, 'Anne'),
 (172, 'Wanda'),
 (173, 'Russell'),
 (174, 'Shawn'),
 (175, 'Victor'),
 (176, 'Julia'),
 (177, 'Bonnie'),
 (178, 'Ruby'),
 (179, 'Chris'),
 (180, 'Tina'),
 (181, 'Lois'),
 (182, 'Phyllis'),
 (183, 'Jamie'),
 (184, 'Norma'),
 (185, 'Martin'),
 (186, 'Paula'),
 (187, 'Jesse'),
 (188, 'Diana'),
 (189, 'Annie'),
 (190, 'Shannon'),
 (191, 'Ernest'),
 (192, 'Todd'),
 (193, 'Phillip'),
 (194, 'Lee'),
 (195, 'Lillian'),
 (196, 'Peggy'),
 (197, 'Emily'),
 (198, 'Crystal'),
 (199, 'Kim'),
 (200, 'Craig'),
 (201, 'Carmen'),
 (202, 'Gladys'),
 (203, 'Connie'),
 (204, 'Rita'),
 (205, 'Alan'),
 (206, 'Dawn'),
 (207, 'Florence'),
 (208, 'Dale'),
 (209, 'Sean'),
 (210, 'Francis'),
 (211, 'Johnny'),
 (212, 'Clarence'),
 (213, 'Philip'),
 (214, 'Edna'),
 (215, 'Tiffany'),
 (216, 'Tony'),
 (217, 'Rosa'),
 (218, 'Jimmy'),
 (219, 'Earl'),
 (220, 'Cindy'),
 (221, 'Antonio'),
 (222, 'Luis'),
 (223, 'Mike'),
 (224, 'Danny'),
 (225, 'Bryan'),
 (226, 'Grace'),
 (227, 'Stanley'),
 (228, 'Leonard'),
 (229, 'Wendy'),
 (230, 'Nathan'),
 (231, 'Manuel'),
 (232, 'Curtis'),
 (233, 'Victoria'),
 (234, 'Rodney'),
 (235, 'Norman'),
 (236, 'Edith'),
 (237, 'Sherry'),
 (238, 'Sylvia'),
 (239, 'Josephine'),
 (240, 'Allen'),
 (241, 'Thelma'),
 (242, 'Sheila'),
 (243, 'Ethel'),
 (244, 'Marjorie'),
 (245, 'Lynn'),
 (246, 'Ellen'),
 (247, 'Elaine'),
 (248, 'Marvin'),
 (249, 'Carrie'),
 (250, 'Marion'),
 (251, 'Charlotte'),
 (252, 'Vincent'),
 (253, 'Glenn'),
 (254, 'Travis'),
 (255, 'Monica'),
 (256, 'Jeffery'),
 (257, 'Jeff'),
 (258, 'Esther'),
 (259, 'Pauline'),
 (260, 'Jacob'),
 (261, 'Emma'),
 (262, 'Chad'),
 (263, 'Kyle'),
 (264, 'Juanita'),
 (265, 'Dana'),
 (266, 'Melvin'),
 (267, 'Jessie'),
 (268, 'Rhonda'),
 (269, 'Anita'),
 (270, 'Alfred'),
 (271, 'Hazel'),
 (272, 'Amber'),
 (273, 'Eva'),
 (274, 'Bradley'),
 (275, 'Ray'),
 (276, 'Jesus'),
 (277, 'Debbie'),
 (278, 'Herbert'),
 (279, 'Eddie'),
 (280, 'Joel'),
 (281, 'Frederick'),
 (282, 'April'),
 (283, 'Lucille'),
 (284, 'Clara'),
 (285, 'Gail'),
 (286, 'Joanne'),
 (287, 'Eleanor'),
 (288, 'Valerie'),
 (289, 'Danielle'),
 (290, 'Erin'),
 (291, 'Edwin'),
 (292, 'Megan'),
 (293, 'Alicia'),
 (294, 'Suzanne'),
 (295, 'Michele'),
 (296, 'Don'),
 (297, 'Bertha'),
 (298, 'Veronica'),
 (299, 'Jill'),
 (300, 'Darlene'),
 (301, 'Ricky'),
 (302, 'Lauren'),
 (303, 'Geraldine'),
 (304, 'Troy'),
 (305, 'Stacy'),
 (306, 'Randall'),
 (307, 'Cathy'),
 (308, 'Joann'),
 (309, 'Sally'),
 (310, 'Lorraine'),
 (311, 'Barry'),
 (312, 'Alexander'),
 (313, 'Regina'),
 (314, 'Jackie'),
 (315, 'Erica'),
 (316, 'Beatrice'),
 (317, 'Dolores'),
 (318, 'Bernice'),
 (319, 'Mario'),
 (320, 'Bernard'),
 (321, 'Audrey'),
 (322, 'Yvonne'),
 (323, 'Francisco'),
 (324, 'Micheal'),
 (325, 'Leroy'),
 (326, 'June'),
 (327, 'Annette'),
 (328, 'Samantha'),
 (329, 'Marcus'),
 (330, 'Theodore'),
 (331, 'Oscar'),
 (332, 'Clifford'),
 (333, 'Miguel'),
 (334, 'Jay'),
 (335, 'Renee'),
 (336, 'Ana'),
 (337, 'Vivian'),
 (338, 'Jim'),
 (339, 'Ida'),
 (340, 'Tom'),
 (341, 'Ronnie'),
 (342, 'Roberta'),
 (343, 'Holly'),
 (344, 'Brittany'),
 (345, 'Angel'),
 (346, 'Alex'),
 (347, 'Melanie'),
 (348, 'Jon'),
 (349, 'Yolanda'),
 (350, 'Tommy'),
 (351, 'Loretta'),
 (352, 'Jeanette'),
 (353, 'Calvin'),
 (354, 'Laurie'),
 (355, 'Leon'),
 (356, 'Katie'),
 (357, 'Stacey'),
 (358, 'Lloyd'),
 (359, 'Derek'),
 (360, 'Bill'),
 (361, 'Vanessa'),
 (362, 'Sue'),
 (363, 'Kristen'),
 (364, 'Alma'),
 (365, 'Warren'),
 (366, 'Elsie'),
 (367, 'Beth'),
 (368, 'Vicki'),
 (369, 'Jeanne'),
 (370, 'Jerome'),
 (371, 'Darrell'),
 (372, 'Tara'),
 (373, 'Rosemary'),
 (374, 'Leo'),
 (375, 'Floyd'),
 (376, 'Dean'),
 (377, 'Carla'),
 (378, 'Wesley'),
 (379, 'Terri'),
 (380, 'Eileen'),
 (381, 'Courtney'),
 (382, 'Alvin'),
 (383, 'Tim'),
 (384, 'Jorge'),
 (385, 'Greg'),
 (386, 'Gordon'),
 (387, 'Pedro'),
 (388, 'Lucy'),
 (389, 'Gertrude'),
 (390, 'Dustin'),
 (391, 'Derrick'),
 (392, 'Corey'),
 (393, 'Tonya'),
 (394, 'Dan'),
 (395, 'Ella'),
 (396, 'Lewis'),
 (397, 'Zachary'),
 (398, 'Wilma'),
 (399, 'Maurice'),
 (400, 'Kristin'),
 (401, 'Gina'),
 (402, 'Vernon'),
 (403, 'Vera'),
 (404, 'Roberto'),
 (405, 'Natalie'),
 (406, 'Clyde'),
 (407, 'Agnes'),
 (408, 'Herman'),
 (409, 'Charlene'),
 (410, 'Charlie'),
 (411, 'Bessie'),
 (412, 'Shane'),
 (413, 'Delores'),
 (414, 'Sam'),
 (415, 'Pearl'),
 (416, 'Melinda'),
 (417, 'Hector'),
 (418, 'Glen'),
 (419, 'Arlene'),
 (420, 'Ricardo'),
 (421, 'Tamara'),
 (422, 'Maureen'),
 (423, 'Lester'),
 (424, 'Gene'),
 (425, 'Colleen'),
 (426, 'Allison'),
 (427, 'Tyler'),
 (428, 'Rick'),
 (429, 'Joy'),
 (430, 'Johnnie'),
 (431, 'Georgia'),
 (432, 'Constance'),
 (433, 'Ramon'),
 (434, 'Marcia'),
 (435, 'Lillie'),
 (436, 'Claudia'),
 (437, 'Brent'),
 (438, 'Tanya'),
 (439, 'Nellie'),
 (440, 'Minnie'),
 (441, 'Gilbert'),
 (442, 'Marlene'),
 (443, 'Heidi'),
 (444, 'Glenda'),
 (445, 'Marc'),
 (446, 'Viola'),
 (447, 'Marian'),
 (448, 'Lydia'),
 (449, 'Billie'),
 (450, 'Stella'),
 (451, 'Guadalupe'),
 (452, 'Caroline'),
 (453, 'Reginald'),
 (454, 'Dora'),
 (455, 'Jo'),
 (456, 'Cecil'),
 (457, 'Casey'),
 (458, 'Brett'),
 (459, 'Vickie'),
 (460, 'Ruben'),
 (461, 'Jaime'),
 (462, 'Rafael'),
 (463, 'Nathaniel'),
 (464, 'Mattie'),
 (465, 'Milton'),
 (466, 'Edgar'),
 (467, 'Raul'),
 (468, 'Maxine'),
 (469, 'Irma'),
 (470, 'Myrtle'),
 (471, 'Marsha'),
 (472, 'Mabel'),
 (473, 'Chester'),
 (474, 'Ben'),
 (475, 'Andre'),
 (476, 'Adrian'),
 (477, 'Lena'),
 (478, 'Franklin'),
 (479, 'Duane'),
 (480, 'Christy'),
 (481, 'Tracey'),
 (482, 'Patsy'),
 (483, 'Gabriel'),
 (484, 'Deanna'),
 (485, 'Jimmie'),
 (486, 'Hilda'),
 (487, 'Elmer'),
 (488, 'Christian'),
 (489, 'Bobbie'),
 (490, 'Gwendolyn'),
 (491, 'Nora'),
 (492, 'Mitchell'),
 (493, 'Jennie'),
 (494, 'Brad'),
 (495, 'Ron'),
 (496, 'Roland'),
 (497, 'Nina'),
 (498, 'Margie'),
 (499, 'Leah'),
 (500, 'Harvey'),
 (501, 'Cory'),
 (502, 'Cassandra'),
 (503, 'Arnold'),
 (504, 'Priscilla'),
 (505, 'Penny'),
 (506, 'Naomi'),
 (507, 'Kay'),
 (508, 'Karl'),
 (509, 'Jared'),
 (510, 'Carole'),
 (511, 'Olga'),
 (512, 'Jan'),
 (513, 'Brandy'),
 (514, 'Lonnie'),
 (515, 'Leona'),
 (516, 'Dianne'),
 (517, 'Claude'),
 (518, 'Sonia'),
 (519, 'Jordan'),
 (520, 'Jenny'),
 (521, 'Felicia'),
 (522, 'Erik'),
 (523, 'Lindsey'),
 (524, 'Kerry'),
 (525, 'Darryl'),
 (526, 'Velma'),
 (527, 'Neil'),
 (528, 'Miriam'),
 (529, 'Becky'),
 (530, 'Violet'),
 (531, 'Kristina'),
 (532, 'Javier'),
 (533, 'Fernando'),
 (534, 'Cody'),
 (535, 'Clinton'),
 (536, 'Tyrone'),
 (537, 'Toni'),
 (538, 'Ted'),
 (539, 'Rene'),
 (540, 'Mathew'),
 (541, 'Lindsay'),
 (542, 'Julio'),
 (543, 'Darren'),
 (544, 'Misty'),
 (545, 'Mae'),
 (546, 'Lance'),
 (547, 'Sherri'),
 (548, 'Shelly'),
 (549, 'Sandy'),
 (550, 'Ramona'),
 (551, 'Pat'),
 (552, 'Kurt'),
 (553, 'Jody'),
 (554, 'Daisy'),
 (555, 'Nelson'),
 (556, 'Katrina'),
 (557, 'Erika'),
 (558, 'Claire'),
 (559, 'Allan'),
 (560, 'Hugh'),
 (561, 'Guy'),
 (562, 'Clayton'),
 (563, 'Sheryl'),
 (564, 'Max'),
 (565, 'Margarita'),
 (566, 'Geneva'),
 (567, 'Dwayne'),
 (568, 'Belinda'),
 (569, 'Felix'),
 (570, 'Faye'),
 (571, 'Dwight'),
 (572, 'Cora'),
 (573, 'Armando'),
 (574, 'Sabrina'),
 (575, 'Natasha'),
 (576, 'Isabel'),
 (577, 'Everett'),
 (578, 'Ada'),
 (579, 'Wallace'),
 (580, 'Sidney'),
 (581, 'Marguerite'),
 (582, 'Ian'),
 (583, 'Hattie'),
 (584, 'Harriet'),
 (585, 'Rosie'),
 (586, 'Molly'),
 (587, 'Kristi'),
 (588, 'Ken'),
 (589, 'Joanna'),
 (590, 'Iris'),
 (591, 'Cecilia'),
 (592, 'Brandi'),
 (593, 'Bob'),
 (594, 'Blanche'),
 (595, 'Julian'),
 (596, 'Eunice'),
 (597, 'Angie'),
 (598, 'Alfredo'),
 (599, 'Lynda'),
 (600, 'Ivan'),
 (601, 'Inez'),
 (602, 'Freddie'),
 (603, 'Dave'),
 (604, 'Alberto'),
 (605, 'Madeline'),
 (606, 'Daryl'),
 (607, 'Byron'),
 (608, 'Amelia'),
 (609, 'Alberta'),
 (610, 'Sonya'),
 (611, 'Perry'),
 (612, 'Morris'),
 (613, 'Monique'),
 (614, 'Maggie'),
 (615, 'Kristine'),
 (616, 'Kayla'),
 (617, 'Jodi'),
 (618, 'Janie'),
 (619, 'Isaac'),
 (620, 'Genevieve'),
 (621, 'Candace'),
 (622, 'Yvette'),
 (623, 'Willard'),
 (624, 'Whitney'),
 (625, 'Virgil'),
 (626, 'Ross'),
 (627, 'Opal'),
 (628, 'Melody'),
 (629, 'Maryann'),
 (630, 'Marshall'),
 (631, 'Fannie'),
 (632, 'Clifton'),
 (633, 'Alison'),
 (634, 'Susie'),
 (635, 'Shelley'),
 (636, 'Sergio'),
 (637, 'Salvador'),
 (638, 'Olivia'),
 (639, 'Luz'),
 (640, 'Kirk'),
 (641, 'Flora'),
 (642, 'Andy'),
 (643, 'Verna'),
 (644, 'Terrance'),
 (645, 'Seth'),
 (646, 'Mamie'),
 (647, 'Lula'),
 (648, 'Lola'),
 (649, 'Kristy'),
 (650, 'Kent'),
 (651, 'Beulah'),
 (652, 'Antoinette'),
 (653, 'Terrence'),
 (654, 'Gayle'),
 (655, 'Eduardo'),
 (656, 'Pam'),
 (657, 'Kelli'),
 (658, 'Juana'),
 (659, 'Joey'),
 (660, 'Jeannette'),
 (661, 'Enrique'),
 (662, 'Donnie'),
 (663, 'Candice'),
 (664, 'Wade'),
 (665, 'Hannah'),
 (666, 'Frankie'),
 (667, 'Bridget'),
 (668, 'Austin'),
 (669, 'Stuart'),
 (670, 'Karla'),
 (671, 'Evan'),
 (672, 'Celia'),
 (673, 'Vicky'),
 (674, 'Shelia'),
 (675, 'Patty'),
 (676, 'Nick'),
 (677, 'Lynne'),
 (678, 'Luther'),
 (679, 'Latoya'),
 (680, 'Fredrick'),
 (681, 'Della'),
 (682, 'Arturo'),
 (683, 'Alejandro'),
 (684, 'Wendell'),
 (685, 'Sheri'),
 (686, 'Marianne'),
 (687, 'Julius'),
 (688, 'Jeremiah'),
 (689, 'Shaun'),
 (690, 'Otis'),
 (691, 'Kara'),
 (692, 'Jacquelyn'),
 (693, 'Erma'),
 (694, 'Blanca'),
 (695, 'Angelo'),
 (696, 'Alexis'),
 (697, 'Trevor'),
 (698, 'Roxanne'),
 (699, 'Oliver'),
 (700, 'Myra'),
 (701, 'Morgan'),
 (702, 'Luke'),
 (703, 'Leticia'),
 (704, 'Krista'),
 (705, 'Homer'),
 (706, 'Gerard'),
 (707, 'Doug'),
 (708, 'Cameron'),
 (709, 'Sadie'),
 (710, 'Rosalie'),
 (711, 'Robyn'),
 (712, 'Kenny'),
 (713, 'Ira'),
 (714, 'Hubert'),
 (715, 'Brooke'),
 (716, 'Bethany'),
 (717, 'Bernadette'),
 (718, 'Bennie'),
 (719, 'Antonia'),
 (720, 'Angelica'),
 (721, 'Alexandra'),
 (722, 'Adrienne'),
 (723, 'Traci'),
 (724, 'Rachael'),
 (725, 'Nichole'),
 (726, 'Muriel'),
 (727, 'Matt'),
 (728, 'Mable'),
 (729, 'Lyle'),
 (730, 'Laverne'),
 (731, 'Kendra'),
 (732, 'Jasmine'),
 (733, 'Ernestine'),
 (734, 'Chelsea'),
 (735, 'Alfonso'),
 (736, 'Rex'),
 (737, 'Orlando'),
 (738, 'Ollie'),
 (739, 'Neal'),
 (740, 'Marcella'),
 (741, 'Loren'),
 (742, 'Krystal'),
 (743, 'Ernesto'),
 (744, 'Elena'),
 (745, 'Carlton'),
 (746, 'Blake'),
 (747, 'Angelina'),
 (748, 'Wilbur'),
 (749, 'Taylor'),
 (750, 'Shelby'),
 (751, 'Rudy'),
 (752, 'Roderick'),
 (753, 'Paulette'),
 (754, 'Pablo'),
 (755, 'Omar'),
 (756, 'Noel'),
 (757, 'Nadine'),
 (758, 'Lorenzo'),
 (759, 'Lora'),
 (760, 'Leigh'),
 (761, 'Kari'),
 (762, 'Horace'),
 (763, 'Grant'),
 (764, 'Estelle'),
 (765, 'Dianna'),
 (766, 'Willis'),
 (767, 'Rosemarie'),
 (768, 'Rickey'),
 (769, 'Mona'),
 (770, 'Kelley'),
 (771, 'Doreen'),
 (772, 'Desiree'),
 (773, 'Abraham'),
 (774, 'Rudolph'),
 (775, 'Preston'),
 (776, 'Malcolm'),
 (777, 'Kelvin'),
 (778, 'Johnathan'),
 (779, 'Janis'),
 (780, 'Hope'),
 (781, 'Ginger'),
 (782, 'Freda'),
 (783, 'Damon'),
 (784, 'Christie'),
 (785, 'Cesar'),
 (786, 'Betsy'),
 (787, 'Andres'),
 (788, 'Wm'),
 (789, 'Tommie'),
 (790, 'Teri'),
 (791, 'Robbie'),
 (792, 'Meredith'),
 (793, 'Mercedes'),
 (794, 'Marco'),
 (795, 'Lynette'),
 (796, 'Eula'),
 (797, 'Cristina'),
 (798, 'Archie'),
 (799, 'Alton'),
 (800, 'Sophia'),
 (801, 'Rochelle'),
 (802, 'Randolph'),
 (803, 'Pete'),
 (804, 'Merle'),
 (805, 'Meghan'),
 (806, 'Jonathon'),
 (807, 'Gretchen'),
 (808, 'Gerardo'),
 (809, 'Geoffrey'),
 (810, 'Garry'),
 (811, 'Felipe'),
 (812, 'Eloise'),
 (813, 'Ed'),
 (814, 'Dominic'),
 (815, 'Devin'),
 (816, 'Cecelia'),
 (817, 'Carroll'),
 (818, 'Raquel'),
 (819, 'Lucas'),
 (820, 'Jana'),
 (821, 'Henrietta'),
 (822, 'Gwen'),
 (823, 'Guillermo'),
 (824, 'Earnest'),
 (825, 'Delbert'),
 (826, 'Colin'),
 (827, 'Alyssa'),
 (828, 'Tricia'),
 (829, 'Tasha'),
 (830, 'Spencer'),
 (831, 'Rodolfo'),
 (832, 'Olive'),
 (833, 'Myron'),
 (834, 'Jenna'),
 (835, 'Edmund'),
 (836, 'Cleo'),
 (837, 'Benny'),
 (838, 'Sophie'),
 (839, 'Sonja'),
 (840, 'Silvia'),
 (841, 'Salvatore'),
 (842, 'Patti'),
 (843, 'Mindy'),
 (844, 'May'),
 (845, 'Mandy'),
 (846, 'Lowell'),
 (847, 'Lorena'),
 (848, 'Lila'),
 (849, 'Lana'),
 (850, 'Kellie'),
 (851, 'Kate'),
 (852, 'Jewel'),
 (853, 'Gregg'),
 (854, 'Garrett'),
 (855, 'Essie'),
 (856, 'Elvira'),
 (857, 'Delia'),
 (858, 'Darla'),
 (859, 'Cedric'),
 (860, 'Wilson'),
 (861, 'Sylvester'),
 (862, 'Sherman'),
 (863, 'Shari'),
 (864, 'Roosevelt'),
 (865, 'Miranda'),
 (866, 'Marty'),
 (867, 'Marta'),
 (868, 'Lucia'),
 (869, 'Lorene'),
 (870, 'Lela'),
 (871, 'Josefina'),
 (872, 'Johanna'),
 (873, 'Jermaine'),
 (874, 'Jeannie'),
 (875, 'Israel'),
 (876, 'Faith'),
 (877, 'Elsa'),
 (878, 'Dixie'),
 (879, 'Camille'),
 (880, 'Winifred'),
 (881, 'Wilbert'),
 (882, 'Tami'),
 (883, 'Tabitha'),
 (884, 'Shawna'),
 (885, 'Rena'),
 (886, 'Ora'),
 (887, 'Nettie'),
 (888, 'Melba'),
 (889, 'Marina'),
 (890, 'Leland'),
 (891, 'Kristie'),
 (892, 'Forrest'),
 (893, 'Elisa'),
 (894, 'Ebony'),
 (895, 'Alisha'),
 (896, 'Aimee'),
 (897, 'Tammie'),
 (898, 'Simon'),
 (899, 'Sherrie'),
 (900, 'Sammy'),
 (901, 'Ronda'),
 (902, 'Patrice'),
 (903, 'Owen'),
 (904, 'Myrna'),
 (905, 'Marla'),
 (906, 'Latasha'),
 (907, 'Irving'),
 (908, 'Dallas'),
 (909, 'Clark'),
 (910, 'Bryant'),
 (911, 'Bonita'),
 (912, 'Aubrey'),
 (913, 'Addie'),
 (914, 'Woodrow'),
 (915, 'Stacie'),
 (916, 'Rufus'),
 (917, 'Rosario'),
 (918, 'Rebekah'),
 (919, 'Marcos'),
 (920, 'Mack'),
 (921, 'Lupe'),
 (922, 'Lucinda'),
 (923, 'Lou'),
 (924, 'Levi'),
 (925, 'Laurence'),
 (926, 'Kristopher'),
 (927, 'Jewell'),
 (928, 'Jake'),
 (929, 'Gustavo'),
 (930, 'Francine'),
 (931, 'Ellis'),
 (932, 'Drew'),
 (933, 'Dorthy'),
 (934, 'Deloris'),
 (935, 'Cheri'),
 (936, 'Celeste'),
 (937, 'Cara'),
 (938, 'Adriana'),
 (939, 'Adele'),
 (940, 'Abigail'),
 (941, 'Trisha'),
 (942, 'Trina'),
 (943, 'Tracie'),
 (944, 'Sallie'),
 (945, 'Reba'),
 (946, 'Orville'),
 (947, 'Nikki'),
 (948, 'Nicolas'),
 (949, 'Marissa'),
 (950, 'Lourdes'),
 (951, 'Lottie'),
 (952, 'Lionel'),
 (953, 'Lenora'),
 (954, 'Laurel'),
 (955, 'Kerri'),
 (956, 'Kelsey'),
 (957, 'Karin'),
 (958, 'Josie'),
 (959, 'Janelle'),
 (960, 'Ismael'),
 (961, 'Helene'),
 (962, 'Gilberto'),
 (963, 'Gale'),
 (964, 'Francisca'),
 (965, 'Fern'),
 (966, 'Etta'),
 (967, 'Estella'),
 (968, 'Elva'),
 (969, 'Effie'),
 (970, 'Dominique'),
 (971, 'Corinne'),
 (972, 'Clint'),
 (973, 'Brittney'),
 (974, 'Aurora'),
 (975, 'Wilfred'),
 (976, 'Tomas'),
 (977, 'Toby'),
 (978, 'Sheldon'),
 (979, 'Santos'),
 (980, 'Maude'),
 (981, 'Lesley'),
 (982, 'Josh'),
 (983, 'Jenifer'),
 (984, 'Iva'),
 (985, 'Ingrid'),
 (986, 'Ina'),
 (987, 'Ignacio'),
 (988, 'Hugo'),
 (989, 'Goldie'),
 (990, 'Eugenia'),
 (991, 'Ervin'),
 (992, 'Erick'),
 (993, 'Elisabeth'),
 (994, 'Dewey'),
 (995, 'Christa'),
 (996, 'Cassie'),
 (997, 'Cary'),
 (998, 'Caleb'),
 (999, 'Caitlin'),
 (1000, 'Bettie')
SET IDENTITY_INSERT r.Friend OFF

/*
-- Create r.FriendOf relationship table
TRUNCATE TABLE r.FriendOf

-- Create 10 relationships for each of the 1st 100 people using the first 500 names
DECLARE @j int = 1
WHILE @j <= 100
BEGIN
	DECLARE @i int = 1
	WHILE @i <= 10
	BEGIN
		INSERT INTO r.FriendOf (Id1, Id2)
		 VALUES (@j, FLOOR(RAND() * 500) + 1)
		SET @i += 1
	END
	SET @j += 1
END
GO

-- Can't be friends with yourself
DELETE FROM r.FriendOf WHERE Id1 = Id2
GO

-- Delete any duplicates
;WITH DupesCte AS (
	SELECT
		*,
		RowNum = ROW_NUMBER() OVER (PARTITION BY Id1, Id2 ORDER BY Id2)
	FROM
		r.FriendOf
)
DELETE FROM DupesCte WHERE RowNum > 1
 
SELECT COUNT(*) FROM r.FriendOf
*/

INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 288)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 271)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 37)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 212)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 112)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 52)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 41)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 323)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (1, 211)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 6)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 402)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 435)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 38)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 469)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 58)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (2, 497)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 85)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 499)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 12)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 363)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 385)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 389)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 88)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 339)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (3, 190)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 403)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 462)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 370)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 46)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 472)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 193)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 227)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 148)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 493)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (4, 83)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 281)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 221)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 194)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 15)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 373)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 74)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 226)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 182)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 297)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (5, 308)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 279)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 370)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 480)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 286)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 216)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 257)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 405)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 71)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (6, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 37)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 109)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 67)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 332)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 421)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 130)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 43)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 108)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (7, 451)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 268)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 1)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 127)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 42)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 396)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 440)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 277)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 242)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 275)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (8, 439)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 312)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 444)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 53)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 105)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 68)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 31)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 232)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 345)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (9, 350)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 4)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 464)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 226)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 20)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 22)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 196)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 434)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 384)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 171)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (10, 433)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 448)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 386)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 411)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 484)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 179)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 414)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 62)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 202)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 38)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (11, 265)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 497)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 393)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 412)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 290)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 121)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 480)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 40)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 264)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 244)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (12, 386)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 125)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 30)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 187)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 261)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 378)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 346)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 281)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 40)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (13, 234)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 329)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 167)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 390)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 483)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 397)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 252)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 413)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 396)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 321)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (14, 176)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 402)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 42)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 56)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 155)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 288)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 108)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 218)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 303)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 265)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (15, 75)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 65)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 491)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 422)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 154)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 231)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 457)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 463)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 141)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 329)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (16, 240)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 160)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 173)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 320)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 405)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 401)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 402)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 294)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 449)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (17, 409)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 399)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 179)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 171)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 252)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 463)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 379)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 86)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (18, 491)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 486)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 459)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 449)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 413)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 425)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 328)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 468)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 234)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (19, 490)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 120)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 261)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 41)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 239)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 6)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 330)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 28)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 476)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 238)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (20, 441)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 301)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 163)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 140)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 390)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 316)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 66)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 130)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 277)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 312)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (21, 474)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 387)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 284)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 484)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 442)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 352)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 200)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 164)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 281)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 137)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (22, 332)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 490)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 253)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 217)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 493)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 179)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 170)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 359)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 21)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 201)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (23, 100)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 74)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 86)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 129)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 270)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 458)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 443)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 406)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 239)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 474)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (24, 135)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 266)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 11)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 56)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 154)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 475)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 27)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 385)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 269)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 78)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (25, 436)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 259)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 199)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 159)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 474)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 257)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 437)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 402)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 242)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 381)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (26, 287)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 347)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 21)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 349)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 54)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 255)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 41)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 465)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 125)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (27, 388)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 103)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 186)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 469)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 400)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 288)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 389)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 181)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 161)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 452)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (28, 262)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 417)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 291)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 493)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 100)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 194)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 431)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 91)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 138)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 45)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (29, 118)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 288)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 45)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 52)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 354)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 450)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 352)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 480)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 96)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (30, 305)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 229)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 207)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 88)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 432)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 493)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 292)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 332)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 300)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (31, 286)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 53)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 490)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 452)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 201)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 79)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 484)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 169)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 82)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (32, 412)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 408)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 477)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 258)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 269)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 294)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 169)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 427)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 155)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (33, 156)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 459)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 388)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 236)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 480)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 358)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 19)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 185)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 99)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 329)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (34, 228)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 291)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 417)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 359)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 460)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 309)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 179)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 325)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 47)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 316)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (35, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 472)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 11)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 473)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 433)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 298)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 202)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 294)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 351)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (36, 25)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 357)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 29)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 168)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 174)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 159)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 42)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 264)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 77)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (37, 138)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 44)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 43)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 307)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 350)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 441)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 223)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 466)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 460)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 297)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (38, 8)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 140)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 109)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 323)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 72)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 337)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 119)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 194)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 25)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (39, 405)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 432)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 143)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 311)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 36)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 279)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 64)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 61)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 278)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 253)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (40, 165)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 470)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 258)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 448)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 496)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 68)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 243)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 422)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 335)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 22)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (41, 443)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 88)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 49)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 208)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 277)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 468)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 26)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 340)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 360)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 460)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (42, 145)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 403)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 304)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 121)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 416)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 343)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 476)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 66)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 500)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 188)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (43, 448)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 435)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 418)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 193)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 423)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 15)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 427)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 351)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 329)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 103)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (44, 393)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 404)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 95)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 31)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 422)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 245)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 424)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 309)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 186)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 303)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (45, 365)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 373)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 327)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 107)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 243)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 393)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 337)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 221)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 108)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 394)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (46, 57)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 379)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 249)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 103)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 487)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 243)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 409)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 132)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 224)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 34)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (47, 4)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 458)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 410)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 101)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 204)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 476)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 224)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 14)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 408)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 287)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (48, 376)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 382)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 412)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 334)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 130)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 141)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 134)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 59)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 265)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (49, 318)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 10)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 333)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 368)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 405)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 372)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 256)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 48)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 12)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (50, 52)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 379)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 168)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 14)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 170)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 469)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 285)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 458)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 411)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 182)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (51, 357)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 208)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 388)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 183)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 439)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 296)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 66)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 298)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 273)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (52, 479)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 273)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 270)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 321)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 119)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 303)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 336)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 346)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 474)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (53, 417)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 218)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 90)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 144)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 137)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 206)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 382)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 316)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 211)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 168)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (54, 209)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 294)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 467)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 75)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 236)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 448)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 128)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 281)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 215)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 137)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (55, 337)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 285)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 372)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 45)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 290)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 472)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 24)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 77)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 236)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 14)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (56, 486)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 38)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 386)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 460)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 112)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 115)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 311)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 36)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 472)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 474)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (57, 72)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 480)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 253)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 112)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 135)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 105)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 317)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 498)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 387)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 170)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (58, 456)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 494)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 35)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 282)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 138)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 192)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 413)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 160)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 34)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 405)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (59, 134)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 98)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 190)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 492)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 246)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 331)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 422)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 77)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 411)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 361)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (60, 151)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 469)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 339)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 233)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 468)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 18)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 430)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 182)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 19)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 184)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (61, 206)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 372)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 297)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 302)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 396)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 392)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 143)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 207)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 19)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 239)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (62, 170)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 229)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 148)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 121)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 237)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 456)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 75)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 443)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 50)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 436)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (63, 53)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 241)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 248)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 483)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 139)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 298)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 131)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 72)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 373)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 54)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (64, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 457)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 475)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 481)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 84)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 195)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 407)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (65, 189)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 245)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 479)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 298)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 325)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 116)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 38)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 50)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 264)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 154)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (66, 482)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 247)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 436)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 179)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 400)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 90)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 384)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 296)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 370)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 261)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (67, 317)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 94)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 172)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 206)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 434)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 84)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 413)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 189)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 7)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 392)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (68, 456)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 441)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 96)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 103)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 410)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 436)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 150)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 308)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 22)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 16)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (69, 257)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 428)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 199)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 238)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 246)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 275)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 241)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 128)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 229)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 443)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (70, 4)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 143)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 212)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 41)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 228)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 309)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 33)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 396)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 389)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 313)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (71, 430)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 151)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 430)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 371)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 276)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 431)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 442)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 215)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (72, 75)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 347)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 311)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 352)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 471)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 18)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 318)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 10)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 338)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 195)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (73, 61)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 175)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 359)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 30)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 217)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 372)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 138)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 442)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 160)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 83)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (74, 251)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 302)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 257)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 236)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 123)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 341)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 93)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 366)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 190)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (75, 469)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 241)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 352)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 380)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 367)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 249)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 152)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 207)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 330)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 16)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (76, 206)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 489)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 231)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 106)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 222)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 263)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 85)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 76)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (77, 381)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 271)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 395)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 448)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 334)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 156)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 200)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 343)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 488)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 45)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (78, 383)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 192)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 358)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 452)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 63)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 18)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 376)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 200)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 404)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 330)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (79, 181)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 444)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 176)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 418)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 351)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 376)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 322)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 315)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 390)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 100)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (80, 160)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 142)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 327)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 365)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 498)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 76)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 491)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 449)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 194)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 45)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (81, 151)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 95)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 413)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 369)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 69)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 330)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 158)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 58)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 458)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 336)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (82, 340)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 136)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 31)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 293)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 401)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 131)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 400)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 278)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 268)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 484)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (83, 352)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 310)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 104)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 380)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 2)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 477)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 230)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 462)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 499)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (84, 424)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 484)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 435)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 424)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 333)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 450)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 121)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 464)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (85, 27)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 263)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 496)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 304)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 442)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 402)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 113)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 76)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 438)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 476)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (86, 326)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 425)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 114)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 201)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 398)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 170)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 60)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 324)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 392)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 190)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (87, 433)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 280)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 98)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 459)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 178)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 205)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 226)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 493)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 415)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 354)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (88, 190)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 78)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 391)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 111)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 393)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 471)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 107)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 199)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 204)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (89, 221)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 42)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 149)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 450)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 318)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 409)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 235)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 36)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 407)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 22)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (90, 33)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 67)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 87)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 12)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 473)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 409)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 403)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 220)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 16)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 118)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (91, 271)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 139)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 96)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 443)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 460)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 311)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 333)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 175)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 59)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 20)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (92, 411)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 395)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 155)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 71)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 152)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 115)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 77)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 334)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 7)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 56)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (93, 425)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 146)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 350)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 377)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 340)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 245)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 457)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 200)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 398)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 236)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (94, 124)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 186)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 159)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 255)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 205)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 332)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 435)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 390)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 461)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 121)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (95, 51)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 461)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 26)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 191)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 186)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 257)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 494)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 322)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 308)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 128)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (96, 398)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 274)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 482)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 5)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 61)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 44)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 371)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 254)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 467)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 181)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (97, 111)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 453)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 468)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 199)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 457)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 153)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 377)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 11)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 424)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (98, 159)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 122)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 500)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 495)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 225)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 421)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 456)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 336)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 324)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 437)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (99, 298)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 459)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 428)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 147)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 331)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 445)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 143)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 303)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 133)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 346)
INSERT INTO [r].[FriendOf] ([Id1], [Id2]) VALUES (100, 402)
