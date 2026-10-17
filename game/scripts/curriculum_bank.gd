extends RefCounted
class_name Year2CurriculumBank

# Offline-first question bank mapped to England's Key Stage 1 / Year 2 curriculum.
# Each item has a unique ID, subject, strand, question, three answers, correct index,
# hint, explanation, and a short voice script. Review locally before expanding the bank.
static func all_questions() -> Array[Dictionary]:
	var result: Array[Dictionary] = [
		{"id":"ma_place_01","subject":"MATHS","strand":"Place value","question":"What is the value of the 4 in  forty-two?","answers":["4","40","2"],"correct":1,"hint":"The 4 is in the tens place.","explanation":"Forty-two is made of 4 tens and 2 ones. The digit 4 is worth 40.","voice":"What is the value of the 4 in forty-two? A: 4. B: 40. C: 2."},
		{"id":"ma_place_02","subject":"MATHS","strand":"Place value","question":"Which number is one more than 69?","answers":["68","70","79"],"correct":1,"hint":"Count forward one step.","explanation":"After 69 comes 70. Adding one more changes 69 to 70.","voice":"Which number is one more than sixty-nine? A: sixty-eight. B: seventy. C: seventy-nine."},
		{"id":"ma_place_03","subject":"MATHS","strand":"Place value","question":"Which number is the greatest?","answers":["128","182","118"],"correct":1,"hint":"Compare the tens after checking the hundreds.","explanation":"All have 1 hundred. 182 has 8 tens, more than 128's 2 tens or 118's 1 ten.","voice":"Which number is greatest: one hundred twenty-eight, one hundred eighty-two, or one hundred eighteen?"},
		{"id":"ma_add_01","subject":"MATHS","strand":"Addition","question":"What is 36 + 27?","answers":["53","63","73"],"correct":1,"hint":"Add tens and ones, regrouping if needed.","explanation":"30 + 20 = 50 and 6 + 7 = 13. 50 + 13 = 63.","voice":"What is thirty-six plus twenty-seven?"},
		{"id":"ma_sub_01","subject":"MATHS","strand":"Subtraction","question":"What is 52 − 18?","answers":["34","36","44"],"correct":0,"hint":"Subtract 20, then add 2 back.","explanation":"52 − 20 = 32. Add 2 back because we subtracted 2 too many: 34.","voice":"What is fifty-two minus eighteen?"},
		{"id":"ma_mult_01","subject":"MATHS","strand":"Multiplication","question":"There are 4 bags with 5 apples in each. How many apples?","answers":["9","20","25"],"correct":1,"hint":"Add 5 four times, or calculate 4 × 5.","explanation":"Four groups of five make 5 + 5 + 5 + 5 = 20. So 4 × 5 = 20.","voice":"Four bags have five apples each. How many apples are there?"},
		{"id":"ma_div_01","subject":"MATHS","strand":"Division","question":"Share 18 counters equally between 2 children. How many each?","answers":["8","9","10"],"correct":1,"hint":"Find half of 18.","explanation":"18 shared into 2 equal groups gives 9 in each group. 18 ÷ 2 = 9.","voice":"Share eighteen counters equally between two children. How many does each child get?"},
		{"id":"ma_frac_01","subject":"MATHS","strand":"Fractions","question":"What is one quarter of 20?","answers":["4","5","10"],"correct":1,"hint":"Split 20 into 4 equal groups.","explanation":"20 ÷ 4 = 5, so one quarter of 20 is 5.","voice":"What is one quarter of twenty?"},
		{"id":"ma_shape_01","subject":"MATHS","strand":"Shape","question":"How many sides does a hexagon have?","answers":["5","6","8"],"correct":1,"hint":"Hex means six.","explanation":"A hexagon is a 2D shape with six straight sides and six vertices.","voice":"How many sides does a hexagon have?"},
		{"id":"ma_time_01","subject":"MATHS","strand":"Time","question":"The minute hand points to 6 and the hour hand is between 3 and 4. What time is it?","answers":["Half past three","Half past four","Quarter past three"],"correct":0,"hint":"The minute hand at 6 means thirty minutes past.","explanation":"At half past three, 30 minutes have passed after 3 o'clock, so the hour hand is between 3 and 4.","voice":"The minute hand points to six and the hour hand is between three and four. What time is it?"},
		{"id":"ma_money_01","subject":"MATHS","strand":"Money","question":"A toy costs 35p. You pay 50p. What change should you get?","answers":["10p","15p","25p"],"correct":1,"hint":"Count up from 35p to 50p.","explanation":"From 35p to 40p is 5p, then to 50p is 10p. Total change is 15p.","voice":"A toy costs thirty-five pence. You pay fifty pence. What change should you get?"},
		{"id":"ma_measure_01","subject":"MATHS","strand":"Measurement","question":"Which unit is best for measuring a classroom's length?","answers":["Centimetres only","Metres","Millilitres"],"correct":1,"hint":"Choose a unit for a fairly long distance.","explanation":"Metres are useful for measuring room lengths. Millilitres measure liquid volume.","voice":"Which unit is best for measuring a classroom's length?"},
		{"id":"ma_stats_01","subject":"MATHS","strand":"Statistics","question":"A tally chart shows 7 votes for cats and 5 for dogs. How many votes altogether?","answers":["12","2","35"],"correct":0,"hint":"Add the two groups.","explanation":"7 + 5 = 12 votes altogether.","voice":"A chart shows seven votes for cats and five for dogs. How many votes altogether?"},
		{"id":"en_noun_01","subject":"ENGLISH","strand":"Grammar","question":"Which word is a noun?","answers":["happily","garden","jumping"],"correct":1,"hint":"A noun names a person, place or thing.","explanation":"Garden names a place, so it is a noun. Happily is an adverb.","voice":"Which word is a noun? A: happily. B: garden. C: jumping."},
		{"id":"en_verb_01","subject":"ENGLISH","strand":"Grammar","question":"Which word is the verb in 'The rabbit hops'?","answers":["rabbit","the","hops"],"correct":2,"hint":"Find the action word.","explanation":"Hops tells us what the rabbit does, so it is the verb.","voice":"Which word is the verb in the sentence, the rabbit hops?"},
		{"id":"en_adj_01","subject":"ENGLISH","strand":"Grammar","question":"Which word is an adjective in 'the shiny coin'?","answers":["the","shiny","coin"],"correct":1,"hint":"An adjective describes a noun.","explanation":"Shiny describes what the coin looks like, so it is an adjective.","voice":"Which word is an adjective in the shiny coin?"},
		{"id":"en_punct_01","subject":"ENGLISH","strand":"Punctuation","question":"Which punctuation mark ends a question?","answers":["?","!","."],"correct":0,"hint":"It is shaped like a curved line with a dot.","explanation":"A question mark (?) goes at the end of a direct question.","voice":"Which punctuation mark ends a question?"},
		{"id":"en_spell_01","subject":"ENGLISH","strand":"Spelling","question":"Which spelling is correct?","answers":["because","becos","becuase"],"correct":0,"hint":"Say the word slowly: be-cause.","explanation":"The correct spelling is because. Practise saying and writing the word.","voice":"Which spelling is correct: because, becos, or becuase?"},
		{"id":"en_suffix_01","subject":"ENGLISH","strand":"Word building","question":"Add -ed to 'jump'. Which word shows it happened yesterday?","answers":["jumping","jumped","jumps"],"correct":1,"hint":"The suffix -ed often shows past tense.","explanation":"Jumped tells us the action happened in the past.","voice":"Add ed to jump. Which word shows it happened yesterday?"},
		{"id":"en_comp_01","subject":"ENGLISH","strand":"Comprehension","question":"Mia put on her coat because the rain began. Why did Mia put on her coat?","answers":["It was raining","She was hungry","It was bedtime"],"correct":0,"hint":"Look for the reason after 'because'.","explanation":"The sentence tells us the rain began, so Mia put on her coat because it was raining.","voice":"Mia put on her coat because the rain began. Why did Mia put on her coat?"},
		{"id":"en_alpha_01","subject":"ENGLISH","strand":"Alphabetical order","question":"Which word comes first alphabetically?","answers":["pear","apple","plum"],"correct":1,"hint":"Compare the first letters.","explanation":"Apple begins with A, which comes before P, so apple comes first.","voice":"Which word comes first alphabetically: pear, apple, or plum?"},
		{"id":"en_syn_01","subject":"ENGLISH","strand":"Vocabulary","question":"Which word is closest in meaning to 'enormous'?","answers":["tiny","huge","quiet"],"correct":1,"hint":"Think of something very, very big.","explanation":"Enormous means very large. Huge has a similar meaning.","voice":"Which word is closest in meaning to enormous: tiny, huge, or quiet?"},
		{"id":"en_hom_01","subject":"ENGLISH","strand":"Vocabulary","question":"Choose the correct word: 'I can ___ the birds singing.'","answers":["hear","here","hare"],"correct":0,"hint":"Which word means to listen with your ears?","explanation":"Hear means to notice a sound. Here means a place; a hare is an animal.","voice":"Choose the correct word: I can hear the birds singing."},
		{"id":"en_write_01","subject":"ENGLISH","strand":"Sentence writing","question":"Which is a complete sentence?","answers":["Under the table","The dog barked.","Because it was"],"correct":1,"hint":"A complete sentence makes sense on its own.","explanation":"The dog barked tells us who and what happened, and it ends with a full stop.","voice":"Which is a complete sentence: under the table, the dog barked, or because it was?"},
		{"id":"sc_living_01","subject":"SCIENCE","strand":"Living things","question":"Which one is a living thing?","answers":["A stone","A daisy plant","A plastic cup"],"correct":1,"hint":"Living things grow and need resources.","explanation":"A daisy is a plant. It grows and needs light, water and air.","voice":"Which one is a living thing: a stone, a daisy plant, or a plastic cup?"},
		{"id":"sc_habitat_01","subject":"SCIENCE","strand":"Habitats","question":"Which animal is well suited to living in a pond?","answers":["Frog","Camel","Polar bear"],"correct":0,"hint":"Think of an animal that can live in water and on land.","explanation":"Frogs are amphibians and are often found in ponds and other damp habitats.","voice":"Which animal is well suited to living in a pond: a frog, camel, or polar bear?"},
		{"id":"sc_food_01","subject":"SCIENCE","strand":"Animals and humans","question":"Which food helps build and repair muscles?","answers":["Eggs","Sweets only","Fizzy drinks"],"correct":0,"hint":"Think of a food that contains protein.","explanation":"Eggs contain protein, which helps the body grow and repair itself. A balanced diet includes different foods.","voice":"Which food helps build and repair muscles: eggs, sweets only, or fizzy drinks?"},
		{"id":"sc_senses_01","subject":"SCIENCE","strand":"Animals and humans","question":"Which sense do we use with our ears?","answers":["Smell","Hearing","Taste"],"correct":1,"hint":"Ears help us notice sounds.","explanation":"We use our ears for hearing sounds around us.","voice":"Which sense do we use with our ears: smell, hearing, or taste?"},
		{"id":"sc_material_01","subject":"SCIENCE","strand":"Materials","question":"Which material is usually transparent?","answers":["Clear glass","Brick","Wood"],"correct":0,"hint":"You can see through it.","explanation":"Clear glass lets light pass through so we can see objects on the other side.","voice":"Which material is usually transparent: clear glass, brick, or wood?"},
		{"id":"sc_material_02","subject":"SCIENCE","strand":"Materials","question":"Which material is attracted to a magnet?","answers":["Iron","Paper","Rubber"],"correct":0,"hint":"Magnets attract some metals.","explanation":"Iron is magnetic. Paper and rubber are not attracted to an ordinary magnet.","voice":"Which material is attracted to a magnet: iron, paper, or rubber?"},
		{"id":"sc_plants_01","subject":"SCIENCE","strand":"Plants","question":"What do most plants need to grow well?","answers":["Water and light","Only darkness","Plastic"],"correct":0,"hint":"Think about what plants get from rain and sunshine.","explanation":"Plants need water and light, as well as air and suitable conditions, to grow healthily.","voice":"What do most plants need to grow well: water and light, only darkness, or plastic?"},
		{"id":"sc_plants_02","subject":"SCIENCE","strand":"Plants","question":"Which part of a plant usually takes in water from the soil?","answers":["Roots","Petals","Fruit"],"correct":0,"hint":"This part grows under the ground.","explanation":"Roots anchor a plant and take up water and minerals from the soil.","voice":"Which part of a plant usually takes in water from the soil: roots, petals, or fruit?"},
		{"id":"sc_season_01","subject":"SCIENCE","strand":"Seasonal changes","question":"In the UK, which season usually has the shortest days?","answers":["Summer","Winter","Spring"],"correct":1,"hint":"Think of December and January.","explanation":"Winter has the shortest daylight hours in the UK, although the exact day length changes through the season.","voice":"In the UK, which season usually has the shortest days: summer, winter, or spring?"},
		{"id":"sc_life_01","subject":"SCIENCE","strand":"Life cycles","question":"Which is the usual order for a butterfly's life cycle?","answers":["Egg, caterpillar, chrysalis, adult","Adult, egg, adult, stone","Caterpillar, seed, egg, adult"],"correct":0,"hint":"A caterpillar changes inside a chrysalis.","explanation":"A butterfly develops from an egg to a caterpillar, then a chrysalis, and finally an adult butterfly.","voice":"What is the usual order for a butterfly's life cycle?"},
		{"id":"co_safe_01","subject":"COMPUTING","strand":"Online safety","question":"A stranger online asks for your home address. What should you do?","answers":["Tell them","Keep it private and tell a trusted adult","Post it publicly"],"correct":1,"hint":"Personal information should stay private.","explanation":"Never share your address with strangers online. Stop and tell a trusted adult if something feels wrong.","voice":"A stranger online asks for your home address. What should you do?"},
		{"id":"co_algo_01","subject":"COMPUTING","strand":"Algorithms","question":"What is an algorithm?","answers":["A set of ordered instructions","A kind of sandwich","A computer screen"],"correct":0,"hint":"It tells someone or something what steps to follow.","explanation":"An algorithm is a sequence of instructions used to complete a task or solve a problem.","voice":"What is an algorithm: a set of ordered instructions, a sandwich, or a computer screen?"},
		{"id":"co_debug_01","subject":"COMPUTING","strand":"Debugging","question":"A program does the wrong thing. What should you try to do?","answers":["Find and fix the error","Delete the keyboard","Ignore every result"],"correct":0,"hint":"Computer scientists look for mistakes in instructions.","explanation":"Debugging means finding and correcting errors in a program or algorithm.","voice":"A program does the wrong thing. What should you try to do?"},
		{"id":"hi_past_01","subject":"HISTORY","strand":"Chronology","question":"Which happened furthest in the past?","answers":["Yesterday","Last year","A hundred years ago"],"correct":2,"hint":"Compare how long ago each event happened.","explanation":"A hundred years ago is further in the past than last year or yesterday.","voice":"Which happened furthest in the past: yesterday, last year, or a hundred years ago?"},
		{"id":"hi_source_01","subject":"HISTORY","strand":"Historical sources","question":"Which could help a historian learn about a child's life 100 years ago?","answers":["An old photograph","A brand-new game advert only","A guess with no evidence"],"correct":0,"hint":"Historians use evidence from the past.","explanation":"Old photographs can provide evidence about clothes, places and daily life, though historians compare different sources too.","voice":"Which could help a historian learn about a child's life one hundred years ago?"},
		{"id":"hi_person_01","subject":"HISTORY","strand":"Significant people","question":"Who was Florence Nightingale known for helping?","answers":["Sick and injured people","Building rockets","Painting the Mona Lisa"],"correct":0,"hint":"She is remembered for nursing and improving hospitals.","explanation":"Florence Nightingale was a famous nurse who helped improve nursing and hospital conditions.","voice":"Who was Florence Nightingale known for helping?"},
		{"id":"hi_person_02","subject":"HISTORY","strand":"Significant people","question":"Who was Neil Armstrong?","answers":["The first person to walk on the Moon","A famous Roman emperor","The inventor of the telephone"],"correct":0,"hint":"Think about the Apollo 11 Moon landing.","explanation":"Neil Armstrong became the first person to walk on the Moon in 1969 during Apollo 11.","voice":"Who was Neil Armstrong: the first person to walk on the Moon, a Roman emperor, or the inventor of the telephone?"},
		{"id":"ge_map_01","subject":"GEOGRAPHY","strand":"Maps","question":"What does a map key help you understand?","answers":["What map symbols mean","The weather tomorrow for certain","How old a map reader is"],"correct":0,"hint":"A key explains symbols.","explanation":"A map key or legend explains the symbols used on a map, such as a picture for a school or a road.","voice":"What does a map key help you understand?"},
		{"id":"ge_uk_01","subject":"GEOGRAPHY","strand":"United Kingdom","question":"Birmingham is in which part of the United Kingdom?","answers":["England","Scotland","Northern Ireland"],"correct":0,"hint":"Birmingham is a city in the West Midlands.","explanation":"Birmingham is a city in the West Midlands region of England.","voice":"Birmingham is in which part of the United Kingdom: England, Scotland, or Northern Ireland?"},
		{"id":"ge_human_01","subject":"GEOGRAPHY","strand":"Human and physical features","question":"Which is a physical feature?","answers":["A river","A supermarket","A bridge built by people"],"correct":0,"hint":"Physical features are natural parts of the environment.","explanation":"A river is a natural physical feature. Supermarkets and bridges are human-made features.","voice":"Which is a physical feature: a river, a supermarket, or a bridge built by people?"},
		{"id":"ge_weather_01","subject":"GEOGRAPHY","strand":"Weather","question":"Which tool measures how much rain has fallen?","answers":["Rain gauge","Compass","Ruler for temperature"],"correct":0,"hint":"It collects and measures rainfall.","explanation":"A rain gauge collects rainfall so the amount can be measured.","voice":"Which tool measures how much rain has fallen: a rain gauge, compass, or ruler?"},
		{"id":"art_line_01","subject":"ART","strand":"Drawing","question":"Which line is usually called a zigzag?","answers":["A line with sharp turns","A perfectly straight line","A circle"],"correct":0,"hint":"Think of repeated sharp corners.","explanation":"A zigzag line changes direction at sharp angles and can be used to show energy or movement.","voice":"Which line is usually called a zigzag?"},
		{"id":"art_colour_01","subject":"ART","strand":"Colour","question":"Which pair are primary colours in traditional paint mixing?","answers":["Red and yellow","Green and orange","Pink and brown"],"correct":0,"hint":"Primary paint colours can be mixed to make other colours.","explanation":"In the traditional primary paint model taught at primary level, red, yellow and blue are primary colours.","voice":"Which pair are primary colours in traditional paint mixing: red and yellow, green and orange, or pink and brown?"},
		{"id":"dt_safety_01","subject":"DESIGN TECHNOLOGY","strand":"Design and making","question":"Before cutting card with scissors, what should you do?","answers":["Use them safely and follow instructions","Run while holding them","Point them at a friend"],"correct":0,"hint":"Tools must be handled carefully.","explanation":"Use scissors while sitting or standing safely, cut away from your body, and follow the teacher's instructions.","voice":"Before cutting card with scissors, what should you do?"},
		{"id":"dt_structure_01","subject":"DESIGN TECHNOLOGY","strand":"Structures","question":"Which shape can make a strong triangular support?","answers":["Triangle","Loose curve","Open line"],"correct":0,"hint":"Look at bridges and roof frames.","explanation":"Triangles are often used in structures because their shape helps resist changing shape under a load.","voice":"Which shape can make a strong triangular support?"},
		{"id":"mu_pulse_01","subject":"MUSIC","strand":"Pulse and rhythm","question":"What is the steady beat in music called?","answers":["Pulse","Volume","Silence"],"correct":0,"hint":"You might tap your foot to it.","explanation":"The pulse is the steady beat that you can often feel or tap along with in music.","voice":"What is the steady beat in music called?"},
		{"id":"mu_dynamics_01","subject":"MUSIC","strand":"Dynamics","question":"What does 'loud' describe in music?","answers":["Volume or dynamics","The song's spelling","The instrument's colour"],"correct":0,"hint":"It tells you how strong the sound is.","explanation":"Dynamics describe how loud or quiet music is performed.","voice":"What does loud describe in music?"},
		{"id":"pe_health_01","subject":"PE & HEALTH","strand":"Healthy movement","question":"Why is warming up before exercise helpful?","answers":["It prepares your body for movement","It means you never need water","It makes exercise unnecessary"],"correct":0,"hint":"Start gently before moving faster.","explanation":"A gentle warm-up gradually prepares your body for activity and helps you practise movements safely.","voice":"Why is warming up before exercise helpful?"},
		{"id":"pe_team_01","subject":"PE & HEALTH","strand":"Teamwork","question":"What is a good way to play a team game?","answers":["Take turns and encourage others","Always blame teammates","Ignore the rules"],"correct":0,"hint":"Think about fairness and respect.","explanation":"Taking turns, following rules and encouraging others helps everyone participate and learn.","voice":"What is a good way to play a team game?"},
		{"id":"pshe_feel_01","subject":"WELLBEING","strand":"Feelings and relationships","question":"If you feel worried at school, what is a good next step?","answers":["Tell a trusted adult","Keep it secret forever","Be unkind to someone"],"correct":0,"hint":"You do not have to solve every worry alone.","explanation":"A trusted adult can listen and help you decide what to do next. Asking for help is a strength.","voice":"If you feel worried at school, what is a good next step?"},
		{"id":"pshe_safe_01","subject":"WELLBEING","strand":"Safety","question":"You see someone being left out. What could you do?","answers":["Invite them to join if it is safe","Laugh at them","Tell everyone to ignore them"],"correct":0,"hint":"Small acts of kindness can help people feel included.","explanation":"Including others and telling a trusted adult if someone is being bullied can help make school safer and kinder.","voice":"You see someone being left out. What could you do?"},
		{"id":"ma_pattern_01","subject":"MATHS","strand":"Patterns","question":"What comes next? 5, 10, 15, 20, __","answers":["21","25","30"],"correct":1,"hint":"The numbers increase by the same amount each time.","explanation":"The pattern counts in fives. 20 + 5 = 25.","voice":"What comes next in five, ten, fifteen, twenty?"},
		{"id":"ma_odd_01","subject":"MATHS","strand":"Odd and even","question":"Which number is odd?","answers":["24","36","17"],"correct":2,"hint":"Odd numbers do not split into pairs with none left over.","explanation":"17 is odd. The even numbers 24 and 36 can be shared into pairs equally.","voice":"Which number is odd: twenty-four, thirty-six, or seventeen?"},
		{"id":"ma_compare_01","subject":"MATHS","strand":"Comparing numbers","question":"Choose the correct sign: 47 __ 42","answers":["<",">","="],"correct":1,"hint":"Both have 4 tens. Compare the ones.","explanation":"47 is greater than 42 because 7 ones is more than 2 ones, so use the greater-than sign.","voice":"Choose the correct sign: forty-seven compared with forty-two."},
		{"id":"en_pronoun_01","subject":"ENGLISH","strand":"Grammar","question":"Which word can replace 'Sam' in 'Sam is running'?","answers":["He","Run","Quickly"],"correct":0,"hint":"A pronoun can take the place of a noun.","explanation":"He can replace Sam in this sentence when referring to Sam, avoiding repeating the name.","voice":"Which word can replace Sam in Sam is running?"},
		{"id":"en_conj_01","subject":"ENGLISH","strand":"Grammar","question":"Which word joins these ideas: 'I was tired ___ I went to bed'?","answers":["and","because","under"],"correct":1,"hint":"Choose the word that explains the reason.","explanation":"Because links the ideas and gives the reason the person went to bed.","voice":"Which word joins these ideas: I was tired because I went to bed?"},
		{"id":"en_past_01","subject":"ENGLISH","strand":"Tenses","question":"Which sentence is in the past tense?","answers":["I walk home.","I walked home.","I will walk home."],"correct":1,"hint":"Which one tells you it already happened?","explanation":"Walked is the past-tense form here. Walk is present tense; will walk is future tense.","voice":"Which sentence is in the past tense?"},
		{"id":"sc_force_01","subject":"SCIENCE","strand":"Uses of materials","question":"Why might a saucepan have a metal base?","answers":["Metal transfers heat well","Metal is always soft","Metal stops all heat"],"correct":0,"hint":"Think about cooking on a hob.","explanation":"Many metals transfer heat well, helping heat move from the hob into the pan and food.","voice":"Why might a saucepan have a metal base?"},
		{"id":"sc_growth_01","subject":"SCIENCE","strand":"Animals and humans","question":"Which change happens as a human grows from a baby to an adult?","answers":["The body grows and changes","The body becomes a plant","The person stops needing food"],"correct":0,"hint":"Think about height, strength and development.","explanation":"Humans grow and change over time and need food, water, sleep and care throughout life.","voice":"Which change happens as a human grows from a baby to an adult?"},
		{"id":"ge_direction_01","subject":"GEOGRAPHY","strand":"Directions","question":"Which direction is opposite to north?","answers":["East","South","West"],"correct":1,"hint":"Look at the bottom of a compass rose.","explanation":"South is opposite north on a compass.","voice":"Which direction is opposite to north?"},
		{"id":"hi_timeline_01","subject":"HISTORY","strand":"Chronology","question":"What does a timeline show?","answers":["Events in time order","Only places on a map","The price of toys"],"correct":0,"hint":"Time moves from earlier to later.","explanation":"A timeline arranges events in chronological order, showing when things happened.","voice":"What does a timeline show?"},
		{"id":"co_data_01","subject":"COMPUTING","strand":"Data and instructions","question":"Which is a clear instruction for a computer?","answers":["Move forward 3 steps","Do something nice sometime","Guess what I mean"],"correct":0,"hint":"Good instructions are precise.","explanation":"Move forward 3 steps gives a specific action and amount, so it is clearer to follow.","voice":"Which is a clear instruction for a computer?"},
		{"id":"dt_material_01","subject":"DESIGN TECHNOLOGY","strand":"Materials","question":"Which material is a good choice for a waterproof rain shelter?","answers":["Waterproof fabric","Tissue paper","Uncoated thin paper"],"correct":0,"hint":"Choose a material that does not let rain pass through easily.","explanation":"Waterproof fabric helps keep rain out. Designers choose materials to suit the product's purpose.","voice":"Which material is a good choice for a waterproof rain shelter?"},
		{"id":"mu_tempo_01","subject":"MUSIC","strand":"Tempo","question":"What does tempo mean in music?","answers":["How fast or slow it is","How tall the singer is","How many words are written"],"correct":0,"hint":"A song can be fast or slow.","explanation":"Tempo is the speed of the music or its beat.","voice":"What does tempo mean in music?"},
		{"id":"ma_capacity_01","subject":"MATHS","strand":"Measurement","question":"Which unit would you use to measure the amount of water in a bottle?","answers":["Litres or millilitres","Metres","Kilograms only"],"correct":0,"hint":"Choose a unit for capacity.","explanation":"Litres and millilitres measure liquid capacity. Metres measure length.","voice":"Which unit would you use to measure the amount of water in a bottle?"},
		{"id":"en_read_02","subject":"ENGLISH","strand":"Comprehension","question":"A story says, 'Ben shivered and pulled his scarf tighter.' What can you infer?","answers":["Ben may be cold","Ben is definitely swimming","Ben is eating lunch"],"correct":0,"hint":"Use clues in the text to work something out.","explanation":"Shivering and tightening a scarf are clues that Ben may feel cold. This is an inference.","voice":"A story says Ben shivered and pulled his scarf tighter. What can you infer?"},
		{"id":"sc_weather_01","subject":"SCIENCE","strand":"Seasonal changes","question":"What should you do to compare weather fairly over a week?","answers":["Record observations regularly","Guess at the end","Change the measuring tool each time"],"correct":0,"hint":"Scientists make observations and record them consistently.","explanation":"Regular, consistent records help you compare weather changes across the week.","voice":"What should you do to compare weather fairly over a week?"},
		{"id":"ge_place_01","subject":"GEOGRAPHY","strand":"Places","question":"Which is a human feature of a town?","answers":["A shop","A hill","A natural stream"],"correct":0,"hint":"Human features are built or created by people.","explanation":"A shop is built for people to use. Hills and natural streams are physical features.","voice":"Which is a human feature of a town: a shop, a hill, or a natural stream?"},
		{"id":"ma_2d_01","subject":"MATHS","strand":"Shape","question":"Which shape has four equal sides and four right angles?","answers":["Square","Triangle","Circle"],"correct":0,"hint":"It has four corners and every side is the same length.","explanation":"A square has four equal sides and four right angles.","voice":"Which shape has four equal sides and four right angles?"},
		{"id":"en_caps_01","subject":"ENGLISH","strand":"Punctuation","question":"Which word needs a capital letter at the start of this sentence: 'on monday, we went to the park.'?","answers":["monday","went","park"],"correct":0,"hint":"Days of the week begin with capital letters in English.","explanation":"Monday is the name of a day, so it starts with a capital M. Sentences also begin with a capital letter.","voice":"Which word needs a capital letter in the sentence on Monday, we went to the park?"},
		{"id":"sc_classify_01","subject":"SCIENCE","strand":"Living things","question":"Which feature helps you identify a bird?","answers":["Feathers","Six legs","Gills"],"correct":0,"hint":"Think of what covers a bird's body.","explanation":"Birds have feathers. Other features, such as wings and beaks, also help us identify many birds.","voice":"Which feature helps you identify a bird: feathers, six legs, or gills?"},
		{"id":"co_sequence_01","subject":"COMPUTING","strand":"Algorithms","question":"If an instruction says 'repeat 3 times', how many times should the action happen?","answers":["2","3","4"],"correct":1,"hint":"The number tells you how many repeats.","explanation":"Repeat 3 times means carry out the action three times.","voice":"If an instruction says repeat three times, how many times should the action happen?"}
	]

	_append_generated_questions(result)
	return result

static func _append_generated_questions(result: Array[Dictionary]) -> void:
	var words := ["apple", "bridge", "garden", "rabbit", "window", "planet", "pocket", "yellow", "school", "basket", "thunder", "careful", "bright", "family", "winter", "teacher", "market", "flower", "picture", "journey"]
	var science_facts := [
		["Which part of a plant absorbs water?","Roots","Petals","Seeds","Roots take in water from the soil.","Plants"],
		["Which material is transparent?","Clear glass","Brick","Wood","Transparent materials let light pass through so we can see through them.","Materials"],
		["Which animal is a mammal?","Dolphin","Frog","Ant","Dolphins are mammals because they breathe air and feed milk to their young.","Animals"],
		["What do plants need to grow?","Light and water","Plastic and darkness","Only stones","Most plants need light, water, air and suitable conditions to grow.","Plants"],
		["Which sense uses your ears?","Hearing","Taste","Smell","Ears help us hear sounds.","Humans"],
		["Which season has the shortest days in the UK?","Winter","Summer","Spring","Winter usually has the fewest daylight hours in the UK.","Seasonal changes"],
		["What does a magnet attract?","Iron","Paper","Rubber","Magnets attract iron and some other magnetic materials.","Materials"],
		["Which animal begins life as a caterpillar?","Butterfly","Cat","Robin","A butterfly's life cycle includes egg, caterpillar, chrysalis and adult.","Life cycles"],
		["Which material is waterproof?","A raincoat fabric","Tissue paper","Uncoated paper","Waterproof materials stop or resist water passing through.","Materials"],
		["What is a habitat?","A place where an organism lives","A kind of number","A musical note","A habitat provides the conditions a living thing needs.","Living things"]
	]
	var computing_facts := [
		["What is an algorithm?","A sequence of instructions","A type of fruit","A computer cable","An algorithm is a clear sequence of steps to complete a task.","Algorithms"],
		["What does debugging mean?","Finding and fixing errors","Turning the screen brighter","Drawing a picture","Debugging means locating and correcting errors in a program.","Debugging"],
		["What should you do with a stranger's request for your address online?","Tell a trusted adult and keep it private","Post it publicly","Send it straight away","Personal information should not be shared with strangers online.","Online safety"],
		["Which instruction is clearest?","Move forward 3 steps","Do something sometime","Guess what I mean","A precise instruction is easier for a person or computer to follow.","Instructions"],
		["What is a computer program?","Instructions a computer follows","A kind of sandwich","A school uniform","Programs contain instructions that a computer can carry out.","Programming"]
	]
	var geography_facts := [
		["What does a map key explain?","Map symbols","A story ending","The age of a map","A map key explains what symbols on a map represent.","Maps"],
		["Birmingham is in which UK country?","England","Scotland","Wales","Birmingham is a city in the West Midlands of England.","United Kingdom"],
		["Which is a physical feature?","A river","A supermarket","A bridge","Rivers are natural physical features; shops and bridges are human features.","Human and physical features"],
		["Which instrument shows direction?","Compass","Rain gauge","Thermometer","A compass helps you find directions such as north and south.","Directions"],
		["Which is a human feature?","A school","A mountain","A natural lake","Schools are built by people and are human features.","Places"]
	]
	var history_facts := [
		["What does a timeline show?","Events in time order","Map symbols only","The weather forecast","Timelines arrange events from earlier to later.","Chronology"],
		["What can an old photograph tell a historian?","Clues about life in the past","Exactly what everyone thought","Nothing at all","Photographs are evidence, but historians compare different sources.","Historical sources"],
		["Florence Nightingale is remembered for her work in what field?","Nursing","Space travel","Painting the Mona Lisa","Nightingale helped improve nursing and hospital care.","Significant people"],
		["Neil Armstrong was famous for doing what?","Walking on the Moon","Discovering electricity","Building the pyramids","Neil Armstrong became the first person to walk on the Moon in 1969.","Significant people"],
		["Which is a source from the past?","An old diary","A future prediction","A made-up guess","A diary can provide evidence about what someone experienced in the past.","Historical sources"]
	]
	var english_facts := [
		["Which word is a noun?","garden","quickly","under","A noun names a person, place, thing or idea.","Grammar"],
		["Which word is a verb?","jumped","purple","softly","A verb can describe an action or state.","Grammar"],
		["Which word is an adjective?","shiny","carefully","yesterday","An adjective describes a noun.","Grammar"],
		["Which punctuation mark ends a question?","?","! ",",","A question mark goes at the end of a direct question.","Punctuation"],
		["Which word means the same as enormous?","huge","tiny","quiet","Enormous and huge both mean very large.","Vocabulary"],
		["Which word is spelled correctly?","because","becos","becuase","Because is the correct spelling.","Spelling"],
		["Which sentence is complete?","The dog barked.","Under the table","Because it was","A complete sentence expresses a complete idea.","Sentences"],
		["Which word is a conjunction?","because","blue","quickly","Because can join ideas and explain a reason.","Grammar"],
		["Which word is a pronoun?","they","running","green","A pronoun can replace a noun or noun phrase.","Grammar"],
		["What does an apostrophe show in 'Sam's hat'?","Possession","A question","A plural verb","Sam's shows that the hat belongs to Sam.","Punctuation"]
	]
	var music_facts := [
		["What is the steady beat in music called?","Pulse","Volume","Colour","The pulse is the steady beat that listeners can tap along to.","Pulse and rhythm"],
		["What does tempo describe?","How fast or slow music is","The size of a drum","The colour of a piano","Tempo is the speed of music.","Tempo"],
		["What do dynamics describe?","How loud or quiet music is","How long a book is","The shape of a note","Dynamics describe changes in loudness and softness.","Dynamics"]
	]
	var art_facts := [
		["Which tool can make a charcoal drawing?","Charcoal stick","Measuring jug","Screwdriver","Charcoal can make dark marks and varied tones in art.","Drawing"],
		["Which pair are primary colours in traditional paint mixing?","Red and yellow","Green and orange","Pink and brown","Red, yellow and blue are commonly taught as primary paint colours.","Colour"],
		["What can texture describe in art?","How a surface looks or feels","The time on a clock","A number pattern","Texture can be real or created to look like a surface.","Texture"]
	]
	var dt_facts := [
		["Why do designers test a model?","To see what works and improve it","To avoid making changes","To hide every problem","Testing helps designers evaluate and improve a product.","Design process"],
		["Which material is suitable for a waterproof shelter?","Waterproof fabric","Tissue paper","Dry sand","Designers choose materials to suit the product's purpose.","Materials"],
		["Which shape is often used to strengthen a frame?","Triangle","Loose curve","Open line","Triangles help structures keep their shape under a load.","Structures"]
	]
	var pe_facts := [
		["Why warm up before exercise?","To prepare the body for movement","So you never need water","To avoid moving","A warm-up gradually prepares the body for activity.","Healthy movement"],
		["What shows good teamwork?","Taking turns and encouraging others","Blaming teammates","Ignoring the rules","Fair play includes respect, turn-taking and encouragement.","Teamwork"]
	]
	var wellbeing_facts := [
		["What can you do if you feel worried at school?","Talk to a trusted adult","Keep every worry secret","Be unkind to someone","A trusted adult can listen and help you decide what to do.","Feelings and relationships"],
		["How can you help someone who is left out?","Invite them to join if it is safe","Laugh at them","Tell others to ignore them","Kindness and inclusion help people feel welcome.","Relationships"]
	]
	var maths_facts := [["What is the total?","Add the two numbers","Subtract the smaller number","Multiply the numbers","Arithmetic"],["Which operation shares equally?","Division","Addition only","Subtraction only","Division"],["What does the digit in the tens place represent?","Groups of ten","Single ones","Groups of one hundred","Place value"]]
	var fact_groups: Array = [maths_facts, english_facts, science_facts, computing_facts, geography_facts, history_facts, music_facts, art_facts, dt_facts, pe_facts, wellbeing_facts]
	var subjects := ["MATHS","ENGLISH","SCIENCE","COMPUTING","GEOGRAPHY","HISTORY","MUSIC","ART","DESIGN TECHNOLOGY","PE & HEALTH","WELLBEING"]
	var serial := 0
	# Generate unique retrieval-practice variants across the full subject mix.
	while result.size() < 1000:
		var slot := serial % 11
		var group: Array = fact_groups[slot]
		var fact: Array = group[int((serial / 11) % group.size())]
		var subject: String = subjects[slot]
		var stem := str(fact[0])
		var correct_answer := str(fact[1])
		var wrong_one := str(fact[2])
		var wrong_two := str(fact[3])
		var options: Array = [correct_answer, wrong_one, wrong_two]
		var shift := serial % 3
		for rotate in range(shift):
			options.push_back(options.pop_front())
		var question_text := stem
		var explanation_text := "The correct answer is " + correct_answer + ". " + str(fact[4]) + " is the key idea to remember."
		# Make each practice item distinct while revisiting the same curriculum idea in a new retrieval format.
		var cycle := int(serial / 11)
		if subject == "MATHS":
			var a: int = 12 + ((cycle * 7) % 79)
			var b: int = 2 + ((cycle * 5) % 38)
			var operation: int = cycle % 4
			var numeric_answer: int = 0
			if operation == 0:
				numeric_answer = a + b
				question_text = "What is %d + %d?" % [a, b]
				explanation_text = "%d + %d = %d. Add the tens and ones, then check your total." % [a, b, numeric_answer]
			elif operation == 1:
				if b >= a:
					a = b + 1
				numeric_answer = a - b
				question_text = "What is %d − %d?" % [a, b]
				explanation_text = "%d − %d = %d. Subtraction tells us the difference between numbers." % [a, b, numeric_answer]
			elif operation == 2:
				a = 2 + (cycle % 10)
				b = 2 + ((cycle * 3) % 10)
				numeric_answer = a * b
				question_text = "There are %d groups of %d. How many altogether?" % [a, b]
				explanation_text = "%d groups of %d means %d × %d = %d." % [a, b, a, b, numeric_answer]
			else:
				a = 2 + (cycle % 9)
				numeric_answer = a * b
				question_text = "Share %d counters equally into %d groups. How many in each group?" % [numeric_answer, a]
				explanation_text = "%d ÷ %d = %d because %d groups of %d make %d." % [numeric_answer, a, b, a, b, numeric_answer]
			correct_answer = str(numeric_answer)
			options = [correct_answer, str(numeric_answer + 1), str(maxi(0, numeric_answer - 1))]
			wrong_one = str(numeric_answer + 1)
			wrong_two = str(maxi(0, numeric_answer - 1))
		elif subject == "ENGLISH":
			var word: String = words[cycle % words.size()]
			match cycle % 4:
				0:
					question_text = "Which word is a noun in this group: " + word + ", quickly, under?"
					options = [word, "quickly", "under"]
					correct_answer = word
				1:
					question_text = "Which word is closest in meaning to '" + ["happy","small","fast","quiet","bright"][cycle % 5] + "'?"
					var synonyms := [["glad","angry","empty"],["tiny","enormous","noisy"],["quick","slow","soft"],["silent","hungry","bright"],["shiny","dark","heavy"]][cycle % 5]
					options = synonyms
					correct_answer = str(synonyms[0])
				2:
					question_text = "Which word is spelled correctly: " + word + ", " + word.substr(0, maxi(1, word.length()-1)) + ", or " + word + "x?"
					options = [word, word.substr(0, maxi(1, word.length()-1)), word + "x"]
					correct_answer = word
				3:
					question_text = "Choose the conjunction to complete: 'I smiled ___ I was pleased.'"
					options = ["because","under","purple"]
					correct_answer = "because"
		elif subject == "SCIENCE":
			question_text = str(fact[0])
			explanation_text = str(fact[4]) + " The best answer is " + correct_answer + "."
		elif subject == "COMPUTING" or subject == "GEOGRAPHY" or subject == "HISTORY" or subject == "MUSIC" or subject == "ART" or subject == "DESIGN TECHNOLOGY" or subject == "PE & HEALTH" or subject == "WELLBEING":
			question_text = str(fact[0])
			explanation_text = str(fact[4]) + " The correct choice is " + correct_answer + "."
		if subject != "MATHS":
			var child_names := ["Mia", "Ben", "Aisha", "Noah", "Zara", "Leo", "Amir", "Grace", "Ella", "Jayden"]
			var situations := ["is learning in class and asks: ", "is exploring a garden and wonders: ", "is helping a friend and asks: ", "is reading a library book and asks: ", "is on a school trip and wonders: ", "is working with a team and asks: ", "is making a poster and asks: ", "is investigating a question and asks: ", "is explaining an idea and asks: ", "is exploring the playground and asks: "]
			question_text = child_names[cycle % child_names.size()] + " " + situations[int(cycle / child_names.size()) % situations.size()] + question_text
		var correct_index := options.find(correct_answer)
		if correct_index < 0:
			correct_index = 0
		var wrong_options: Array = []
		for option in options:
			if str(option) != correct_answer and not wrong_options.has(str(option)):
				wrong_options.append(str(option))
		while wrong_options.size() < 2:
			wrong_options.append("Not " + correct_answer + " " + str(wrong_options.size() + 1))
		var final_answers: Array = [correct_answer, wrong_options[0], wrong_options[1]]
		# Rotate the right answer so children cannot learn a fixed button position.
		var answer_shift := serial % 3
		for rotate in range(answer_shift):
			final_answers.push_back(final_answers.pop_front())
		correct_index = final_answers.find(correct_answer)
		result.append({
			"id": "gen_%04d" % serial,
			"subject": subject,
			"strand": str(fact[4]),
			"question": question_text,
			"answers": final_answers,
			"correct": correct_index,
			"hint": "Think about the clue in the question. Can you explain your choice?",
			"explanation": explanation_text,
			"voice": question_text
		})
		serial += 1
